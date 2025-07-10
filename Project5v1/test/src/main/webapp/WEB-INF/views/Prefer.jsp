<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>음식/재료 선호도 입력</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f6fa;
            padding: 30px;
            color: #333;
        }

        h2 {
            color: #6a5acd;
            margin-top: 30px;
            font-size: 20px;
            border-bottom: 2px solid #d8bfd8;
            padding-bottom: 8px;
        }

        .buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin: 10px 0 15px;
        }

        .btn {
            padding: 10px 16px;
            border: none;
            border-radius: 20px;
            background-color: #d8bfd8;
            color: white;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .btn.active {
            background-color: #6a5acd;
            transform: translateY(-1px);
            box-shadow: 0 4px 10px rgba(106, 90, 205, 0.3);
        }

        .btn:hover {
            background-color: #c0a8c0;
            transform: scale(1.05);
        }

        input[type="text"] {
            padding: 10px;
            width: 100%;
            max-width: 400px;
            margin-bottom: 15px;
            border: 2px solid #d8bfd8;
            border-radius: 10px;
            font-size: 14px;
            color: #483d8b;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        input[type="text"]:focus {
            outline: none;
            border-color: #6a5acd;
            box-shadow: 0 0 8px rgba(106, 90, 205, 0.3);
        }

        button[type="submit"] {
            margin-top: 25px;
            padding: 12px 30px;
            background-color: #6a5acd;
            color: #fff;
            border: none;
            border-radius: 30px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        button[type="submit"]:hover {
            background-color: #5a4bb2;
            transform: translateY(-2px);
        }

        ul {
            list-style-type: none;
            padding-left: 0;
            margin-top: 20px;
        }

        li {
            font-size: 15px;
            margin: 6px 0;
            padding: 5px 10px;
        }
    </style>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(button => {
                button.addEventListener('click', function () {
                    this.classList.toggle('active');
                    const value = this.getAttribute('data-value');
                    const name = this.getAttribute('data-name');
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = name;
                    input.value = value;
                    if (this.classList.contains('active')) {
                        this.parentElement.appendChild(input);
                    } else {
                        const inputs = this.parentElement.querySelectorAll(`input[name="${name}"][value="${value}"]`);
                        inputs.forEach(i => i.remove());
                    }
                });
            });

            // 입력창을 hidden input으로 추가
            const form = document.querySelector('form');
            form.addEventListener('submit', function(e) {
                const mapping = [
                    { textName: 'like_food_input', hiddenName: 'like_food' },
                    { textName: 'dislike_food_input', hiddenName: 'dislike_food' },
                    { textName: 'like_ingredient_input', hiddenName: 'like_ingredient' },
                    { textName: 'dislike_ingredient_input', hiddenName: 'dislike_ingredient' }
                ];

                mapping.forEach(pair => {
                    const textInput = form.querySelector(`input[name="${pair.textName}"]`);
                    if (textInput && textInput.value.trim() !== '') {
                        const existingInputs = form.querySelectorAll(`input[name="${pair.hiddenName}"][value="${textInput.value.trim()}"]`);
                        existingInputs.forEach(input => input.remove());

                        const hiddenInput = document.createElement('input');
                        hiddenInput.type = 'hidden';
                        hiddenInput.name = pair.hiddenName;
                        hiddenInput.value = textInput.value.trim();
                        form.appendChild(hiddenInput);
                    }
                });
            });
        });
    </script>
</head>

