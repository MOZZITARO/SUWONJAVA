import urllib.parse
import requests
from googleapiclient.discovery import build
import urllib.request
import json
import httpx
import asyncio
import os
from dotenv import load_dotenv
import google.generativeai as genai
import re
from konlpy.tag import Okt
import random

load_dotenv()

GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
if GOOGLE_API_KEY:
    genai.configure(api_key=GOOGLE_API_KEY)
    gemini_text_model = genai.GenerativeModel("gemini-1.5-flash")
else:
    gemini_text_model = None
    print("### 경고: GOOGLE_API_KEY가 없어서 Gemini 기능을 사용할 수 없습니다.")

PUBLIC_API_KEY = os.getenv("PUBLIC_API_KEY")
OLLAMA_API_URL = os.getenv("OLLAMA_API_URL")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL")


# OLLAMA_API_URL = "http://localhost:11434/api/generate"
# OLLAMA_MODEL = "gemma3:4b"


# gemini가 공공데이터 api로 가져온 레시피 데이터의 재료부분을 파싱
async def parse_ingredients_with_gemini(raw_text: str) -> list[dict]:
    """Gemini를 사용하여 비정형적인 재료 텍스트를 [{"name": ..., "quantity": ..., "description": ...}] 형식으로 파싱."""

    if not gemini_text_model:
        return []

    prompt = f"""
        당신은 비정형적인 요리 재료 텍스트를 분석하여, 구조화된 JSON 배열로 변환하는 매우 정밀한 파싱 AI입니다.
        주어진 [원본 텍스트]에서 순수한 '재료' 정보만 추출하여, 아래 [규칙]과 [출력 형식]을 절대적으로 준수하는 JSON 배열로만 응답해주세요.
        
        [규칙]
        1.  **핵심 분리**: 각 재료 항목을 'name', 'quantity', 'description' 세 부분으로 나눕니다.
            -   `name`: 재료의 순수한 이름 (예: '연두부', '칵테일새우', '다진 대파')
            -   `quantity`: 재료의 양과 단위. 숫자와 단위(g, kg, ml 등)를 포함합니다. (예: '75g', '2ml', '300ml', '약간')
            -   `description`: 괄호 '()' 안에 있는 부가 설명. (예: '3/4모', '5줄기', '1/3작은술', '1/2쪽', '1/8봉지')
        2.  **노이즈 제거**: '새우두부계란찜', '●방울토마토 소박이 :', '[1인분]', '고명' 등 요리 이름이나 카테고리명은 **완전히 무시하고 결과에 포함시키지 마세요.**
        3.  **섹션 처리**: '·양념장 :', '●소스 :' 등과 같이 여러 재료를 포함하는 섹션이 있다면, 그 안에 있는 각 재료들을 개별 항목으로 모두 추출해야 합니다.
        4.  **일관성**: 양이나 설명이 없는 경우, 해당 값은 빈 문자열("")로 처리합니다.

        [상세 예시]
        -   "연두부 75g(3/4모)" -> {{"name": "연두부", "quantity": "75g", "description": "3/4모"}}
        -   "참깨 약간" -> {{"name": "참깨", "quantity": "약간", "description": ""}}
        -   "물 300ml(1½컵)" -> {{"name": "물", "quantity": "300ml", "description": "1½컵"}}

        [원본 텍스트]
        {raw_text}

        [출력 형식]
        [
        {{"name": "재료1 이름", "quantity": "재료1 양", "description": "재료1 설명"}},
        {{"name": "재료2 이름", "quantity": "재료2 양", "description": "재료2 설명"}}
        ]
    """

    try:
        response = await gemini_text_model.generate_content_async([prompt])

        # Gemini 응답에서 JSON 부분만 정확히 추출
        json_text_match = re.search(r"\[\s*\{.*?\}\s*\]", response.text, re.DOTALL)
        if not json_text_match:
            print("### Gemini 파싱 오류: 응답에서 유효한 JSON 배열을 찾지 못했습니다.")

            return []

        return json.loads(json_text_match.group())

    except Exception as e:
        print(f"### Gemini 재료 파싱 중 오류 발생: {e}")
        return []


