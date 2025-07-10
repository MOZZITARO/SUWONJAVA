# routers/recipes.py
from fastapi import APIRouter, UploadFile, File, Request, Form, Query, HTTPException
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from pathlib import Path
import cv2
import torch
from pydantic import BaseModel
from typing import List
import re

# 다른 모듈에서 필요한 함수들을 import 합니다.
import db
import api_utils
import translation
from core.sessions import get_user_no_from_session
from services import recipe_service


# 요청 본문을 위한 Pydantic 모델 정의
class InstructionsPayload(BaseModel):
    manuals: List[str]
    tip: str = ""


# APIRouter 인스턴스 생성
router = APIRouter()


class IngredientsPayload(BaseModel):
    ingredients: List[str]


# --- API 엔드포인트들 ---


@router.post("/generate-description", summary="Gemini로 레시피 설명 생성 (비동기)")
async def generate_description_with_gemini(payload: InstructionsPayload):
    """원본 레시피의 조리법 텍스트 목록을 받아서 Gemini로 자연스러운 설명을 생성합니다."""

    if not payload.manuals:
        raise HTTPException(status_code=400, detail="설명을 생성할 내용이 없습니다.")

    print("### (비동기) Gemini 설명 생성 시작...")
    gemini_desc = await api_utils.fetch_recipe_description_from_gemini(
        payload.manuals, tip=payload.tip
    )

    if not gemini_desc:
        raise HTTPException(status_code=500, detail="설명 생성에 실패했습니다.")

    print("### (비동기) Gemini 설명 생성 완료!")

    # 생성된 설명을 줄바꿈 기준으로 분리해서 리스트로 변환
    # return {"generated_instructions": gemini_desc.split("\n\n")}

    # Gemini가 생성한 전체 텍스트를 분리해서 구조화된 데이터로 변환
    try:
        # 정규표현식을 사용하여 각 섹션을 정확하게 추출
        manuals_match = re.search(
            r"### 단계별 설명 시작 ###(.*)### 단계별 설명 끝 ###",
            gemini_desc,
            re.DOTALL,
        )
        tip_match = re.search(
            r"### 팁 설명 시작 ###(.*)### 팁 설명 끝 ###", gemini_desc, re.DOTALL
        )

        if not manuals_match:
            # 설명 부분을 찾지 못하면 원본 데이터로 대체하거나 에러 처리
            raise ValueError("응답에서 단계별 설명을 찾을 수 없습니다.")

        manuals_text = manuals_match.group(1).strip()
        tip_text = tip_match.group(1).strip() if tip_match else ""

        # "--- 단계 구분선 ---"을 기준으로 각 단계 설명 분리
        generated_manuals = [
            m.strip() for m in manuals_text.split("--- 단계 구분선 ---") if m.strip()
        ]

    except Exception as e:
        # 파싱 실패 시 예외 처리
        print(f"Gemini 응답 파싱 실패: {e}")
        # 실패 시 클라이언트가 원본을 사용하도록 빈 데이터를 보낼 수 있음
        return {"generated_instructions": [], "generated_tip": ""}

    return {"generated_instructions": generated_manuals, "generated_tip": tip_text}


@router.post("/by-ingredients", summary="재료 리스트로 레시피 추천")
async def recipe_by_ingredients(payload: IngredientsPayload, request: Request):
    ingredients_ko = payload.ingredients
    if not ingredients_ko:
        raise HTTPException(status_code=400, detail="재료가 없습니다.")

    # 기존의 레시피 예측 로직을 그대로 사용
    response = await recipe_service.process_recipe_prediction(ingredients_ko, request)

    # 사용자 레시피 이력 저장 로직 추가
    user_no = request.session.get("user_no")
    if user_no and response.get("recipe"):
        main_recipe = response["recipe"][0]
        db.save_user_recipe_history(user_no, main_recipe, ingredients_ko)

    return response


