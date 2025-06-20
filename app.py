import os
import uuid
from flask import Flask, request, render_template, redirect, url_for
import google.generativeai as genai
import requests
from datetime import date

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'static/uploads'
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# Gemini API 키 설정 (본인의 키로 교체하세요)
genai.configure(api_key="AIzaSyCQIYftXpxtC-LhNF9f56p4AOgT8qfpjN8")
model_vision = genai.GenerativeModel(model_name="gemini-1.5-flash")


def describe_food_image_in_korean(img_path):
    with open(img_path, "rb") as img_file:
        image_bytes = img_file.read()
    try:
        response = model_vision.generate_content([
            {"mime_type": "image/jpeg", "data": image_bytes},
            "이 음식은 무엇인가요? 한국어로 음식 이름만 간단히 알려주세요. 입니다는 빼주세요."
        ])
        return response.text.strip()
    except Exception as e:
        print("Gemini API 호출 실패:", e)
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
            today = date.today().isoformat()

            return redirect(url_for('confirm', ingredient=label_ko, pur_date=today))
    return render_template('upload.html')


@app.route('/confirm', methods=['GET', 'POST'])
def confirm():
    print("=== confirm 함수 호출됨 ===")  # 이 줄이 있나요?
    
    if request.method == 'POST':
        print("POST 요청 처리 중")  # 이 줄이 있나요?
        
        user_no = 1
        ingredient = request.form.get('ingredient', '')  # .get() 사용하나요?
        pur_date = request.form.get('pur_date', '')      # .get() 사용하나요?
        
        print(f"받은 데이터 - ingredient: {ingredient}, pur_date: {pur_date}")  # 이 줄이 있나요?
        
        send_to_spring(user_no, ingredient, pur_date)
        return redirect(url_for('index'))
    
    # GET 요청 처리
    ingredient = request.args.get('ingredient', '')
    pur_date = request.args.get('pur_date', '')
    
    print(f"GET 파라미터 - ingredient: {ingredient}, pur_date: {pur_date}")  # 이 줄이 있나요?
    
    return render_template('confirm.html', ingredient=ingredient, pur_date=pur_date)

def send_to_spring(user_no, ingredient, pur_date):
    print("=== Spring 전송 시작 ===")  # 이 줄이 있나요?
    
    spring_url = "http://localhost:8080/api/refrigerator"
    data = {
        "userNo": user_no,
        "ingredient": ingredient,
        "purDate": pur_date
    }
    
    print(f"전송할 데이터: {data}")  # 이 줄이 있나요?
    
    try:
        response = requests.post(spring_url, json=data)
        print("spring 전송 성공:", response.status_code)
        print("Spring 응답:", response.text)  # 이 줄이 있나요?
    except Exception as e:
        print("spring 전송 실패:", e)


def get_ingredient_list(user_no):
    spring_url = f"http://localhost:8080/api/refrigerator?userNo={user_no}"
    try:
        response = requests.get(spring_url)
        
        print("불러온 데이터:", response.json())
        
        return response.json()
    except Exception as e:
        print("재료 목록 불러오기 실패:", e)
        return []


@app.route('/', methods=['GET'])
def index():
    user_no = 1
    result = get_ingredient_list(user_no)
    return render_template('index.html', result=result)


if __name__ == '__main__':
    app.run(debug=True)