# gemini가 질문에 답변
async def answer_user_question_with_gemini(
    question: str, subject: str, context_recipe: dict = None
) -> str:
    """주어진 주제와 맥락(이전 추천 레시피)을 바탕으로 사용자의 질문에 답변"""

    if not gemini_text_model:
        return "죄송해요. 지금은 답변을 드릴 수 없어요..."

    # 맥락 정보를 프롬프트에 포함
    context_info = ""
    if context_recipe:
        recipe_name = context_recipe.get("name", "해당 레시피")
        ingredients_str = ", ".join(
            [ing["name"] for ing in context_recipe.get("ingredients", [])]
        )
        instructions_str = "\n".join(
            [
                f"{inst['step_num']}. {inst['description']}"
                for inst in context_recipe.get("instructions", [])
            ]
        )
        context_info = f"""
            [참고 레시피 이름: '{recipe_name}']
            - 사용하는 재료 : {ingredients_str}
            - 조리법 요약 : {instructions_str}
        """

    prompt = f"""
        당신은 상냥하고 유능한 '냉장고 요리사' 챗봇입니다.
        아래 참고 정보와 질문을 바탕으로, 사용자에게 친절하고 상세하게 답변해주세요.
        모르는 내용은 모른다고 솔직하게 답하고, 항상 긍정적인 태도를 유지하세요.
        
        {context_info}
        
        사용자 질문: "{question}" (주제: {subject})
    """

    try:
        response = await gemini_text_model.generate_content_async([prompt])
        return response.text.strip()
    except Exception as e:
        print(f"### Gemini 질문 답변 생성 오류: {e}")
        return "죄송해요. 답변을 생성하는 중에 문제가 발생했어요."


# gemini가 사용자의 의도를 분석
async def analyze_user_intent_with_gemini(
    message: str, chat_history: list = None
) -> dict:
    """사용자의 메시지를 분석하여 의도, 포함할 재료, 제외할 재료를 추출"""

    # 대화 기록을 프롬프트에 넣기 좋게 포맷팅
    formatted_history = ""
    if chat_history:
        for msg in chat_history:
            role = "사용자" if msg["sender"] == "user" else "챗봇"
            formatted_history += f"{role}: {msg['content']}\n"

    if not gemini_text_model:
        return {"intent": "unknown"}

    prompt = f"""
    
        당신은 챗봇의 사용자 입력을 분석하는 시스템입니다.
        아래 '대화 기록'을 참고하여, '새로운 사용자 메시지'의 진짜 의도를 분석해주세요.
        분석 결과는 'intent', 'subject', 'include_ingredients', 'exclude_ingredients' 네 가지 키를 가진 JSON 객체로만 반환해야 합니다.
        
        [대화 기록]
        {formatted_history}
        [새로운 사용자 메시지]
        {message}
        
        [분석 가이드]
        - intent: 'request_recipe'(새로운 레시피 추천 요청), 'request_next_recipe'(이전에 추천한 목록에서 다음 것 요청), 'ask_question'(단순 질문), 'greeting'(인사) 중 하나.
        - subject: 'ask_question'일 때, 질문의 대상이 되는 음식이나 주제. (예: "사과파이 만들기", "그 레시피")
        - include_ingredients: 사용자가 사용하고 싶어하는 재료. 대화 문맥을 파악해야함. (예: "그걸로 만들어줘" -> '그것'이 이전 대화의 재료를 의미)
        - exclude_ingredients: 사용자가 빼고 싶어하는 재료. (예: "돼지고기가 안들어간 카레 레시피 추천해줘" -> '돼지고기'를 제외 재료로 인식 가능)
        - '그거 말고', '다른 거 보여줘', '별로야' 와 같은 부정적인 피드백은 'request_next_recipe'로 분류.
        - '재료'를 명시하면 'request_recipe'로 분류.
        
        [예시]
        - 대화기록: "챗봇: '돼지고기 김치찌개'는 어떠세요?" / 새로운 메시지: "그거 말고 다른거 추천해줘"
        -> {{"intent": "request_next_recipe", "include_ingredients": [], "exclude_ingredients": []}}
        - 대화기록: "" / 새로운 메시지: "오늘 저녁 뭐 먹지?"
        -> {{"intent": "request_recipe", "include_ingredients": [], "exclude_ingredients": []}}
        - 대화기록: "" / 새로운 메시지: "소고기랑 무가 있어"
        -> {{"intent": "request_recipe", "include_ingredients": ["소고기", "무"], "exclude_ingredients": []}}
        - 대화기록: "챗봇: '사과파이'를 추천합니다." / 새로운 메시지: "만드는 거 어려워?"
        -> {{"intent": "ask_question", "subject": "사과파이 만들기", "include_ingredients": [], "exclude_ingredients": []}}
    """
    # 나중에 추가할 시나리오 - 레시피 이름이 추가!!
    # 1. 재료를 말하지않고 레시피 이름만 말할 경우.. -> 된장찌개 레시피 알려줘, 된장찌개 만드는 법 알려줘
    # 2. 재료와 레시피명을 같이 말할 경우.. -> 돼지고기 김치찌개 레시피 알려줘, 돼지고기 김치찌개 만드는 법 알려줘
    # 3. 넣어야할 재료 없이, 제외할 재료만 언급했을 때의 레시피 추천 -> 김치가 안들어간 김치찌개 레시피 알려줘, 김치가 안들어간 김치찌개 만드는 법 알려줘
    # 4. 질문에 너무 많은 재료를 포함해서 레시피의 결과가 안나오는 경우 -> 어느 정도까지 재료를 컷할 것인가.. 또는 그냥 레시피가 없다고 대답.
    try:
        response = await gemini_text_model.generate_content_async([prompt])

        # gemini 응답에서 json 부분만 추출
        json_text = re.search(r"\{.*\}", response.text, re.DOTALL).group()
        return json.loads(json_text)

    except Exception as e:
        print(f"### Gemini 의도 분석 오류: {e}")

        # 의도 분석 실패 시, 기존 Konlpy 방식 사용
        okt = Okt()
        nouns = okt.nouns(message)
        return {
            "intent": "request_recipe",
            "include_ingredients": nouns,
            "exclude_ingredients": [],
        }


