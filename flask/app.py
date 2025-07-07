import os
import uuid
import base64
import logging
import traceback
from datetime import datetime, timedelta
import re

import pymysql
import requests
import google.generativeai as genai
from google.generativeai import GenerativeModel
from flask import Flask, request, render_template, redirect, url_for, jsonify
from flask_cors import CORS
from urllib.parse import urlencode

from preference import preference_bp

# 로깅 설정
logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)
app.secret_key = "this_is_a_very_secret_key_12345"
CORS(app)

app.config["UPLOAD_FOLDER"] = "static/uploads"
os.makedirs(app.config["UPLOAD_FOLDER"], exist_ok=True)

# Gemini API 설정
genai.configure(api_key="AIzaSyCQIYftXpxtC-LhNF9f56p4AOgT8qfpjN8")
model = GenerativeModel("gemini-1.5-flash")

# MySQL 연결 설정
conn = pymysql.connect(
    host="192.168.0.33",
    user="team1",
    password="team1",
    db="test",
    charset="utf8mb4",
    cursorclass=pymysql.cursors.DictCursor,
)

# Spring API 기본 URL
SPRING_URL = "http://localhost:8080/api/refrigerator"


# get_shelf_life_from_gemini 함수
def get_shelf_life_from_gemini(ingredient):
    prompt = (
        f"'{ingredient}'의 개봉 후 냉장 보관 시 안전하게 섭취할 수 있는 **가장 일반적인** 권장 기간을 웹 검색을 통해 찾아 알려주세요."
        f"답변은 '약 X개월' 또는 '약 X일'과 같이 숫자가 포함된 형태로 알려주세요."
        f"잼과 같이 보존 기간이 긴 식품의 경우, **짧은 기간이 아닌 가장 일반적인 긴 기간**으로 답변해주세요."
        f"만약 정확한 개월/일수 숫자를 찾기 어렵거나 정보가 없는 경우, '정보 없음'이라고 답변해주세요."
        f"예시1 (잼류): '개봉 후 냉장 보관 시 약 1개월 정도 보관 가능합니다.' (이 경우 30일을 추출)"
        f"예시2 (신선식품): '개봉 후 냉장 보관 시 1일 이내 섭취하는 것이 좋습니다.' (이 경우 1일을 추출)"
        f"예시3: '정보 없음'"
        f"답변은 오직 이 텍스트로만 구성해 주세요: [Gemini 답변 텍스트]"
    )
    logging.debug(f"Gemini 프롬프트 (정교화): {prompt}")

    shelf_life_days = None
    display_info = "정보를 불러오는 중..."

    try:
        response = model.generate_content(prompt)
        gemini_answer = response.text.strip()
        logging.debug(f"Gemini 응답 원본: '{gemini_answer}'")

        display_info = gemini_answer

        match_months = re.search(r"약\s*(\d+)\s*개월", gemini_answer)
        if match_months:
            months = int(match_months.group(1))
            shelf_life_days = months * 30
            logging.info(
                f"'{ingredient}'에서 추출된 유통기한 개월수: {months}개월 -> {shelf_life_days}일"
            )
        else:
            match_days = re.search(r"(\d+)\s*일", gemini_answer)
            if match_days:
                shelf_life_days = int(match_days.group(1))
                logging.info(
                    f"'{ingredient}'에서 추출된 유통기한 일수: {shelf_life_days}일"
                )
            else:
                if "0일" in gemini_answer or "정보 없음" in gemini_answer:
                    shelf_life_days = 0
                    logging.warning(
                        f"'{ingredient}'의 유통기한 일수를 0으로 설정했습니다. (응답: '{gemini_answer}')"
                    )
                else:
                    logging.warning(
                        f"'{ingredient}' 응답에서 유효한 일수/개월수 숫자를 찾을 수 없습니다: '{gemini_answer}'"
                    )
                    shelf_life_days = None

    except Exception as e:
        logging.error(
            f"[오류] Gemini API 호출 또는 파싱 중 오류 발생 (재료: {ingredient}): {e}",
            exc_info=True,
        )
        display_info = f"'{ingredient}' 정보 조회 중 오류 발생."
        shelf_life_days = None

    return shelf_life_days, display_info


