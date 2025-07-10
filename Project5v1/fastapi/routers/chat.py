# routers/chat.py

# 2025-07-08 챗봇 개선

from fastapi import APIRouter, Form, Request, HTTPException
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from typing import List, Dict
import uuid
from konlpy.tag import Okt
from typing import Optional
import api_utils
import db
from translation import yolo_va_efficientNet
from services import recipe_service
import json

router = APIRouter()
okt = Okt()


# --- main.py에 있던 챗봇 관련 헬퍼 함수들을 이곳으로 이동 ---


def extract_ingredients_from_message(message: str) -> List[str]:
    nouns = okt.nouns(message)
    extracted = [noun for noun in nouns if noun in yolo_va_efficientNet.values()]
    print(f"메시지에서 추출된 식재료: {list(set(extracted))}")
    return list(set(extracted))


# 챗봇 응답 생성
async def create_recipe_response(recipes: List[Dict], base_message: str) -> Dict:
    # (기존 함수 내용 복사-붙여넣기)
    if recipes:
        recipe = recipes[0]
        response_message = await api_utils.generate_natural_chat_response(
            base_message, recipe.get("name")
        )
        response_message += " 자세한 설명이 필요하시면 아래 버튼을 눌러주세요!"
        return {"message": response_message, "recipe": recipe}
    else:
        return {
            "message": "아쉽지만 해당 재료로 만들 수 있는 레시피를 찾지 못했어요. 😥",
            "recipe": None,
        }


async def get_response_for_guest(ingredients: List[str], request: Request) -> Dict:
    # (기존 함수 내용 복사-붙여넣기)
    if ingredients:
        recipe_data = await recipe_service.process_recipe_prediction(
            ingredients, request
        )
        return create_recipe_response(recipe_data.get("recipe", []), "입력하신 재료로")
    else:
        return {
            "message": "안녕하세요! 어떤 재료를 가지고 계신가요? 😊",
            "recipe": None,
        }


async def get_response_for_member(
    ingredients: List[str], user_no: str, request: Request
) -> Dict:
    # (기존 함수 내용 복사-붙여넣기)
    preferences = db.get_user_preferences(user_no)
    ingredients = [
        ing
        for ing in ingredients
        if ing not in preferences.get("disliked_ingredients", [])
    ]
    search_ingredients = ingredients
    base_message = "입력하신 재료로"
    if not search_ingredients:
        if preferences.get("fridge_ingredients"):
            search_ingredients = preferences["fridge_ingredients"]
            base_message = "회원님의 냉장고 재료를 바탕으로"
        elif preferences.get("liked_ingredients"):
            search_ingredients = preferences["liked_ingredients"]
            base_message = "회원님이 좋아하는 재료로"
    if search_ingredients:
        recipe_data = await recipe_service.process_recipe_prediction(
            search_ingredients, request
        )
        return create_recipe_response(recipe_data.get("recipe", []), base_message)
    else:
        return {
            "message": "추천에 사용할 재료가 부족해요. 좋아하시는 재료를 알려주시면 더 좋은 추천을 드릴 수 있어요! 😊",
            "recipe": None,
        }