# gemini를 사용해서 자연스러운 챗봇 응답을 생성
async def generate_natural_chat_response(base_message: str, recipe_name: str) -> str:
    """주어진 상황과 레시피 이름을 바탕으로 자연스러운 챗봇 응답을 생성"""

    if not gemini_text_model:
        return f"{base_message}, '{recipe_name}' 레시피를 추천합니다!"

    prompt = f"""
        당신은 사용자와 친근하게 대화하는 '냉장고 요리사' 챗봇입니다. 아래 상황이 맞는, 다정하고 창의적인 추천 메시지를 1~2문장으로 만들어주세요.
        
        상황: {base_message}
        추천할 레시피: {recipe_name}
        
        예시1 : "오, {base_message}군요! 마침 딱 좋은게 생각났어요. 매콤한 '{recipe_name}' 어떠세요? 입맛이 확 살아날 거예요! 😄"
        예시2: "{base_message}라니, 탁월한 선택이에요! 그럼 오늘은 부드럽고 든든한 '{recipe_name}'으로 맛있는 한 끼 어떠신가요?"
    """

    try:
        response = await gemini_text_model.generate_content_async([prompt])
        return response.text.strip()
    except Exception as e:
        print(f"### Gemini 응답 생성 오류: {e}")
        return f"{base_message}, '{recipe_name}' 레시피를 추천합니다!"