<body>
    <form method="POST">
        <h2>좋아하는 음식</h2>
        <div class="buttons">
            <button type="button" class="btn" data-name="like_food" data-value="떡볶이">떡볶이</button>
            <button type="button" class="btn" data-name="like_food" data-value="김밥">김밥</button>
            <button type="button" class="btn" data-name="like_food" data-value="치킨">치킨</button>
            <button type="button" class="btn" data-name="like_food" data-value="피자">피자</button>
            <button type="button" class="btn" data-name="like_food" data-value="라면">라면</button>
            <button type="button" class="btn" data-name="like_food" data-value="햄버거">햄버거</button>
            <button type="button" class="btn" data-name="like_food" data-value="김치찌개">김치찌개</button>
            <button type="button" class="btn" data-name="like_food" data-value="불고기">불고기</button>
            <button type="button" class="btn" data-name="like_food" data-value="샌드위치">샌드위치</button>
        </div>
        <div><input type="text" name="like_food_input" placeholder="좋아하는 음식을 입력해주세요."></div>

        <h2>싫어하는 음식</h2>
        <div class="buttons">
            <button type="button" class="btn" data-name="dislike_food" data-value="된장찌개">된장찌개</button>
            <button type="button" class="btn" data-name="dislike_food" data-value="순댓국">순댓국</button>
            <button type="button" class="btn" data-name="dislike_food" data-value="낙지볶음">낙지볶음</button>
            <button type="button" class="btn" data-name="dislike_food" data-value="해물탕">해물탕</button>
            <button type="button" class="btn" data-name="dislike_food" data-value="곰탕">곰탕</button>
            <button type="button" class="btn" data-name="dislike_food" data-value="갈비탕">갈비탕</button>
            <button type="button" class="btn" data-name="dislike_food" data-value="오징어회">오징어회</button>
            <button type="button" class="btn" data-name="dislike_food" data-value="추어탕">추어탕</button>
        </div>
        <div><input type="text" name="dislike_food_input" placeholder="싫어하는 음식을 입력해주세요."></div>

        <h2>좋아하는 재료</h2>
        <div class="buttons">
            <button type="button" class="btn" data-name="like_ingredient" data-value="치즈">치즈</button>
            <button type="button" class="btn" data-name="like_ingredient" data-value="계란">계란</button>
            <button type="button" class="btn" data-name="like_ingredient" data-value="고기">고기</button>
            <button type="button" class="btn" data-name="like_ingredient" data-value="채소">채소</button>
            <button type="button" class="btn" data-name="like_ingredient" data-value="생선">생선</button>
            <button type="button" class="btn" data-name="like_ingredient" data-value="쌀">쌀</button>
            <button type="button" class="btn" data-name="like_ingredient" data-value="버터">버터</button>
            <button type="button" class="btn" data-name="like_ingredient" data-value="밀가루">밀가루</button>
            <button type="button" class="btn" data-name="like_ingredient" data-value="감자">감자</button>
        </div>
        <div><input type="text" name="like_ingredient_input" placeholder="좋아하는 재료를 입력해주세요."></div>

        <h2>싫어하는 재료</h2>
        <div class="buttons">
            <button type="button" class="btn" data-name="dislike_ingredient" data-value="양파">양파</button>
            <button type="button" class="btn" data-name="dislike_ingredient" data-value="마늘">마늘</button>
            <button type="button" class="btn" data-name="dislike_ingredient" data-value="고추">고추</button>
            <button type="button" class="btn" data-name="dislike_ingredient" data-value="생선">생선</button>
            <button type="button" class="btn" data-name="dislike_ingredient" data-value="굴">굴</button>
            <button type="button" class="btn" data-name="dislike_ingredient" data-value="새우">새우</button>
            <button type="button" class="btn" data-name="dislike_ingredient" data-value="문어">문어</button>
            <button type="button" class="btn" data-name="dislike_ingredient" data-value="홍합">홍합</button>
        </div>
        <div><input type="text" name="dislike_ingredient_input" placeholder="싫어하거나 피하고 싶은 재료를 입력해주세요."></div>

        <button type="submit">저장하기</button>
    </form>

    {% with messages = get_flashed_messages(with_categories=true) %}
        {% if messages %}
            <ul>
                {% for category, message in messages %}
                    <li style="color: {% if category == 'success' %}green{% else %}red{% endif %};">
                        {{ message }}
                    </li>
                {% endfor %}
            </ul>
        {% endif %}
    {% endwith %}d
</body>
</html>
