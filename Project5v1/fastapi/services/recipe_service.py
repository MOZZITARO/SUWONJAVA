# services/recipe_service.py
from fastapi import APIRouter, UploadFile, File, Request, Form, Query, HTTPException
from fastapi.responses import JSONResponse
from pathlib import Path
import cv2
import torch
from pydantic import BaseModel
from typing import List

# 다른 모듈에서 필요한 함수들을 import 합니다.
import db
import api_utils
import translation
from core.sessions import get_user_no_from_session


# --- 숫자 변환을 위한 헬퍼 함수 추가 (선택사항이지만 권장) ---
def to_int(value, default=0):
    """문자열을 정수로 변환하되, 변환할 수 없으면 기본값을 반환합니다."""
    if value is None or value == "":
        return default
    try:
        return int(value)
    except (ValueError, TypeError):
        return default


# --- main.py에 있던 process_recipe_prediction 함수를 이곳으로 이동 ---
async def process_recipe_prediction(
    include_ingredients: list, exclude_ingredients: list = None, request: Request = None
) -> dict:
    # (기존 main.py에 있던 process_recipe_prediction 함수 내용 전체를 여기에 복사-붙여넣기)

    # if request and "user_no" in request.session:
    #     print("세션 ID (process_recipe_prediction):", request.session["user_no"])

    # 포함할 재료를 입력하지 않았을 경우
    if not include_ingredients:
        print(f"### process_recipe_prediction 시작 - 포함할 식재료 입력 없음")

        # 제외할 재료만 입력한 경우
        if exclude_ingredients:
            print(f"### 제외 재료 기반 추천: {exclude_ingredients} 제외")
            random_recipes = db.get_random_recipes_excluding(exclude_ingredients, 3)
            processed_recipes = []
            if random_recipes:
                for rec in random_recipes:
                    full_recipe = db.fetch_recipe_from_db(rec["recipe_id"])
                    if full_recipe:
                        full_recipe["source"] = "Ramdom (Exclude)"
                        processed_recipes.append(full_recipe)

            return {
                "search_keywords": {
                    "include": [],
                    "exlude": exclude_ingredients,
                },
                "recipes_found": len(processed_recipes),
                "recipes": processed_recipes,
            }

        # 회원일 때
        user_no = request.session.get("user_no") if request else None
        if user_no:
            prefs = db.get_user_preferences(user_no)
            if prefs.get("liked_ingredients"):
                include_ingredients = prefs["liked_ingredients"]
                print(
                    f"### 입력한 재료 없음: 회원의 '선호 재료'로 추천 - {include_ingredients}"
                )
            elif prefs.get("fridge_ingredients"):
                include_ingredients = prefs["fridge_ingredients"]
                print(
                    f"### 입력한 재료 없음: 회원의 '냉장고 재료'로 추천 - {include_ingredients}"
                )

        # 비회원이거나, 회원인데 선호 재료, 냉장고 재료가 없을 경우
        if not include_ingredients:
            print("### 재료 없음: DB에서 랜덤 인기 레시피 추천")
            # db에서 랜덤으로 레시피 가져오기
            random_recipes = db.get_random_recipes(3)
            processed_recipes = []
            for rec in random_recipes:
                processed_recipes.append(
                    {
                        "recipe_id": rec["recipe_id"],
                        "name": rec["name"],
                        "image_thumbnail_url": rec["image_thumbnail_url"],
                        "source": "Random",
                        "ingredients": [],  # 재료 정보는 상세 보기에서
                        "instructions": [],  # 만드는 법은 상세 보기에서
                    }
                )
            return {"ingredients": [], "recipes": processed_recipes}

    print(f"### process_recipe_prediction 시작 - 식재료: {include_ingredients}")
    final_recipes = []
    processed_recipe_names = set()

    # db에서 레시피 조회
    print("### DB 검색 시작...")
    db_recipe_ids = db.check_existing_recipe(include_ingredients, exclude_ingredients)
    if db_recipe_ids:
        print(f"### DB에서 레시피 ID 발견: {db_recipe_ids}")
        for recipe_id in db_recipe_ids:
            if len(final_recipes) >= 3:
                break
            recipe = db.fetch_recipe_from_db(recipe_id)
            if recipe and recipe["name"] not in processed_recipe_names:
                print(f"### DB에서 가져온 레시피: {recipe}\n")
                final_recipes.append(recipe)
                processed_recipe_names.add(recipe["name"])
    else:
        print("### DB에서 레시피를 찾을 수 없음")

    # 공공데이터 포탈 api 사용
    if len(final_recipes) < 3:
        print("### 공공데이터 API 호출 시작...")
        public_api_recipes_data = await api_utils.fetch_recipe_from_public_api(
            include_ingredients, exclude_ingredients
        )
        if public_api_recipes_data:
            print(
                f"### 공공데이터 API 성공, 데이터: {len(public_api_recipes_data)}개 레시피 찾음"
            )
            for row in public_api_recipes_data:
                if len(final_recipes) >= 3:
                    break

                recipe_name = row.get("RCP_NM", "Unknown Recipe")
                if recipe_name in processed_recipe_names:
                    print(f"### 이미 처리된 레시피 이름: {recipe_name}")
                    continue

                # 공공데이터 포탈 API로 가져온 레시피 데이터를 DB 테이블에 맞게 가공
                manual_entries = {}
                for i in range(1, 21):
                    manual = row.get(f"MANUAL{i:02d}", "")
                    if manual:
                        manual_entries[f"manual_{i:02d}"] = manual

                manual_img_entries = {}
                for i in range(1, 21):
                    img = row.get(f"MANUAL_IMG{i:02d}", "")
                    if img:
                        manual_img_entries[f"manual_img_{i:02d}"] = img

                # DB에 저장할 최종 데이터 객체 생성
                recipe_data_to_save = {
                    "name": recipe_name,
                    "cooking_method": row.get("RCP_WAY2", ""),
                    "cuisine_type": row.get("RCP_PAT2", ""),
                    "calories": row.get("INFO_ENG", 0),
                    "info_wgt": row.get("INFO_WGT", 0) or 0,
                    "info_car": row.get("INFO_CAR", 0),
                    "info_fat": row.get("INFO_FAT", 0),
                    "info_na": row.get("INFO_NA", 0),
                    "info_pro": row.get("INFO_PRO", 0),
                    "hash_tag": row.get("HASH_TAG", ""),
                    "image_main_url": row.get(
                        "ATT_FILE_NO_MK", ""
                    ),  # 이미지 경로(대) - 큰 음식 이미지
                    "image_thumbnail_url": row.get(
                        "ATT_FILE_NO_MAIN", ""
                    ),  # 이미지 경로(소) - 작은 음식 이미지
                    "tip": row.get("RCP_NA_TIP", ""),
                    "raw_parts_details": row.get("RCP_PARTS_DTLS", ""),
                    **manual_entries,
                    **manual_img_entries,
                }

                # DB 저장 전에 Gemini로 재료 파싱
                parsed_ingredients = await api_utils.parse_ingredients_with_gemini(
                    row.get("RCP_PARTS_DTLS", "")
                )

                # 가공된 레시피 데이터를 DB 테이블에 저장
                recipe_id = db.save_recipe_to_db(
                    recipe_data_to_save, parsed_ingredients
                )

                # DB에서 다시 조회해서 사용자에게 리턴할 최종 결과 목록에 추가
                if recipe_id:
                    recipe = db.fetch_recipe_from_db(recipe_id)
                    if recipe:
                        print(f"### 공공데이터 API로 생성된 레시피: {recipe['name']}")
                        recipe["source"] = "PublicAPI"  # 레시피 출처 명시
                        final_recipes.append(recipe)
                        processed_recipe_names.add(recipe["name"])

    # DB와 공공 API 모두에서 충분한 레시피를 찾지 못했을 경우, gemini api 사용
    if len(final_recipes) < 3:
        print("### DB/공공API에서 레시피 부족. Gemini API 호출 시도...")

        gemini_recipes = await api_utils.fetch_recipe_from_gemini(include_ingredients)
        if gemini_recipes:
            for recipe_data in gemini_recipes:
                if len(final_recipes) >= 3:
                    break

                if recipe_data["RCP_NM"] in processed_recipe_names:
                    continue  # 중복 이름 방지

                # Gemini가 만든 레시피 데이터를 DB 저장 형식에 맞게 변환
                recipe_data_to_save = {
                    "name": recipe_data.get("RCP_NM", ""),
                    "cooking_method": recipe_data.get("RCP_WAY2", ""),
                    "cuisine_type": recipe_data.get("RCP_PAT2", ""),
                    "calories": to_int(recipe_data.get("INFO_ENG", 0)),
                    "info_wgt": to_int(recipe_data.get("INFO_WGT", 0)),
                    "info_car": to_int(recipe_data.get("INFO_CAR", 0)),
                    "info_fat": to_int(recipe_data.get("INFO_FAT", 0)),
                    "info_na": to_int(recipe_data.get("INFO_NA", 0)),
                    "info_pro": to_int(recipe_data.get("INFO_PRO", 0)),
                    "hash_tag": recipe_data.get("HASH_TAG", ""),
                    "image_main_url": recipe_data.get(
                        "ATT_FILE_NO_MK", ""
                    ),  # 큰 이미지
                    "image_thumbnail_url": recipe_data.get(
                        "ATT_FILE_NO_MAIN", ""
                    ),  # 작은 이미지
                    "tip": recipe_data.get("RCP_NA_TIP", ""),
                    "raw_parts_details": recipe_data.get("RCP_PARTS_DTLS", ""),
                }

                # 조리법(manual) 데이터 추가
                for i in range(1, 21):
                    manual_key = f"MANUAL{i:02d}"
                    if recipe_data.get(manual_key):
                        recipe_data_to_save[f"manual_{i:02d}"] = recipe_data[manual_key]

                # 조리법 이미지(manual_img) 데이터 추가
                for i in range(1, 21):
                    img_key = f"MANUAL_IMG{i:02d}"
                    if recipe_data.get(img_key):
                        recipe_data_to_save[f"manual_img_{i:02d}"] = recipe_data[
                            img_key
                        ]

            # Gemini가 만든 레시피의 재료 문자열을 다시 Gemini로 파싱!
            raw_ingredients_text = recipe_data.get("RCP_PARTS_DTLS", "")
            print(
                f"### Gemini가 생성한 재료 원문 파싱 시작: {raw_ingredients_text[:50]}..."
            )
            parsed_ingredients = await api_utils.parse_ingredients_with_gemini(
                raw_ingredients_text
            )
            print(f"### Gemini 재료 파싱 완료: {len(parsed_ingredients)}개 재료 추출")

            # Gemini가 생성한 레시피를 db에 저장
            print(
                f"### Gemini API로 생성된 레시피: '{recipe_data['RCP_NM']}'를 DB에 저장 시작"
            )
            recipe_id = db.save_recipe_to_db(recipe_data_to_save, parsed_ingredients)

            if recipe_id:
                recipe = db.fetch_recipe_from_db(recipe_id)
                if recipe:
                    print(f"### DB 저장 성공! (ID: {recipe_id})")
                    recipe["source"] = "Gemini"  # 출처를 명시해주면 좋음
                    final_recipes.append(recipe)
                    processed_recipe_names.add(recipe["name"])

    print(f"### 최종적으로 {len(final_recipes)}개의 레시피를 반환합니다.")
    return {
        "search_keywords": {
            "include": include_ingredients,
            "exclude": exclude_ingredients,
        },
        "recipes_found": len(final_recipes),
        "recipes": final_recipes,
    }
