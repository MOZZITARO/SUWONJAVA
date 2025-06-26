import os
import uuid
from flask import Flask, request, render_template, redirect, url_for, jsonify
import requests
from datetime import datetime, timedelta
import google.generativeai as genai
from flask_cors import CORS
import pymysql

app = Flask(__name__)
CORS(app)

app.config['UPLOAD_FOLDER'] = 'static/uploads'
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

genai.configure(api_key="AIzaSyCQIYftXpxtC-LhNF9f56p4AOgT8qfpjN8")
model = genai.GenerativeModel("gemini-1.5-flash")

conn = pymysql.connect(
    host='localhost',
    user='root',
    password='1234',
    db='test',
    charset='utf8mb4',
    cursorclass=pymysql.cursors.DictCursor
)

def get_shelf_life_from_gemini(ingredient):
    prompt = f"{ingredient}는 냉장 보관시 보통 며칠간 사용할 수 있나요? 숫자만 단위없이 알려주세요."
    try:
        response = model.generate_content(prompt)
        answer = response.text.strip()
        days = int(''.join(filter(str.isdigit, answer)))
        return days
    except Exception as e:
        print(f"[오류] {ingredient} 처리 중 오류: {e}")
        return None

def describe_food_image_in_korean(image_path):
    try:
        with open(image_path, "rb") as f:
            image_bytes = f.read()

        response = model.generate_content(
            [
                "이 음식은 무엇인가요? 한국어로 음식 이름만 간단히 알려주세요. '입니다' 같은 말은 빼주세요.",
                genai.types.content.ImagePart(image_bytes=image_bytes)
            ]
        )

        result = response.text.strip()
        print("Gemini Vision 분석 결과:", result)
        return result or "분석 실패"

    except Exception as e:
        print("Gemini Vision API 호출 실패:", e)
        return "분석 실패"

@app.route('/upload', methods=['GET', 'POST'])
def upload():
    if request.method == 'POST':
        file = request.files.get('image')
        if file:
            ext = os.path.splitext(file.filename)[1]
            unique_filename = f"{uuid.uuid4()}{ext}"
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], unique_filename)
            file.save(filepath)

            label_ko = describe_food_image_in_korean(filepath)
            today = datetime.now().strftime('%Y-%m-%d')

            return redirect(url_for('confirm', ingredient=label_ko, purDate=today))
    return render_template('upload.html')

@app.route('/confirm', methods=['GET', 'POST'])
def confirm():
    print("=== confirm 함수 호출됨 ===")

    if request.method == 'POST':
        print("POST 요청 처리 중")

        user_no = 1
        ingredient = request.form.get('ingredient', '')
        purDate = request.form.get('purDate', '')

        print(f"받은 데이터 - ingredient: {ingredient}, purDate: {purDate}")

        send_to_spring(user_no, ingredient, purDate)
        return redirect(url_for('index'))

    ingredient = request.args.get('ingredient', '')
    purDate = request.args.get('purDate', '')

    print(f"GET 파라미터 - ingredient: {ingredient}, purDate: {purDate}")

    return render_template('confirm.html', ingredient=ingredient, purDate=purDate)

def send_to_spring(user_no, ingredient, purDate):
    print("=== Spring 전송 시작 ===")

    spring_url = "http://localhost:8080/api/refrigerator"

    if purDate and 'T' in purDate:
        purDate = purDate.split('T')[0]

    data = {
        "userNo": user_no,
        "ingredient": ingredient,
        "purDate": purDate
    }

    print(f"전송할 데이터: {data}")
    print(f"purDate 타입: {type(purDate)}, 값: '{purDate}'")

    try:
        response = requests.post(spring_url, json=data)
        print("Spring 전송 성공:", response.status_code)
        print("Spring 응답:", response.text)
    except Exception as e:
        print("Spring 전송 실패:", e)

def get_ingredient_list(user_no, ingredient=None, purDate=None):
    spring_url = f"http://localhost:8080/api/refrigerator?userNo={user_no}"
    if ingredient:
        spring_url += f"&ingredient={ingredient}"
    if purDate:
        spring_url += f"&purDate={purDate}"

    try:
        response = requests.get(spring_url)
        print("API 응답 상태코드:", response.status_code)
        print("불러온 원본 데이터:", response.json())

        if response.status_code == 200:
            data = response.json()
            return data
        else:
            print("API 호출 실패:", response.status_code, response.text)
            return []
    except Exception as e:
        print("재료 목록 불러오기 실패:", e)
        return []

@app.route('/delete_ingredient/<int:index_no>', methods=['DELETE'])
def delete_ingredient(index_no):
    print(f"재료 삭제 요청 : index_no:{index_no}")

    spring_url = f"http://localhost:8080/api/refrigerator/{index_no}"

    try:
        response = requests.delete(spring_url)
        print("재료 삭제 성공", response.status_code)
        print("spring 응답:", response.text)
        if response.ok:
            return jsonify({"message": "삭제 완료"})
        else:
            return jsonify({"error": "삭제 실패"}), 400
    except Exception as e:
        print("재료 삭제 실패 ", e)
        return jsonify({"error": "삭제 중 오류 발생"}), 500

@app.route('/', methods=['GET', 'POST'])
def index():
    user_no = 1
    result = get_ingredient_list(user_no)

    if request.method == 'POST':
        ingredient = request.form.get('ingredient', '')
        purDate = request.form.get('purDate', '')
        if ingredient and purDate:
            send_to_spring(user_no, ingredient, purDate)
            result = get_ingredient_list(user_no, ingredient, purDate)
        else:
            result = get_ingredient_list(user_no)

    return render_template('index.html', result=result, today=datetime.now().strftime('%Y-%m-%d'))

@app.route('/can_eat', methods=['POST'])
def can_eat():
    today = datetime.today().date()
    results = []

    try:
        data = request.get_json()
        selected_ingredients = data.get('ingredients', [])

        if not selected_ingredients:
            return jsonify({"error": "선택된 재료가 없습니다."}), 400

        with conn.cursor() as cursor:
            placeholders = ','.join(['%s'] * len(selected_ingredients))
            query = f"SELECT * FROM user_refrigerator WHERE ingredient IN ({placeholders})"
            cursor.execute(query, selected_ingredients)
            rows = cursor.fetchall()

        for row in rows:
            name = row['ingredient']
            purchase_date = row['pur_date']
            if isinstance(purchase_date, str):
                purchase_date = datetime.strptime(purchase_date, "%Y-%m-%d").date()

            limit_days = get_shelf_life_from_gemini(name)

            if limit_days:
                expiry_date = purchase_date + timedelta(days=limit_days) - timedelta(days=1)
                delta = (expiry_date - today).days

                if delta < 0:
                    results.append(f"{name}은 {abs(delta)}일 지났습니다. 음식물 버리세요.")
                else:
                    results.append(f"{name}은 사용기한이 {delta}일 남았습니다. (만료일 {expiry_date})")
            else:
                results.append(f"[경고] Gemini가 '{name}'의 유통기한 정보를 제공하지 못했습니다.")

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    return jsonify({"results": results})

if __name__ == '__main__':
    app.run(debug=True)