# describe_food_image_in_korean 함수
def describe_food_image_in_korean(image_path):
    try:
        with open(image_path, "rb") as f:
            image_bytes = f.read()
            encoded_image = base64.b64encode(image_bytes).decode("utf-8")

        response = model.generate_content(
            [
                "이 음식은 무엇인가요? 한국어로 음식 이름만 간단히 알려주세요. '입니다' 같은 말은 빼주세요.",
                {"inline_data": {"mime_type": "image/jpeg", "data": encoded_image}},
            ]
        )

        result = response.text.strip()
        logging.debug(f"Gemini Vision 분석 결과: {result}")
        return result or "분석 실패"

    except Exception as e:
        logging.error(f"Gemini Vision API 호출 실패: {e}")
        return "분석 실패"


# upload 함수
@app.route("/upload/<int:user_no>", methods=["GET", "POST"])
def upload(user_no):

    print(user_no)
    print(f"request.method: {request.method}")
    if request.method == "POST":

        file = request.files.get("image")

        if file:
            ext = os.path.splitext(file.filename)[1]
            unique_filename = f"{uuid.uuid4()}{ext}"
            filepath = os.path.join(app.config["UPLOAD_FOLDER"], unique_filename)
            file.save(filepath)

            label_ko = describe_food_image_in_korean(filepath)
            today = datetime.now().strftime("%Y-%m-%d")

            return redirect(
                url_for("confirm", ingredient=label_ko, purDate=today, user_no=user_no)
            )
    return render_template("upload.html", user_no=user_no)


# confirm 함수
@app.route("/confirm/<int:user_no>", methods=["GET", "POST"])
def confirm(user_no):
    logging.debug("=== confirm 함수 호출됨 ===")

    print(user_no)

    if request.method == "POST":
        logging.debug("POST 요청: 저장하지 않고 통과")
        ingredient = request.form.get("ingredient", "")
        purDate = request.form.get("purDate", "")

        if not ingredient or not purDate:
            return "재료명과 구매일을 모두 입력해주세요.", 400

        data = {"userNo": user_no, "ingredient": ingredient, "purDate": purDate}

        try:
            response = requests.post(SPRING_URL, json=data)
            if response.ok:
                return render_template(
                    "confirm.html",
                    user_no=user_no,
                    ingredient=ingredient,
                    purDate=purDate,
                    saved=True,
                )
            else:
                return f"Spring 저장 실패: {response.status_code} {response.text}", 500
        except Exception as e:
            logging.error(f"Spring 전송 오류: {e}")
            return "Spring 전송 중 오류 발생", 500

    # get 요청일때 렌더링
    ingredient = request.args.get("ingredient", "")
    purDate = request.args.get("purDate", "")

    return render_template(
        "confirm.html", user_no=user_no, ingredient=ingredient, purDate=purDate
    )


# send_to_spring 함수
def send_to_spring(user_no, ingredient, purDate):
    logging.debug("=== Spring 전송 시작 ===")

    print(f"회원 번호: {user_no}")

    if purDate and "T" in purDate:
        purDate = purDate.split("T")[0]

    data = {"userNo": user_no, "ingredient": ingredient, "purDate": purDate}
    logging.debug(f"전송할 데이터: {data}")
    try:
        response = requests.post(SPRING_URL, json=data)
        logging.debug(f"Spring 전송 성공: {response.status_code}")
        logging.debug(f"Spring 응답: {response.text}")
    except Exception as e:
        logging.error(f"Spring POST 요청 실패: {e}")


