# routers/image_analysis.py
from fastapi import APIRouter, File, UploadFile, Depends, HTTPException, Request
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
import os
import google.generativeai as genai
import cv2
from pathlib import Path
from services.image_classifier import classify_image  # 새로 만든 서비스 import
from translation import yolo_va_efficientNet
from services import recipe_service
import db
from typing import List
import numpy as np
from core.dependencies import get_yolo_model, get_classifier_model

google_api_key = os.getenv("GOOGLE_API_KEY")
if not google_api_key:
    raise ValueError("GOOGLE_API_KEY not found in .env")
genai.configure(api_key=google_api_key)
gemini_vision_model = genai.GenerativeModel("gemini-2.0-flash-exp")

router = APIRouter()


# yolo와 efficientNet을 같이 사용
@router.post("/hybrid-recipe", summary="여러 이미지로 재료 종합 분석 후 레시피 추천")
async def recommend_from_hybrid_analysis(
    files: List[UploadFile] = File(
        ..., description="분석할 이미지를 여러 장 업로드합니다. "
    ),
    model_yolo=Depends(get_yolo_model),
    model_classifier=Depends(get_classifier_model),
    request: Request = None,
):
    """여러 이미지를 받아서 YOLO와 EfficientNet으로 각각 분석하고, 모든 결과를 종합해서 최종 재료 목록을 만든 뒤, 레시피 추천 함수에 전달"""

    if not files:
        raise HTTPException(status_code=400, detail="이미지 파일이 없습니다.")

    all_ingredients_en = set()  # 중복을 자동으로 제거하기 위해 set 사용

    # 분석할 결과를 저장할 리스트
    analysis_details = []

    for file in files:
        file_summary = {
            "filename": file.filename,
            "status": "failed",
            "found_ingredients": [],
        }

        try:
            # 파일 내용을 한 번만 읽어서 메모리에 저장
            contents = await file.read()

            # --- 1. YOLO 분석 ---
            yolo_ingredients = set()
            try:
                img_yolo = cv2.imdecode(
                    np.frombuffer(contents, np.uint8), cv2.IMREAD_COLOR
                )
                if img_yolo is None:
                    raise ValueError("이미지 파일을 디코딩할 수 없습니다.")

                results_yolo = model_yolo(img_yolo)
                yolo_ingredients = set(results_yolo.pandas().xyxy[0]["name"].tolist())
                if "other" in yolo_ingredients:
                    yolo_ingredients.remove("other")
                all_ingredients_en.update(yolo_ingredients)
                print(f"### YOLO 분석 결과 ({file.filename}): {yolo_ingredients}")
            except Exception as e:
                print(f"### YOLO 분석 중 오류 ({file.filename}): {e}")

            # --- 2. EfficientNet 분석 ---
            eff_ingredient = None
            try:
                # classify_image 함수는 UploadFile 객체를 받도록 되어있으므로,
                # 다시 UploadFile처럼 만들어주거나, classify_image를 바이트를 받도록 수정해야 합니다.
                # 여기서는 간단히 classify_image를 직접 호출하지 않고 로직을 가져옵니다.
                # 다음 파일을 위해 커서 위치를 처음으로 되돌림 (중요)
                await file.seek(0)
                result_eff = await classify_image(model_classifier, file)
                eff_ingredient = result_eff.get("class")
                print(f"### EfficientNet 분석 결과 ({file.filename}): {eff_ingredient}")
            except Exception as e:
                print(f"### EfficientNet 분석 중 오류 ({file.filename}): {e}")

            # 결과 종합
            found_now = yolo_ingredients.copy()
            if eff_ingredient:
                found_now.add(eff_ingredient)

            if found_now:
                all_ingredients_en.update(found_now)
                file_summary["status"] = "success"
                file_summary["found_ingredients"] = list(found_now)

        except Exception as e:
            # 파일 읽기 등에서 근본적인 오류 발생 시
            print(f"### 파일 처리 중 심각한 오류 ({file.filename}): {e}")
            file_summary["error_message"] = "파일을 처리할 수 없습니다."

        analysis_details.append(file_summary)

    if not all_ingredients_en:
        raise HTTPException(
            status_code=400, detail="모든 이미지에서 유효한 재료를 찾지 못했습니다."
        )

    print(f"### 종합된 영어 재료: {all_ingredients_en}")

    # --- 3. 한국어로 번역 ---
    # yolo_va_efficientNet -> 번역 딕셔너리 이름은 프로젝트에 맞게 수정하세요.
    ingredients_ko = [yolo_va_efficientNet.get(ing, ing) for ing in all_ingredients_en]
    print(f"### 최종 한국어 재료 목록: {ingredients_ko}")

    # --- 4. 통합 레시피 추천 함수 호출 ---
    response = await recipe_service.process_recipe_prediction(
        include_ingredients=ingredients_ko, request=request
    )

    # --- 5. 사용자 이력 저장 ---
    user_no = request.session.get("user_no") if request else None
    if user_no and response.get("recipe"):
        # 첫 번째 레시피를 기준으로 이력 저장
        main_recipe = response["recipe"][0]
        if main_recipe.get("recipe_id"):
            db.save_user_recipe_history(user_no, main_recipe, ingredients_ko)

    return {
        "analysis_summary": analysis_details,
        "final_ingredients_ko": ingredients_ko,
        "response": response,
    }