# gemini를 사용해서 레시피를 가져오는 메소드
async def fetch_recipe_from_gemini(ingredients: list) -> list:
    """주어진 재료 목록으로 gemini를 사용하여 DB 스키마와 유사한 구조의 레시피 3개를 생성"""

    if not gemini_text_model:
        return []

    ingredients_str = ", ".join(ingredients)
    print(f"### Gemini API 호출 시작 (DB 구조 맞춤) - 재료: {ingredients_str}")

    # Gemini에게 역할을 부여하고, 출력 형식을 매우 구체적으로 지시합니다.
    prompt = f"""
    당신은 데이터베이스 입력을 위한 JSON 데이터를 생성하는 API입니다.
    주어진 재료 '{", ".join(ingredients)}'를 반드시 사용하는 **서로 다른, 창의적인** 한국 요리 레시피를 **최대 3개** 생성해주세요.
    **각 레시피의 "RCP_NM" 값은 반드시 고유해야 합니다.**
    응답은 반드시 아래의 형식을 정확히 지키는 **JSON 배열(Array)**이어야 합니다.
    각 배열의 요소는 하나의 레시피를 나타내는 JSON 객체입니다.
    값(value)은 모두 문자열(string) 또는 숫자(integer)여야 합니다. 
    실제 데이터처럼 현실적인 값을 생성해주세요. 마크다운이나 추가 설명 없이 오직 JSON 배열만 응답해야 합니다.
    [
        {{
            "RCP_NM": "첫번째 창의적인 한글 요리 이름",
            "RCP_WAY2": "예: 굽기, 끓이기, 튀기기, 무침, 볶음 중 하나",
            "RCP_PAT2": "예: 반찬, 일품, 후식, 국&찌개 중 하나",
            "INFO_WGT": "",
            "INFO_ENG": "칼로리(kcal) 숫자만. 예: 450",
            "INFO_CAR": "탄수화물(g) 숫자만. 예: 35",
            "INFO_PRO": "단백질(g) 숫자만. 예: 25",
            "INFO_FAT": "지방(g) 숫자만. 예: 15",
            "INFO_NA": "나트륨(mg) 숫자만. 예: 800",
            "HASH_TAG": "관련 해시태그 1~2개. 예: #매콤 #간단요리",
            "RCP_PARTS_DTLS": "필요한 모든 재료와 양을 상세히 나열. 예: 돼지고기 300g, 양파 1/2개, ...",
            "RCP_NA_TIP": "요리에 대한 유용한 팁 1~2줄",
            "ATT_FILE_NO_MAIN": "",
            "ATT_FILE_NO_MK": "",
            "MANUAL01": "1단계 조리법 설명",
            "MANUAL_IMG01": "",
            "MANUAL02": "2단계 조리법 설명",
            "MANUAL_IMG02": "",
            "MANUAL03": "3단계 조리법 설명. 없다면 빈 문자열",
            "MANUAL_IMG03": "",
            "MANUAL04": "4단계 조리법 설명. 없다면 빈 문자열",
            "MANUAL_IMG04": "",
            "MANUAL05": "5단계 조리법 설명. 없다면 빈 문자열",
            "MANUAL_IMG05": "",
            "MANUAL06": "6단계 조리법 설명. 없다면 빈 문자열",
            "MANUAL_IMG06": "",
            "MANUAL07": "7단계 조리법 설명. 없다면 빈 문자열",
            "MANUAL_IMG07": "",
            "MANUAL08": "8단계 조리법 설명. 없다면 빈 문자열",
            "MANUAL_IMG08": "",
            ...등등 최대한 자세하게 조리법을 설명해주세요. 최대 20단계까지 설명이 가능합니다만, 꼭 20단계까지 설명할 필요는 없고, 자연스럽게 단계를 맞춰주세요.
        }},
        {{
            "RCP_NM": "두 번째 창의적인 한글 요리 이름",
            "..." : "..."
        }}
    ]
    """
    try:
        # temperature를 조절하여 창의성과 일관성 균형 맞추기
        generation_config = genai.types.GenerationConfig(temperature=0.7)
        response = await gemini_text_model.generate_content_async(
            [prompt], generation_config=generation_config
        )

        # Gemini 응답에서 JSON 부분만 추출
        response_text = response.text.strip()
        json_match = re.search(r"\[.*\]", response_text, re.DOTALL)
        if not json_match:
            print("### Gemini 응답에서 JSON 객체를 찾지 못했습니다.")
            return []

        recipes_json = json.loads(json_match.group())

        # 반환값이 리스트인지 확인
        if isinstance(recipes_json, list):
            print(f"### Gemini가 {len(recipes_json)}개의 레시피 JSON을 생성했습니다.")
            return recipes_json
        else:
            print("### Gemini 응답이 유효한 JSON 배열이 아닙니다.")
            return []

    except Exception as e:
        print(f"### Gemini API 요청 또는 JSON 파싱 오류 발생: {e}")
        return []