# get_ingredient_list 함수
def get_ingredient_list(user_no, ingredient=None, purDate=None, page=1, size=12):
    params = {"userNo": user_no, "page": page, "size": size}
    if ingredient and ingredient.strip():
        params["ingredient"] = ingredient.strip()
    if purDate and purDate.strip():
        try:
            if "T" in purDate:
                purDate = purDate.split("T")[0]
            datetime.strptime(purDate, "%Y-%m-%d")
            params["purDate"] = purDate
        except ValueError as e:
            logging.error(f"잘못된 날짜 형식: {purDate}, 오류: {e}")
            return [], 0

    query_string = urlencode(params)
    url = f"{SPRING_URL}?{query_string}"

    try:
        response = requests.get(url)
        logging.debug(f"API 응답 상태코드: {response.status_code}")
        logging.debug(f"응답본문: {repr(response.text)}")
        if response.status_code == 200:
            data = response.json()
            if isinstance(data, dict):
                items = data.get("content", [])
                total_count = data.get("totalCount", len(items))
            elif isinstance(data, list):
                items = data
                total_count = len(items)
            else:
                items = []
                total_count = 0

            return items, total_count

        else:
            logging.error(f"API 호출 실패: {response.status_code}, {response.text}")
            return [], 0
    except Exception as e:
        logging.error(f"재료 목록 불러오기 실패: {e}")
        return [], 0


# update_ingredient 함수
@app.route("/api/refrigerator/<int:indexNo>", methods=["PUT"])
def update_ingredient(indexNo):

    print(f"수정하는 메소드")

    try:
        res = requests.put(f"{SPRING_URL}/{indexNo}", json=request.get_json())
        return res.content, res.status_code, res.headers.items()
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# post_refrigerator 함수
@app.route("/api/refrigerator", methods=["POST"])
def post_refrigerator():

    print(f"등록하는 메소드")

    data = request.get_json()
    try:
        resp = requests.post(SPRING_URL, json=data)
        return resp.content, resp.status_code, resp.headers.items()
    except Exception as e:
        logging.error(f"Spring POST 요청 실패: {e}")
        return jsonify({"error": str(e)}), 500


# delete_ingredient 함수
@app.route("/delete_ingredient/<int:index_no>", methods=["DELETE"])
def delete_ingredient(index_no):

    print(f"삭제하는 메소드")

    logging.debug(f"재료 삭제 요청 : index_no:{index_no}")
    try:
        response = requests.delete(f"{SPRING_URL}/{index_no}")
        logging.debug(f"재료 삭제 성공 {response.status_code}")
        logging.debug(f"spring 응답: {response.text}")
        if response.ok:
            return jsonify({"message": "삭제 완료"})
        else:
            return jsonify({"error": "삭제 실패"}), 400
    except Exception as e:
        logging.error(f"재료 삭제 실패 {e}")
        return jsonify({"error": "삭제 중 오류 발생"}), 500