# yolo만 사용
@router.post("/yolo", summary="YOLOv5로 재료 인식")
async def predict_with_yolo(
    request: Request, file: UploadFile = File(...), model=Depends(get_yolo_model)
):
    # (기존 main.py에 있던 predict_and_recipe 함수 내용 전체를 여기에 복사-붙여넣기, 이름 변경)
    if "user_no" in request.session:
        print("\n\n세션 ID (process_image_recipe):", request.session["user_no"])

    contents = await file.read()
    image_path = f"temp_{file.filename}"
    with open(image_path, "wb") as f:
        f.write(contents)

    img = cv2.imread(image_path)
    Path(image_path).unlink(missing_ok=True)

    if img is None:
        raise HTTPException(status_code=400, detail="이미지 로드 실패")

    print(f"\n\n이미지 로드 성공: {image_path}, shape: {img.shape}")

    # 여기서 model_yolo는 main.py에서 import 해온 전역 변수
    results = model(img)
    print(f"모델 결과 타입: {type(results)}, 내용: {results}")

    ingredients_en = list(set(results.pandas().xyxy[0]["name"].tolist()))
    print(f"중복 제거된 영어 식재료: {ingredients_en}")

    if "other" in ingredients_en:
        Path(image_path).unlink(missing_ok=True)
        raise HTTPException(status_code=400, detail="정확한 이미지를 넣어주세요")

    ingredients_ko = [yolo_va_efficientNet.get(ing, ing) for ing in ingredients_en]
    print(f"변환된 한국어 식재료: {ingredients_ko}")

    # 순수하게 분석된 '재료 리스트'만 반환
    return {"ingredients": ingredients_ko}