# 공공데이터 포탈 API를 사용해서 조리식품의 레시피를 가져오는 메소드
async def fetch_recipe_from_public_api(
    include_ingredients: list, exclude_ingredients: list = None
) -> list:
    # url = f"http://openapi.foodsafetykorea.go.kr/api/f98a399c38a7460fbc05/COOKRCP01/json/1/10/RCP_PARTS_DTLS={','.join(ingredients)}"

    # URL 수동 조합 및 인코딩
    ingredients_str = ",".join(set(include_ingredients))
    encoded_ingredients = urllib.parse.quote(ingredients_str)

    url = (
        f"https://openapi.foodsafetykorea.go.kr/api/{os.getenv('PUBLIC_API_KEY')}/COOKRCP01/json/1/100/"
        f"RCP_PARTS_DTLS={encoded_ingredients}"
    )
    # response = urllib.parse.unquote(url)
    # response_text = response.read().decode("utf-8")
    print(f"\n### 공공데이터 API 요청 URL: {url}")

    async with httpx.AsyncClient() as client:

        try:
            response = await client.get(url, timeout=10.0)
            response.raise_for_status()  # HTTP 오류 발생 시 예외 발생
            # response = requests.get(url)
            print(
                f"### 공공데이터 API 응답 상태: {response.status_code}, 내용: {response}\n"
            )

            if response.status_code == 200:
                data = response.json()

                all_recipes = []
                if data.get("COOKRCP01") and data["COOKRCP01"].get("row"):
                    all_recipes = data["COOKRCP01"]["row"]

                # 제외 재료 필터링 로직 추가
                filtered_recipes = []
                if exclude_ingredients:
                    for recipe in all_recipes:
                        parts_details = recipe.get("RCP_PARTS_DTLS", "").lower()

                        # exclude_ingredients 중 하나라도 포함되어 있으면 제외
                        if not any(
                            ex_ing.lower() in parts_details
                            for ex_ing in exclude_ingredients
                        ):
                            filtered_recipes.append(recipe)
                else:
                    filtered_recipes = all_recipes

                # 결과 랜덤 섞기
                random.shuffle(filtered_recipes)

                # 필터링하고 순서를 섞은 '원본 레시피 데이터 리스트'를 리턴
                return filtered_recipes

                # found_recipe = []

                if data.get("COOKRCP01") and data["COOKRCP01"].get("row"):
                    for row in data["COOKRCP01"]["row"]:
                        parts_details = row.get("RCP_PARTS_DTLS", "").lower()
                        if any(
                            ing.lower() in parts_details for ing in include_ingredients
                        ):
                            print("\n### 공공데이터 API에서 레시피 찾음")
                            manuals = {
                                f"MANUAL{i:02d}": row.get(f"MANUAL{i:02d}", "")
                                for i in range(1, 21)
                            }
                            manual_images = {
                                f"MANUAL_IMG{i:02d}": row.get(f"MANUAL_IMG{i:02d}", "")
                                for i in range(1, 21)
                            }

                            # print(f"### manuals: {manuals}")  # 디버깅 로그
                            # print(f"### manual_images: {manual_images}\n\n")  # 디버깅 로그

                            manual_entries = {}
                            for key, val in manuals.items():
                                if (
                                    val
                                    and key.startswith("MANUAL")
                                    and key[6:].isdigit()
                                ):
                                    entry_key = f"manual_{key[6:]}"
                                    manual_entries[entry_key] = val

                            manual_img_entries = {}
                            for key, val in manual_images.items():
                                if (
                                    val
                                    and key.startswith("MANUAL_IMG")
                                    and key[10:].isdigit()
                                ):
                                    img_entry_key = f"manual_img_{key[10:]}"
                                    manual_img_entries[img_entry_key] = val

                            print(
                                f"### manual_entries: {manual_entries}"
                            )  # 추가 디버깅 로그
                            print(
                                f"### manual_img_entries: {manual_img_entries}\n\n"
                            )  # 추가 디버깅 로그

                            recipe_data = {
                                "name": row.get("RCP_NM", "Unknown Recipe"),
                                "cooking_method": row.get("RCP_WAY2", ""),
                                "cuisine_type": row.get("RCP_PAT2", ""),
                                "calories": row.get("INFO_ENG", 0),
                                "info_wgt": (
                                    row.get("INFO_WGT", 0) if row.get("INFO_WGT") else 0
                                ),
                                "info_car": row.get("INFO_CAR", 0),
                                "info_fat": row.get("INFO_FAT", 0),
                                "info_na": row.get("INFO_NA", 0),
                                "info_pro": row.get("INFO_PRO", 0),
                                "hash_tag": row.get("HASH_TAG", ""),
                                "image_main_url": row.get("ATT_FILE_NO_MAIN", ""),
                                "image_thumbnail_url": row.get("ATT_FILE_NO_MK", ""),
                                "tip": row.get("RCP_NA_TIP", ""),
                                "raw_parts_details": row.get("RCP_PARTS_DTLS", ""),
                                **manual_entries,
                                **manual_img_entries,
                            }
                            print(f"### 매칭된 레시피: {recipe_data['name']}\n\n")
                            filtered_recipes.append(recipe_data)
                return filtered_recipes

        except httpx.HTTPError as e:
            print(f"### HTTP 요청 오류 발생: {e}")
            return []

        except json.JSONDecodeError:
            print(f"### JSON 파싱 오류. 서버 응답이 올바른 JSON 형식이 아닙니다.")
            print(f"### 수신된 텍스트: {response.text}")
            return []

    # 예외 발생하면 빈 리스트 반환
    return []


