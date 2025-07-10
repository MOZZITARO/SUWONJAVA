# routers/gemini_recipes.py
from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import JSONResponse
import os
import requests
import google.generativeai as genai
import base64
import re
import random
from services import recipe_service

# 사용 안하는 파일


google_api_key = os.getenv("GOOGLE_API_KEY")
pexels_api_key = os.getenv("PEXELS_API_KEY")
if not google_api_key or not pexels_api_key:
    raise ValueError("API keys not found in .env")

genai.configure(api_key=google_api_key)
gemini_text_model = genai.GenerativeModel("gemini-2.0-flash-exp")

router = APIRouter()

# 한글 음식 이름을 영어로 매핑 (확장)
food_name_mapping = {
    "불고기": "Bulgogi",
    "김치찌개": "Kimchi Stew",
    "비빔밥": "Bibimbap",
    "잡채": "Japchae",
    "된장찌개": "Doenjang Stew",
    "김밥": "Gimbap",
    "떡볶이": "Tteokbokki",
    "갈비": "Galbi",
    "삼겹살": "Samgyeopsal",
    "김치": "Kimchi",
    "콩국수": "Kongguksu",
    "냉면": "Naengmyeon",
    "파전": "Pajeon",
    "순두부찌개": "Sundubu Jjigae",
    "오징어볶음": "Ojingeo Bokkeum",
    "감자탕": "Gamjatang",
    "닭갈비": "Dakgalbi",
    "해물파전": "Haemul Pajeon",
    "갈비찜": "Galbijjim",
    "제육볶음": "Jeyuk Bokkeum",
    "육회": "Yukhoe",
    "당근볶음": "Carrot Stir-fry",
    "두부조림": "Dubu Jorim",
    "청국장": "Cheonggukjang",
    "야채전": "Vegetable Pancake",
    "계란찜": "Gyeranjjim",
    "부대찌개": "Budae Jjigae",
    "순대국": "Sundae Guk",
    "감자조림": "Gamja Jorim",
    "고등어조림": "Godeungeo Jorim",
    "콩나물국": "Kongnamul Guk",
    "미역국": "Miyeok Guk",
    "된장국": "Doenjang Guk",
    "우엉조림": "Ueong Jorim",
    "멸치볶음": "Myeolchi Bokkeum",
    "시금치나물": "Sigeumchi Namul",
    "무생채": "Mu Saengchae",
    "호박볶음": "Hobak Bokkeum",
    "애호박전": "Aehobak Jeon",
    "동태찌개": "Dongtae Jjigae",
    "코다리조림": "Kodari Jorim",
    "닭볶음탕": "Dakbokkeumtang",
    "잡곡밥": "Japgokbap",
    "오징어채볶음": "Ojingeochae Bokkeum",
    "고추장찌개": "Gochujang Jjigae",
    "계란말이": "Gyeran Mari",
    "콩자반": "Kongjaban",
    "도라지나물": "Doraji Namul",
    "우엉볶음": "Ueong Bokkeum",
    "깻잎찜": "Kkaennip Jjim",
    "고사리나물": "Gosari Namul",
    "연근조림": "Yeongeun Jorim",
    "가지볶음": "Gaji Bokkeum",
    "무국": "Mu Guk",
    "북엇국": "Bugeot Guk",
    "달걀국": "Dalgyal Guk",
    "미역줄기볶음": "Miyeokjulgi Bokkeum",
    "참치김치찌개": "Tuna Kimchi Stew",
    "소고기무국": "Beef Radish Soup",
    "감자채볶음": "Gamja-chae Bokkeum",
    "애호박볶음": "Aehobak Bokkeum",
    "시래기국": "Siraegi Guk",
    "청포묵무침": "Cheongpomuk Muchim",
    "콩나물무침": "Kongnamul Muchim",
    "무나물": "Mu Namul",
    "브로콜리나물": "Broccoli Namul",
    "고구마줄기볶음": "Goguma Julgi Bokkeum",
    "가지나물": "Gaji Namul",
    "깻잎무침": "Kkaennip Muchim",
    "도토리묵무침": "Dotori-muk Muchim",
    "명란젓": "Myeongran Jeot",
    "오징어젓": "Ojingeo Jeot",
    "낙지볶음": "Nakji Bokkeum",
    "장조림": "Jangjorim",
    "멸치국수": "Myeolchi Guksu",
    "칼국수": "Kalguksu",
    "수제비": "Sujebi",
    "쫄면": "Jjolmyeon",
    "라면": "Ramen",
    "우동": "Udon",
    "쌀국수": "Pho",
    "짜장면": "Jjajangmyeon",
    "짬뽕": "Jjamppong",
    "탕수육": "Tangsuyuk",
    "깐풍기": "Kkanpunggi",
    "마파두부": "Mapo Tofu",
    "양장피": "Yangjangpi",
    "팔보채": "Palbochae",
    "유산슬": "Yusanseul",
    "고추잡채": "Gochu Japchae",
    "동파육": "Dongpayuk",
    "훠궈": "Hot Pot",
    "샤브샤브": "Shabu Shabu",
    "스키야키": "Sukiyaki",
    "오코노미야키": "Okonomiyaki",
    "타코야키": "Takoyaki",
    "규동": "Gyudon",
    "가츠동": "Katsudon",
    "텐동": "Tendon",
    "우나기동": "Unagidon",
    "스시": "Sushi",
    "사시미": "Sashimi",
    "돈부리": "Donburi",
    "라멘": "Ramen",
    "규카츠": "Gyukatsu",
    "에비후라이": "Ebi Fry",
    "가라아게": "Karaage",
    "멘치카츠": "Menchi Katsu",
    "치킨가라아게": "Chicken Karaage",
    "카레라이스": "Curry Rice",
    "함박스테이크": "Hamburg Steak",
    "오므라이스": "Omurice",
    "돈카츠": "Tonkatsu",
    "치킨까스": "Chicken Katsu",
    "새우튀김": "Shrimp Tempura",
    "야끼소바": "Yakisoba",
    "야키우동": "Yaki Udon",
}