# efficientNet만 사용
@router.post("/classify", summary="EfficientNet으로 이미지 분류")
async def predict_with_classifier(
    request: Request, file: UploadFile = File(...), model=Depends(get_classifier_model)
):
    """ " EfiicientNet으로 이미지를 분류하고 그 재료를 기반으로 레시피 추천"""
    try:
        result = await classify_image(model, file)
        ingredient_en = result.get("class")

        if not ingredient_en:
            raise HTTPException(
                status_code=400, detail="정확한 이미지를 업로드 해주세요."
            )

        ingredient_ko = yolo_va_efficientNet.get(ingredient_en, ingredient_en)
        print(f"### efficientNet 이미지 분류 결과: {ingredient_en} -> {ingredient_ko}")

        ingredient_list = [ingredient_ko]

        response = await recipe_service.process_recipe_prediction(
            ingredient_list, request
        )

        # 사용자 레시피 이력 저장
        user_no = request.session.get("user_no")
        if user_no and response.get("recipe"):
            main_recipe = response["recipe"][0]

            if main_recipe.get("recipe_id"):
                db.save_user_recipe_history(user_no, main_recipe, ingredient_list)
        return response

    except Exception as e:
        print(f"efficientNet error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


# 이미지를 gemini vision이 분석
@router.post(
    "/gemini-vision",
    summary="Gemini Vision으로 여러 이미지에서 재료 인식 후 레시피 추천",
)
async def recipe_from_gemini_vision(
    files: List[UploadFile] = File(..., description="분석할 이미지 여러장 업로드."),
    request: Request = None,
):
    """Gemini Vision으로 여러 이미지 속 재료를 동시에 식별하고, 그 재료들을 레시피 추천 함수에 전달"""

    if not files:
        raise HTTPException(status_code=400, detail="이미지 파일이 없습니다.")

    try:
        # 프롬프트를 훨씬 더 구체적이고 강력하게 수정
        # Gemini Vision은 이미지 속 재료만 식별
        prompt = """
            당신은 이미지 속 식재료를 식별하여, 그 이름을 정확한 '한글 단어'로만 출력하는 시스템입니다.
            주어진 이미지(들)에 있는 모든 식재료의 이름을 식별하세요.
            
            [규칙]
            1. 결과는 반드시 쉼표(,)로 구분된 단일 텍스트 라인이어야 합니다.
            2. 각 이름은 '오이', '당근', '소고기'처럼 완전한 명사 형태여야 합니다. 절대로 글자를 "오", "이" 처럼 분리해서는 안 됩니다.
            3. 이미지에 없는 것은 절대 언급하지 마세요.
            4. 번호, 설명, 줄바꿈 등 다른 어떤 텍스트도 포함하지 마세요. 오직 식재료 이름 목록만 출력해야 합니다.

            [좋은 예시]
            오이,당근,소고기,양파

            [나쁜 예시]
            1. 오이\n2. 당근
            오,이,당,근
            이미지에는 오이와 당근이 보입니다.

            이제 아래 이미지들을 분석하여 규칙에 맞는 결과를 출력하세요.
            """

        prompt_parts = [prompt]

        # 각 이미지 파일을 읽어서 프롬프트 리스트에 추가
        for file in files:
            image_bytes = await file.read()
            mime_type = (
                file.content_type
                if file.content_type and file.content_type.startswith("image")
                else "image/jpeg"
            )
            prompt_parts.append({"mime_type": mime_type, "data": image_bytes})

        # Gemini vision 모델 호출
        response = await gemini_vision_model.generate_content_async(prompt_parts)

        # 응답 텍스트를 파싱해서 재료 리스트 만들기
        ingredients_text = response.text.strip()
        if not ingredients_text:
            raise HTTPException(
                status_code=400, detail="이미지에서 재료를 인식할 수 없습니다."
            )

        # 분석 결과에서 재료 파싱
        # 쉼표를 기준으로 나누고, 각 항목의 공백 제거, 빈 항목은 버리기
        ingredients_ko = [
            ing.strip() for ing in ingredients_text.split(",") if ing.strip()
        ]
        print(f"### Gemini Vision 종합 분석 결과: {ingredients_ko}")

        # 분석된 결과가 없는 경우에 대한 추가 처리
        if not ingredients_ko:
            raise HTTPException(
                status_code=400, detail="분석된 유효한 재료가 없습니다."
            )

        # 레시피 추천 함수 호출
        recipe_response = await recipe_service.process_recipe_prediction(
            include_ingredients=ingredients_ko, request=request
        )

        # 사용자 레시피 이력 저장
        user_no = request.session.get("user_no") if request else None
        if user_no and recipe_response.get("recipes"):
            main_recipe = recipe_response["recipes"][0]
            if main_recipe.get("recipe_id"):
                db.save_user_recipe_history(user_no, main_recipe, ingredients_ko)

        # 반환 구조를 hybrid-recipe와 통일
        final_response = {
            # hybrid-recipe와 같이 분석 요약 정보를 추가
            "analysis_summary": [
                {
                    "filename": "gemini_vision_analysis",
                    "status": "success",
                    "found_ingredients": ingredients_ko,
                }
            ],
            "final_ingredients_ko": ingredients_ko,
            "response": recipe_response,
        }

        return jsonable_encoder(final_response)

    except Exception as e:
        print(f"### Gemini Vision 추천 오류: {e}")
        raise HTTPException(
            status_code=500, detail="이미지 분석 중 서버에 문제가 발생했습니다."
        )