@router.get("/detail", summary="레시피 상세 정보 표시")
async def get_recipe_detail(recipe_id: int, request: Request):
    # (기존 main.py에 있던 get_recipe_detail 함수 내용 전체를 여기에 복사-붙여넣기)

    user_no = request.session.get("user_no")
    print(f"### 레시피 상세 요청 (기본): recipe_id={recipe_id}, user_no={user_no}")
    recipe = db.fetch_recipe_from_db(recipe_id)

    if not recipe:
        return JSONResponse(
            content={"error": "레시피를 찾을 수 없습니다."}, status_code=404
        )

    # generate_description_with_gemini()에서 레시피 만드는 법 생성
    # original_instructions = recipe.get("instructions", [])
    # manual_texts = [
    #     inst.get("description", "")
    #     for inst in original_instructions
    #     if inst.get("description")
    # ]

    # if manual_texts:
    #     # print("### ollama 설명 생성 시작")
    #     print("### gemini 설명 생성 시작")
    #     # ollama_desc = await api_utils.fetch_recipe_description_from_ollama(
    #     gemini_desc = await api_utils.fetch_recipe_description_from_gemini(
    #         manual_texts, tip=recipe.get("tip")
    #     )
    #     if gemini_desc:
    #         print(f"### gemini 설명 생성 완료! \n{gemini_desc}")
    #         new_instructions = []
    #         # ollama_steps = ollama_desc.split("\n")
    #         gemini_steps = gemini_desc.split("\n\n")
    #         for i, original_inst in enumerate(original_instructions):
    #             new_inst = original_inst.copy()
    #             # if i < len(ollama_steps) and ollama_steps[i].strip():
    #             #     new_inst["description"] = ollama_steps[i].strip()
    #             if i < len(gemini_steps) and gemini_steps[i].strip():
    #                 new_inst["description"] = gemini_steps[i].strip()
    #             new_instructions.append(new_inst)
    #         recipe["instructions"] = new_instructions

    #         # user_no = request.session.get("user_no")
    #         if user_no and gemini_desc:
    #             #     print(
    #             #         f"### (회원) Ollama 설명을 DB에 저장합니다. user_no: {user_no}, recipe_id: {recipe_id}"
    #             #     )
    #             print(
    #                 f"### (회원) Gemini 설명을 DB에 저장합니다. user_no: {user_no}, recipe_id: {recipe_id}"
    #             )
    #             db.save_ollama_description(user_no, recipe_id, gemini_desc)
    #         else:
    #             # print("### (비회원) Ollama 설명을 세션에 저장합니다.")
    #             print("### (비회원) Gemini 설명을 세션에 저장합니다.")
    #     else:
    #         # print("### ollama 설명 생성 실패, 기존 설명 유지")
    #         print("### Gemini 설명 생성 실패, 기존 설명 유지")

    # user_no = request.session.get("user_no")
    if user_no and recipe:
        # 이력 저장에 필요한 '선택 재료' 정보는 현재 알 수 없으므로,
        # 어떤 재료로 이 추천을 받았는지 알 수 없다는 단점이 있음.
        # 우선은 재료 없이 저장하거나, 세션/DB를 통해 전달하는 고급 기법 필요.
        # 여기서는 '재료'를 빈 문자열로 저장.
        print(f"### 사용자 {user_no}의 레시피(ID:{recipe_id}) 조회 이력을 저장합니다.")
        db.save_user_recipe_history(user_no, recipe, [])

    return jsonable_encoder(recipe)


@router.post("/refrigerator/", summary="냉장고 재료로 레시피 추천")
async def recipe_from_refrigerator(
    request: Request, selected_ingredients: str = Form(...), user_no: str = Form(...)
):
    # (기존 main.py에 있던 recipe_from_refrigerator 함수 내용 전체를 여기에 복사-붙여넣기)
    if not user_no:
        raise HTTPException(status_code=400, detail="사용자 정보가 없습니다.")

    print(f"### user_no: {user_no}, 선택된 식재료: {selected_ingredients}")

    ingredients_ko = [
        ing.strip() for ing in selected_ingredients.split(",") if ing.strip()
    ]
    if not ingredients_ko:
        raise HTTPException(status_code=400, detail="체크된 식재료가 없습니다")

    response = await recipe_service.process_recipe_prediction(
        include_ingredients=ingredients_ko, request=request
    )

    recommended_recipes = response.get("recipes", [])
    if recommended_recipes:
        main_recipe = recommended_recipes[0]
        db.save_user_recipe_history(user_no, main_recipe, ingredients_ko)

    db.update_used_ingredients(user_no, ingredients_ko)
    return response