# 분류 결과(식재료)별 대표 한식 요리 매핑
ingredient_to_korean_dishes = {
    "beef": ["불고기", "갈비구이", "육회"],
    "bean": ["콩국수", "두부조림", "청국장"],
    "carrot": ["당근볶음", "잡채", "야채전"],
    # 추가 매핑
}


def translate_to_english(korean):
    # 한글이 포함되어 있으면 'Korean food'로 fallback
    if re.search(r"[가-힣]", korean):
        return "Korean food"
    return korean


def get_english_food_name(korean_name):
    cleaned_name = clean_food_name(korean_name)
    return food_name_mapping.get(
        cleaned_name,
        cleaned_name if not re.search(r"[가-힣]", cleaned_name) else "Korean food",
    )


def clean_food_name(food_name):
    # "식재료:" 제거, 괄호 및 괄호 안 내용 제거, 앞뒤 공백 제거
    name = re.sub(r"식재료[:：]\s*", "", food_name)
    name = re.sub(r"\(.*?\)", "", name)
    return name.strip()


# 대표 재료 → 대표 음식명 리스트 매핑
ingredient_to_foods = {
    "소고기": ["불고기", "갈비찜", "갈비구이", "비프스테이크"],
    "갈비살": ["갈비찜", "갈비구이", "불고기"],
    "돼지고기": ["제육볶음", "돼지갈비", "돈까스"],
    "닭고기": ["닭갈비", "치킨", "닭볶음탕"],
    "생선": ["고등어조림", "갈치조림", "생선구이"],
    "두부": ["두부조림", "순두부찌개"],
    "계란": ["계란찜", "계란말이"],
    "감자": ["감자탕", "감자조림"],
    "오징어": ["오징어볶음", "오징어채볶음"],
    "김치": ["김치찌개", "김치전"],
    "당근": ["당근볶음", "잡채", "야채전"],
    "콩": ["콩국수", "두부조림", "청국장"],
}


def get_fallback_food(food_name):
    for ingredient, foods in ingredient_to_foods.items():
        if ingredient in food_name:
            return random.choice(foods)
    if "갈비살" in food_name:
        return "갈비구이"
    if "소고기" in food_name:
        return "불고기"
    return "한식"  # 최종 fallback


# --- detailed_recipe.py와 gemini_recipe_by_class.py의 헬퍼 함수들을 모두 여기에 복사 ---
# food_name_mapping, ingredient_to_korean_dishes, get_english_food_name, clean_food_name, get_fallback_food 등