# index 함수
@app.route("/inputUserRefrigerator/<int:user_no>", methods=["GET", "POST"])
def index(user_no, ingredient=None, pur_date=None):
    # user_no = request.args.get("userNo", 1, type=int)
    ingredient = ingredient
    pur_date = pur_date

    page = request.args.get("page", 1, type=int)
    per_page = 12  # 한 페이지에 보여줄 항목 수

    print(f"\nflask 들어옴 - 회원번호 {user_no}")
    print(f"search_ingredient : {ingredient}")
    print(f"search_purDate : {pur_date}")
    print(f"요청: {request.method}\n\n\n")

    if request.method == "POST":
        userNo = user_no
        search_ingredient = request.form.get("ingredient", "").strip()
        search_purDate = request.form.get("purDate", "").strip()

        # 등록
        if search_ingredient and search_purDate:
            send_to_spring(user_no, search_ingredient, search_purDate)

        # 조회
        query_params = {"userNo": userNo, "page": 1}
        if search_ingredient:
            query_params["ingredient"] = search_ingredient
        if search_purDate:
            query_params["purDate"] = search_purDate
        query_string = urlencode(query_params)
        return redirect(f"/inputUserRefrigerator/?{query_string}")
    else:  # get 으로 들어옴
        userNo = user_no
        search_ingredient = request.args.get("ingredient", "").strip()
        search_purDate = request.args.get("purDate", "").strip()

        # 조회
        # query_params = {"userNo": userNo, "page": 1}
        # if search_ingredient:
        #     query_params["ingredient"] = search_ingredient
        # if search_purDate:
        #     query_params["purDate"] = search_purDate

        #     query_string = urlencode(query_params)

        #     print(f"search_ingredient : {search_ingredient}")
        #     print(f"search_purDate : {search_purDate}")

        #     return redirect(f"/inputUserRefrigerator/?{query_string}")

    # 페이징 포함 조회
    result, total_count = get_ingredient_list(
        user_no, search_ingredient, search_purDate, page, per_page
    )
    total_pages = (total_count + per_page - 1) // per_page

    # 현재 페이지 데이터 개수로 다음 페이지 존재여부 판단
    has_next = len(result) == per_page

    return render_template(
        "index.html",
        userNo=userNo,
        result=result,
        today=datetime.now().strftime("%Y-%m-%d"),
        search_ingredient=search_ingredient,
        search_purDate=search_purDate,
        currentPage=page,
        totalPages=total_pages,
        has_next=page < total_pages,
        total_count=total_count,
    )


# can_eat 함수
@app.route("/can_eat", methods=["POST"])
def can_eat():
    today = datetime.today().date()
    results = []

    try:
        data = request.get_json()
        selected_ingredients = data.get("ingredients", [])

        if not selected_ingredients:
            return jsonify({"error": "선택된 재료가 없습니다."}), 400

        conditions = []
        values = []

        for item in selected_ingredients:
            if not isinstance(item, dict):
                continue
            ingredient = item.get("ingredient")
            purDate = item.get("purDate")
            if ingredient and purDate:
                conditions.append("(ingredient = %s AND pur_date = %s)")
                values.extend([ingredient, purDate])

        if not conditions:
            return jsonify({"error": "유효한 재료 정보가 없습니다."}), 400

        try:
            conn.ping(reconnect=True)
        except Exception as e:
            logging.error(f"MySQL 재접속 실패: {e}")

        query = "SELECT * FROM user_refrigerator WHERE " + " OR ".join(conditions)
        with conn.cursor() as cursor:
            cursor.execute(query, values)
            rows = cursor.fetchall()

        for row in rows:
            name = row["ingredient"]
            purchase_date = row["pur_date"]
            if isinstance(purchase_date, str):
                purchase_date = datetime.strptime(purchase_date, "%Y-%m-%d").date()
            elif isinstance(purchase_date, datetime):
                purchase_date = purchase_date.date()

            shelf_life_days, display_info = get_shelf_life_from_gemini(name)

            if shelf_life_days is not None and shelf_life_days >= 0:
                expiry_date = purchase_date + timedelta(days=shelf_life_days)
                delta = (expiry_date - today).days

                if delta <= 0:
                    if delta == 0:
                        results.append(
                            f"{name}: 오늘 ({today.strftime('%Y-%m-%d')})까지 섭취해야 합니다! ({display_info})"
                        )
                    else:
                        results.append(
                            f"{name}: {abs(delta)}일 지났습니다. 음식물 버리세요. ({display_info})"
                        )
                else:
                    results.append(
                        f"{name}: 사용기한이 {delta}일 남았습니다. ({expiry_date.strftime('%Y-%m-%d')}까지 섭취 권장) ({display_info})"
                    )
            else:
                results.append(f"{display_info}")

    except Exception as e:
        logging.error(f"can_eat 오류: {e}", exc_info=True)
        return jsonify({"error": str(e)}), 500

    return jsonify({"results": results})


# preference 블루프린트 등록
app.register_blueprint(preference_bp)

# 애플리케이션 실행
if __name__ == "__main__":
    app.run(debug=True)