# GEMINI를 사용하여 레시피 설명을 생성하는 비동기 함수
async def fetch_recipe_description_from_gemini(
    manuals: list[str], tip: str = ""
) -> str:
    """시간이 오래 걸리는 OLLAMA를 대신해서 원본 레시피 manuals와 tip을 GEMINI가 새로운 레시피 manuals와 tip을 생성"""
    if not gemini_text_model:
        return ""

    # 프롬프트에 조리 단계와 팁을 명확히 구분하여 전달
    manuals_str = "\n".join(
        [f"단계 {i + 1}: {manual}" for i, manual in enumerate(manuals)]
    )

    prompt = f"""
        당신은 '친절한 요리 선생님' 말투로 요리법을 설명하는 AI입니다.
        아래의 [원본 조리법]과 [원본 팁]을 분석하여, 각 단계와 팁을 초보자가 이해하기 쉬운 상세한 설명으로 재생성해주세요.
        
        [규칙]
        - 각 단계별 설명은 2~3줄의 문장으로 구성합니다.
        - 응답은 반드시 아래 [출력 형식]의 구분자('--- 단계 구분선 ---' 등)를 정확히 지켜야 합니다.
        - 구분자 외에 다른 어떤 설명이나 문구도 절대 추가하지 마세요.
        
        [원본 조리법]
        {manuals_str}
        
        [원본 팁]
        {tip}
        
        [출력 형식]
        ### 단계별 설명 시작 ###
        (여기에 1단계에 대한 새로운 설명을 생성)
        --- 단계 구분선 ---
        (여기에 2단계에 대한 새로운 설명을 생성)
        --- 단계 구분선 ---
        (이런 식으로 모든 단계에 대해 반복)
        --- 단계 구분선 ---
        (여기에 마지막 단계에 대한 새로운 설명을 생성)
        ### 단계별 설명 끝 ###

        ### 팁 설명 시작 ###
        (여기에 팁에 대한 새로운 설명을 생성)
        ### 팁 설명 끝 ###
    """

    print(
        f"### GEMINI 설명 생성 시작... 총 {len(manuals)}단계, 팁: {'있음' if tip else '없음'}"
    )

    try:
        response = await gemini_text_model.generate_content_async([prompt])
        return response.text.strip()
    except Exception as e:
        print(f"### Gemini 팁 설명 생성 실패: {e}")
        return ""

    # # 각 단계별 설명 생성
    # descriptions = []
    # for i, manual in enumerate(manuals, 1):
    #     if not manual:
    #         continue

    #     prompt = f"당신은 초보 요리사를 위한 친절한 요리 선생님입니다. 다음의 요리 단계 설명인 '{manual}'을 더 이해하기 쉽고 친절한 말투로 2~3줄의 상세한 설명으로 바꿔주세요. 팁이나 주의사항을 포함하면 좋습니다."

    #     try:
    #         response = await gemini_text_model.generate_content_async([prompt])
    #         generated_text = response.text.strip()
    #         descriptions.append(generated_text)
    #     except Exception as e:
    #         print(f"### Gemini 설명 생성 실패 (단계 {i}): {e}")
    #         None

    # # 팁에 대한 설명 추가
    # if tip:
    #     prompt = f"다음 요리 팁 '{tip}'을 더 친절하고 상세하게 풀어서 설명해주세요."
    #     try:
    #         response = await gemini_text_model.generate_content_async([prompt])
    #         generated_text = response.text.strip()
    #         descriptions.append(f"**요리 팁:** {generated_text}")
    #     except Exception as e:
    #         print(f"### Gemini 팁 설명 생성 실패: {e}")
    #         None

    # return "\n\n".join(descriptions)


