from flask import Blueprint, request, render_template, jsonify
import requests
import traceback

preference_bp = Blueprint("preference", __name__)

SPRING_API_URL = "http://localhost:8080/api/preferences"


@preference_bp.route("/preference/<int:user_no>", methods=["GET", "POST"])
def preference(user_no):

    print(f"들어옴 요청 메소드 : {request.method}")

    if request.method == "POST":
        user_no = user_no  # 추후 로그인 세션 등에서 동적으로 받아올 예정

        try:
            like_foods = request.form.getlist("like_food") or []
            dislike_foods = request.form.getlist("dislike_food") or []
            like_ingredients = request.form.getlist("like_ingredient") or []
            dislike_ingredients = request.form.getlist("dislike_ingredient") or []

            like_food_input = request.form.get("like_food_input")
            dislike_food_input = request.form.get("dislike_food_input")
            like_ingredient_input = request.form.get("like_ingredient_input")
            dislike_ingredient_input = request.form.get("dislike_ingredient_input")

            def split_input(input_str):
                if not input_str:
                    return []
                return [item.strip() for item in input_str.split(",") if item.strip()]

            if like_food_input and like_food_input.strip():
                like_foods.extend(split_input(like_food_input))
            if dislike_food_input and dislike_food_input.strip():
                dislike_foods.extend(split_input(dislike_food_input))
            if like_ingredient_input and like_ingredient_input.strip():
                like_ingredients.extend(split_input(like_ingredient_input))
            if dislike_ingredient_input and dislike_ingredient_input.strip():
                dislike_ingredients.extend(split_input(dislike_ingredient_input))

            # 중복 제거
            like_foods = list(set(like_foods))
            dislike_foods = list(set(dislike_foods))
            like_ingredients = list(set(like_ingredients))
            dislike_ingredients = list(set(dislike_ingredients))

            data = {
                "userNo": user_no,
                "likeFoods": like_foods,
                "dislikeFoods": dislike_foods,
                "likeIngredients": like_ingredients,
                "dislikeIngredients": dislike_ingredients,
            }

            print("▶️ Spring Boot에 전송할 데이터:", data)

            resp = requests.post(SPRING_API_URL, json=data, timeout=10)
            resp.raise_for_status()

            try:
                response_data = resp.json()
            except Exception:
                response_data = resp.text

            print("◀️ Spring Boot 응답:", resp.status_code, response_data)

            # 저장 완료 메시지 제거 → 메시지 없이 단순히 폼 다시 렌더링
            return render_template("preference_form.html")

        except requests.exceptions.RequestException as e:
            print("❌ Spring API 요청 실패:", e)
            traceback.print_exc()
            return render_template(
                "preference_form.html", message=f"Spring API 요청 실패: {e}"
            )

        except Exception as e:
            print("❌ 서버 내부 오류:", e)
            traceback.print_exc()
            return render_template("preference_form.html", message=f"서버 오류: {e}")

    else:
        return render_template("preference_form.html", userNo=user_no)