@router.post("/by-class", summary="분류된 재료 클래스로 Gemini 레시피 추천")
async def recipe_by_class(request: Request):
    data = await request.json()
    ingredient = data.get("ingredient")
    if not ingredient:
        return JSONResponse(
            {"success": False, "error": "ingredient가 필요합니다."}, status_code=400
        )
    # 대표 한식 요리 3개 선정
    dishes = ingredient_to_korean_dishes.get(ingredient, [])
    if not dishes:
        dishes = [ingredient]  # fallback: 식재료명 자체
    try:
        # 각 요리명으로 Gemini에 레시피 요청
        recipes = []
        for idx, dish in enumerate(dishes[:3], 1):
            prompt = f"'{dish}'의 레시피를 **한글**로 제공해주세요. 응답은 한국어로만 작성하며, 영어는 사용하지 않습니다.  **마크다운 형식을 사용하지 말고, 일반 텍스트로 작성해주세요.**\n\n형식:\n요리명: {dish}\n재료:\n- [재료1: 정확한 분량, 간단한 준비 팁]\n- [재료2: 정확한 분량, 간단한 준비 팁]\n...\n조리법:\n1. [상세 설명, 조리 시간, 필요한 도구, 주의사항/팁]\n2. [상세 설명, 조리 시간, 필요한 도구, 주의사항/팁]\n..."
            response = gemini_text_model.generate_content([prompt])
            recipes.append(f"요리 {idx}:\n{response.text.strip()}")
        analysis = "\n\n".join(recipes)
        return JSONResponse({"success": True, "analysis": analysis})
    except Exception as e:
        return JSONResponse({"success": False, "error": str(e)}, status_code=500)


@router.post("/detailed", summary="음식 이름으로 상세 레시피/이미지 조회")
async def get_detailed_recipe(request: Request):
    data = await request.json()
    food_name = data.get("food_name")
    if not food_name:
        return JSONResponse(
            {"success": False, "error": "food_name이 필요합니다."}, status_code=400
        )
    # 음식명 전처리
    cleaned_food_name = clean_food_name(food_name)
    # 한글 음식명 저장
    food_name_ko = cleaned_food_name
    # 영어 음식명으로 변환
    search_query = get_english_food_name(cleaned_food_name)
    try:
        headers = {"Authorization": pexels_api_key}
        params = {"query": search_query, "per_page": 1}
        print(f"[Pexels] 검색어: {search_query}")
        response = requests.get(
            "https://api.pexels.com/v1/search", headers=headers, params=params
        )
        response.raise_for_status()
        data = response.json()
        if not data["photos"]:
            fallback_food = get_fallback_food(cleaned_food_name)
            search_query = get_english_food_name(fallback_food)
            print(f"[Pexels] Fallback 검색어: {search_query}")
            params["query"] = search_query
            response = requests.get(
                "https://api.pexels.com/v1/search", headers=headers, params=params
            )
            response.raise_for_status()
            data = response.json()
        if data["photos"]:
            image_url = data["photos"][0]["src"]["medium"]
            print(f"[Pexels] 이미지 URL: {image_url}")
            image_response = requests.get(image_url)
            image_response.raise_for_status()
            image_bytes = image_response.content
            image_base64 = base64.b64encode(image_bytes).decode("utf-8")
        else:
            print("[Pexels] 이미지를 찾지 못함")
            image_base64 = ""
    except Exception as e:
        print(f"[Pexels] 오류: {e}")
        image_base64 = ""
    # Gemini API로 상세 레시피 가져오기
    try:
        gemini_response = gemini_text_model.generate_content(
            [
                f"'{food_name_ko}'의 상세 레시피를 **한글**로 제공해주세요. 응답은 한국어로만 작성하며, 영어는 사용하지 않습니다. **마크다운 형식을 사용하지 말고, 일반 텍스트로 작성해주세요.**\n\n형식:\n요리명: {food_name_ko}\n재료:\n- [재료1: 정확한 분량, 간단한 준비 팁]\n- [재료2: 정확한 분량, 간단한 준비 팁]\n...\n조리법:\n1. [상세 설명, 조리 시간, 필요한 도구, 주의사항/팁]\n2. [상세 설명, 조리 시간, 필요한 도구, 주의사항/팁]\n..."
            ]
        )
        recipe = gemini_response.text
    except Exception as e:
        recipe = f"Gemini API 오류: {e}"
    return JSONResponse(
        {
            "success": True,
            "image_base64": image_base64,
            "recipe": recipe,
            "food_name_ko": food_name_ko,
        }
    )