# --- 챗봇 API 엔드포인트 ---
@router.post("/", summary="챗봇과 대화")
async def chat_with_bot(
    request: Request,
    message: str = Form(...),
    session_id: str = Form(...),
    user_no: Optional[str] = Form(None),
    recommendations_json: Optional[str] = Form(None),
    recommendation_index: Optional[int] = Form(None),
):
    # (기존 main.py에 있던 chat_with_bot 함수 내용 전체를 여기에 복사-붙여넣기)

    # Spring Boot chatbotController 컨트롤러에서 '세션 쿠키를 수동으로 관리'하는 메소드를 사용할 때 적용
    # session_id = request.session.get("session_id")
    # user_no = request.session.get("user_no")  # 회원은 user_no 사용, 비회원은 None
    # # 세션 id 관리 로직
    # if "session_id" not in request.session:
    #     # 새로운 방문자(비회원 포함)에게 고유 세션 id 부여
    #     request.session["session_id"] = str(uuid.uuid4())

    print(f"session_id: {session_id}, user_no: {user_no}")
    print(f"recommendations_json: {recommendations_json}")
    print(f"recommendation_index: {recommendation_index}")

    # 메시지 저장 전에 세션 존재 여부 확인 및 생성
    db.create_chat_session_if_not_exists(session_id, user_no)

    # 메세지 테이블의 DB호출은 'session_id'를 사용, 사용자 메시지 저장 및 대회 기록 조회
    db.save_chat_message(session_id, "user", message)
    chat_history = db.get_chat_history(session_id, limit=10)

    # gemini가 사용자 의도 분석
    intent_data = await api_utils.analyze_user_intent_with_gemini(message, chat_history)
    intent = intent_data.get("intent")

    response_data = {}

    # 응답에 세션 변경사항을 담을 변수
    new_session_data = {}

    # 사용자의 의도에 따른 분기 처리
    if intent == "request_next_recipe":
        print("### 다음 레시피 추천 요청")

        # 세션에서 추천 목록과 현재 인덱스를 가져옴
        # recipe_list = request.session.get("recipe_recommendations", [])
        # current_index = request.session.get("recommendation_index", -1)

        # 세션 대신 Form 데이터에서 추천 목록과 인덱스를 가져옴
        recipe_list = json.loads(recommendations_json) if recommendations_json else []
        current_index = recommendation_index if recommendation_index is not None else -1

        next_index = current_index + 1
        if recipe_list and next_index < len(recipe_list):
            # 보여줄 다음 레시피가 있는 경우
            next_recipe = recipe_list[next_index]
            response_data = await create_recipe_response(
                [next_recipe], "네, 그럼 이건 어떠세요?"
            )

            # request.session["recommendation_index"] = next_index  # 인덱스 업데이트

            # 세션 직접 수정 대신, 변경될 인덱스를 new_session_data에 저장
            new_session_data["new_recommendation_index"] = next_index
        else:
            # 목록의 끝에 도달하거나, 목록이 없는 경우 -> 새로운 추천 시작
            response_data = {
                "message": "더 이상 추천할 목록이 없네요. 새로운 재료를 알려주시거나, 다시 추천을 요청해주세요!",
                "recipe": None,
            }

    elif intent == "request_recipe":
        print("### 새로운 레시피 추천 요청")
        include_ingredients = intent_data.get("include_ingredients", [])
        exclude_ingredients = intent_data.get("exclude_ingredients", [])

        # 회원이면, 회원의 불호 재료를 exclude_ingredients에 추가
        if user_no:
            prefs = db.get_user_preferences(user_no)
            disliked = prefs.get("disliked_ingredients", [])
            exclude_ingredients.extend(
                ing for ing in disliked if ing not in exclude_ingredients
            )

        # 레시피 추천
        recipe_result = await recipe_service.process_recipe_prediction(
            include_ingredients, exclude_ingredients, request
        )
        recommendations = recipe_result.get("recipes", [])

        # 세션에 새로운 추천 목록과 인덱스 저장
        # json_compatible_recommendations = jsonable_encoder(recommendations)
        # request.session["recipe_recommendations"] = json_compatible_recommendations
        # request.session["recommendation_index"] = -1  # 인덱스 초기화

        # 세션 직접 수정 대신, 변경될 정보를 new_session_data에 저장
        new_session_data["new_recommendations"] = jsonable_encoder(recommendations)
        new_session_data["new_recommendation_index"] = -1

        if recommendations:

            # 첫 번째 레시피부터 보여줌
            response_data = await create_recipe_response(
                [recommendations[0]], "좋아요! 이런 레시피는 어떠세요?"
            )
            # request.session["recommendation_index"] = 0  # 인덱스를 0으로 설정
            new_session_data["new_recommendation_index"] = 0
        else:
            response_data = {
                "message": "아쉽지만 해당 조건에 맞는 레시피를 찾지 못했어요. 😥",
                "recipe": None,
            }

    elif intent_data.get("intent") == "greeting":
        response_data = {
            "message": "안녕하세요! 무엇을 도와드릴까요? 😊",
            "recipe": None,
        }

    elif intent_data.get("intent") == "ask_question":
        print("### 일반 질문 처리")
        subject = intent_data.get("subject", "요리")

        # 세션에서 마지막으로 추천했던 레시피 정보를 가져옴 (맥락으로 사용)
        # recommendations = request.session.get("recipe_recommendations", [])
        # current_index = request.session.get("recommendation_index", -1)

        # 세션 대신 Form 데이터에서 정보 가져오기
        # Spring Boot가 보낸 JSON 문자열을 파이썬 리스트, 딕셔너리로 변환
        recommendations = (
            json.loads(recommendations_json) if recommendations_json else []
        )
        current_index = recommendation_index if recommendation_index is not None else -1

        full_context_recipe = None
        if recommendations and current_index != -1:
            context_recipe_id = recommendations[current_index].get("recipe_id")
            if context_recipe_id:
                full_context_recipe = db.fetch_recipe_from_db(context_recipe_id)

        # 질문 답변 생성 메소드 호출
        answer = await api_utils.answer_user_question_with_gemini(
            message, subject, full_context_recipe
        )
        response_data = {"message": answer, "recipe": None}

    else:
        response_data = {
            "message": "죄송해요, 잘 이해하지 못했어요. 가지고 있는 재료를 알려주시겠어요?",
            "recipe": None,
        }

    bot_message = response_data.get("message")
    recipe = response_data.get("recipe")
    recipe_id = recipe.get("recipe_id") if recipe else None

    db.save_chat_message(session_id, "bot", bot_message, recipe_id)

    # 최종 응답에 세션 변경사항과 기존 응답을 합치기
    final_response = {
        **response_data,  # 기존의 message, recipe
        **new_session_data,  # new_recommendations, new_recommendation_indexs
    }

    # json_compatible_data = jsonable_encoder(response_data)
    json_compatible_data = jsonable_encoder(final_response)
    return JSONResponse(content=json_compatible_data)