# OLLAMA를 사용하여 레시피 설명을 생성하는 비동기 함수
async def fetch_recipe_description_from_ollama(manuals: list, tip: str = None) -> str:
    descriptions = []
    # ollama_url = "http://localhost:11434/api/generate"

    timeout_config = httpx.Timeout(130.0)

    try:
        async with httpx.AsyncClient(timeout=timeout_config) as client:
            for i, manual in enumerate(manuals, 1):

                if not manual:
                    continue

                prompt = f"당신은 요리 전문가입니다. {i}단계 만드는 법 설명('{manual}')을 참고하여 요리를 처음 하는 사람도 쉽게 이해할 수 있도록 친절하게 3줄 이내로 설명해주세요. 설명은 일관되게 유지하세요."

                payload = {
                    "model": OLLAMA_MODEL,  # 사용할 모델 이름
                    "prompt": prompt,
                    "stream": False,  # 스트리밍을 사용하지 않음
                }

                try:
                    response = await client.post(OLLAMA_API_URL, json=payload)
                    response.raise_for_status()

                    response_data = response.json()
                    generated_text = response_data.get("response", "").strip()

                    if generated_text:
                        descriptions.append(generated_text)
                    else:
                        print(
                            f"### Ollama 응답에 'response' 키가 없거나 비어있음: {response_data}"
                        )
                        return None

                except httpx.HTTPError as e:
                    print(f"### Ollama API 요청 오류 (단계 {i}): {e}")
                    None
                except json.JSONDecodeError:
                    print(
                        f"### Ollama 응답 JSON 파싱 실패. (단계 {i}): 수신된 텍스트: {response.text}"
                    )
                    None

            # 팁이 있을 경우 추가 설명 생성
            if tip:
                prompt = f"당신은 요리 전문가입니다. 요리 팁('{tip}')을 참고하여 요리를 처음 하는 사람도 쉽게 이해할 수 있도록 친절하게 3줄 이내로 설명해주세요. 설명은 일관되게 유지하세요."

                payload = {"model": OLLAMA_MODEL, "prompt": prompt, "stream": False}

                try:
                    response = await client.post(OLLAMA_API_URL, json=payload)
                    response.raise_for_status()

                    response_data = response.json()
                    generated_text = response_data.get("response", "").strip()

                    if generated_text:
                        descriptions.append(f"요리 팁: {generated_text}")
                except Exception as e:
                    descriptions.append("요리 팁 설명 생성 못함")
                    print(f"### Ollama 팁 설명 생성 실패: {e}")

            return "\n".join(descriptions)

    except Exception as e:
        print(f"### fetch_recipe_description_from_ollama 메소드에서 예외 발생: {e}")
        return None


# 안씀
# def generate_ollama_description(manuals, user_id, recipe_id, tip=None):
#     ollama_desc = fetch_recipe_description_from_ollama(manuals, tip)
#     if user_id:
#         import db

#         db.save_ollama_description(user_id, recipe_id, ollama_desc)
#     return ollama_desc


# def fetch_recipe_from_rag(ingredients):
#     service = build("customsearch", "v1", developerKey="your_google_api_key")
#     query = f"recipe with {','.join(ingredients)} site:*.kr -inurl:(login)"
#     res = service.cse().list(q=query, cx="your_google_cse_id", num=3).execute()
#     if res.get("items"):
#         search_result = res["items"][0]["snippet"]
#         prompt = f"당신은 요리 전문가입니다. 주어진 검색 결과({search_result})와 재료({','.join(ingredients)})를 바탕으로 요리를 처음 하는 사람도 쉽게 이해할 수 있도록 레시피를 3줄 이내로 설명해주세요."
#         response = requests.post(
#             "http://localhost:11434/api/generate",
#             json={"model": "gemma:2b", "prompt": prompt},
#         ).json()
#         return {
#             "name": f"{ingredients[0]}-based Recipe",
#             "ingredients": [{"name": ing, "quantity": ""} for ing in ingredients],
#             "instructions": [
#                 {"step_num": 1, "description": desc}
#                 for desc in response.get("response", "No recipe").split("\n")
#                 if desc
#             ],
#             "description": response.get("response", "No description"),
#         }
#     return None
