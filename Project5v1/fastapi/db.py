import pymysql
import re
import os
from dotenv import load_dotenv
from dbutils.pooled_db import PooledDB
import random

load_dotenv()

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_NAME"),
    "cursorclass": pymysql.cursors.DictCursor,
}

# 커넥션 풀 생성
pool = PooledDB(creator=pymysql, maxconnections=10, **DB_CONFIG)


# 공공데이터 포탈 API를 사용해서 가져온 레시피 데이터 중 재료(RCP_PARTS_DTLS) 부분을 파싱하는 메소드
def parse_ingredients(parts_details: str) -> list:

    # 1. 초기 전처리: 줄바꿈을 쉼표로, 여러 공백을 단일 공백으로 변경
    text = parts_details.replace("\n", ",")
    text = re.sub(r"\s+", " ", text).strip()

    # 2. 불필요한 섹션 제목 및 기호 제거
    # 예: "●오이무침 :", "●곁들임 :", "[1인분]", "·양념장 :" 등
    # 콜론(:) 유무와 상관없이 제거하고, 결과적으로 생긴 여러 쉼표를 하나로 합침
    text = re.sub(
        r"[●•■]\s*[^,:]+\s*:\s*", ",", text, flags=re.UNICODE
    )  # "● 제목 :" 형태 제거
    text = re.sub(r"\[[^\]]+\]\s*", ",", text)  # "[1인분]" 형태 제거
    text = re.sub(r"·\s*[^,:]+\s*:\s*", ",", text)  # "· 제목 :" 형태 제거
    text = re.sub(r",\s*,", ",", text).strip(" ,")  # 중복 쉼표 및 앞뒤 쉼표/공백 제거

    # 3. 쉼표를 기준으로 재료들을 분리하고, 빈 항목 제거
    items = [item.strip() for item in text.split(",") if item.strip()]

    all_ingredients = []

    # 4. 각 재료 항목을 [이름, 양, 설명]으로 파싱하는 정규표현식
    # 그룹 1 (이름): 문자열 시작 부분의 텍스트 (숫자, 괄호, 특수기호 제외)
    # 그룹 2 (양): 이름 뒤에 나오는 숫자와 단위 (선택 사항)
    # 그룹 3 (설명): 괄호 안의 텍스트 (선택 사항)
    # 그룹 4 (단순 이름): 위 패턴에 맞지 않을 경우, 전체 문자열을 이름으로 간주
    pattern = re.compile(
        r"^\s*"
        r"([가-힣A-Za-z\s]+?)"  # 그룹 1: 재료명 (가장 최소한으로 매칭)
        r"\s*([\d./]+\s*(?:g|kg|ml|L|개|마리|큰술|작은술|컵|모|줄기|쪽|장|T|t|톨|포기|단|봉지|쪽|알|뿌리|장)?)?"  # 그룹 2: 양과 단위 (선택)
        r"\s*(\([^)]*\))?"  # 그룹 3: 괄호 안 설명 (선택)
        r"\s*$"
    )

    for item in items:
        match = pattern.match(item)

        if match:
            # 정규표현식으로 이름, 양, 설명 분리
            name, quantity, description = match.groups()

            # 후처리: 각 부분의 앞뒤 공백 제거 및 None 값 처리
            name = name.strip() if name else ""
            quantity = quantity.strip() if quantity else ""
            description = description.strip("()") if description else ""

            # '흰 후추 약간' 같은 케이스 처리: 양(quantity)이 없고, 이름에 '약간', '조금' 등이 붙은 경우
            if not quantity and ("약간" in name or "조금" in name):
                parts = name.split()
                if len(parts) > 1:
                    name = " ".join(parts[:-1])
                    quantity = parts[-1]

            # 이름이 유효한 경우에만 리스트에 추가
            if name and name not in ["재료", "필수재료", "주재료"]:
                all_ingredients.append(
                    {"name": name, "quantity": quantity, "description": description}
                )
        elif item:  # 정규표현식에 매칭되지 않았지만, 내용이 있는 경우 (예: '참깨 약간')
            # '약간' 이나 '조금' 으로 끝나는지 확인
            if "약간" in item or "조금" in item:
                parts = item.split()
                item_name = " ".join(parts[:-1]).strip()
                item_qty = parts[-1].strip()
                if item_name:
                    all_ingredients.append(
                        {"name": item_name, "quantity": item_qty, "description": ""}
                    )
            else:  # 그 외의 경우는 전체를 이름으로 처리
                all_ingredients.append(
                    {"name": item.strip(), "quantity": "", "description": ""}
                )

    # 디버깅을 위해 파싱된 최종 결과 출력
    print(f"--- 파싱 시작: {parts_details[:50]}...")
    for ing in all_ingredients:
        print(
            f"  -> 이름: '{ing['name']}', 양: '{ing['quantity']}', 설명: '{ing['description']}'"
        )
    print("--- 파싱 완료 ---\n")

    return all_ingredients


# 데이터베이스 연결을 위한 메소드
def get_db_connection():
    # return pymysql.connect(**DB_CONFIG)
    return pool.connection()


# 데이터베이스에서 특정 재료를 제외한 레시피를 랜덤으로 조회하는 메소드
def get_random_recipes_excluding(exclude_ingredients: list, count: int = 3) -> list:
    """특정 재료들을 제외한 레시피 중에서 랜덤으로 N개 가져옴."""

    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:

            # 제외할 재료가 포함된 모든 recipe_id를 찾기
            exclude_ingredients = ",".join(["%s"] * len(exclude_ingredients))
            sql = f"""
                SELECT DISTINCT recipe_id FROM ingredient WHERE name IN ({exclude_ingredients})
            """
            cursor.execute(sql, exclude_ingredients)
            exclude_ids = {row["recipe_id"] for row in cursor.fetchall()}

            # 제외할 재료가 포함된 recipe_id들을 제외하고 랜덤으로 N개 가져오기
            if exclude_ids:
                # NOT IN 절을 사용하기 위해 id 목록을 문자열로 변환
                ids_to_exclude_str = ",".join(map(str, exclude_ids))
                sql_random = f"SELECT recipe_id, name FROM recipe WHERE recipe_id NOT IN ({ids_to_exclude_str}) ORDER BY RAND() LIMIT %s"
                cursor.execute(sql_random, (count,))
            else:
                # 제외할 재료가 없으면 그냥 랜덤으로 가져오기
                sql_random = (
                    f"SELECT recipe_id, name FROM recipe ORDER BY RAND() LIMIT %s"
                )
                cursor.execute(sql_random, (count,))
                recipes = cursor.fetchall()

            # 서비스 레이어에서 사용할 수 있도록 'source' 키 추가
            for recipe in recipes:
                recipe["source"] = "Random"

            return recipes if recipes else []
    except Exception as e:
        print(f"### 랜덤 레시피 조회 중 DB 오류: {e}")
        return []
    finally:
        conn.close()


# 데이터베이스에서 레시피를 랜덤으로 조회하는 메소드
def get_random_recipes(count: int = 3) -> list:
    """데이터베이스에서 레시피를 랜덤으로 지정된 개수만큼 가져옴.
    레시피 테이블의 주요 정보만 리턴
    """

    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            sql = f"SELECT recipe_id, name, image_thumbnail_url FROM recipe ORDER BY RAND() LIMIT %s"
            cursor.execute(sql, (count,))
            recipes = cursor.fetchall()

            # 서비스 레이어에서 사용할 수 있도록 'source' 키 추가
            for recipe in recipes:
                recipe["source"] = "Random"

            return recipes if recipes else []
    except Exception as e:
        print(f"### 랜덤 레시피 조회 중 DB 오류: {e}")
        return []
    finally:
        conn.close()


# 데이터베이스에서 레시피가 이미 존재하는지 확인하는 메소드
def check_existing_recipe(
    include_ingredients: list, exclude_ingredients: list = None
) -> list:
    """포함할 재료는 모두 포함하고, 제외할 재료는 포함하지 않는 레시피 id 조회, 결과는 랜덤하게 섞어서 반환"""

    # 포함 재료가 없으면 빈 리스트 반환
    if not include_ingredients:
        return []

    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:

            # 포함 재료를 모두 가진 레시피 id 찾기
            placeholders = ",".join(["%s"] * len(include_ingredients))

            sql = f"""
                SELECT recipe_id FROM ingredient 
                WHERE name IN ({placeholders})
                GROUP BY recipe_id
                HAVING COUNT(DISTINCT name) = %s
            """
            param_include = include_ingredients + [len(include_ingredients)]
            cursor.execute(sql, param_include)

            # 결과가 없으면 바로 종료
            include_ids = [row["recipe_id"] for row in cursor.fetchall()]
            if not include_ids:
                return []

            # 제외할 재료가 있는 경우, 해당 재료를 포함한 레시피 id를 필터링
            if exclude_ingredients:
                placeholders_exclude = ",".join(["%s"] * len(exclude_ingredients))
                sql = f"""
                    SELECT DISTINCT recipe_id FROM ingredient
                    WHERE recipe_id IN ({','.join(['%s'] * len(include_ids))})
                    AND name IN ({placeholders_exclude})
                """
                param_exclude = include_ids + exclude_ingredients
                cursor.execute(sql, param_exclude)

                exclude_ids = {row["recipe_id"] for row in cursor.fetchall()}

                # 최종 레시피 id 리스트 : 포함 레시피 id 리스트에서 제외 id 리스트 빼기
                final_ids = [id for id in include_ids if id not in exclude_ids]

            else:
                final_ids = include_ids

            # 결과 랜덤 섞기
            random.shuffle(final_ids)

            return final_ids

    finally:
        conn.close()


# 데이터베이스에서 레시피를 가져오는 메소드
def fetch_recipe_from_db(recipe_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            sql = "SELECT * FROM recipe WHERE recipe_id = %s"
            cursor.execute(sql, [recipe_id])
            recipe = cursor.fetchone()

            if not recipe:
                return None

            sql_ing = "SELECT name, quantity, description FROM ingredient WHERE recipe_id = %s"
            cursor.execute(sql_ing, [recipe_id])
            ingredients = cursor.fetchall()
            sql_inst = "SELECT step_num, description, image_url FROM instruction WHERE recipe_id = %s"
            cursor.execute(sql_inst, [recipe_id])
            instructions = cursor.fetchall()

            # recipe 딕셔너리에 추가 정보를 병합
            # 1. 원본 recipe 딕셔너리의 모든 정보를 유지합니다.
            #    (여기에는 image_main_url, image_thumbnail_url 등이 모두 포함됩니다)
            final_recipe_data = dict(recipe)

            # 2. 추가적인 정보를 새로운 키로 할당합니다.
            final_recipe_data["ingredients"] = ingredients
            final_recipe_data["instructions"] = instructions

            return final_recipe_data

            # --- 또는 아래처럼 스프레드 연산자를 사용할 수도 있습니다 ---
            # return {
            #     **recipe, # recipe 딕셔너리의 모든 키-값을 여기에 펼쳐넣음
            #     "ingredients": ingredients,
            #     "instructions": instructions,
            #     "manuals": [inst["description"] for inst in instructions],
            # }

            # return {
            #     "recipe_id": recipe["recipe_id"],
            #     "name": recipe["name"],
            #     "image_main_url": recipe[
            #         "image_main_url"
            #     ],  # 명시적으로 추가하여 확인 (선택사항)
            #     "image_thumbnail_url": recipe[
            #         "image_thumbnail_url"
            #     ],  # 명시적으로 추가하여 확인 (선택사항)
            #     "ingredients": ingredients,
            #     "instructions": instructions,
            #     "manuals": [inst["description"] for inst in instructions],
            #     "tip": recipe.get("tip", ""),  # 레시피 테이블에 팁 컬럼 추가하기
            # }
    finally:
        conn.close()


# 데이터베이스에 레시피를 저장하는 메소드
def save_recipe_to_db(recipe_data, parsed_ingredients):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            sql_check = "SELECT recipe_id FROM recipe WHERE name = %s AND cooking_method = %s AND cuisine_type = %s"
            cursor.execute(
                sql_check,
                (
                    recipe_data["name"],
                    recipe_data["cooking_method"],
                    recipe_data["cuisine_type"],
                ),
            )
            if cursor.fetchone():
                return None

            # 재료 파싱 (raw_parts_details에서 추출)
            # ingredients_list = parse_ingredients(recipe_data["raw_parts_details"])
            # print(f"### 파싱된 재료: {ingredients_list}")

            # recipe 테이블 삽입
            sql_recipe = """
                INSERT INTO recipe (cooking_method, name, cuisine_type, calories, info_wgt, info_car, info_fat, info_na, info_pro, hash_tag, image_main_url, image_thumbnail_url, tip)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(
                sql_recipe,
                (
                    recipe_data["cooking_method"],
                    recipe_data["name"],
                    recipe_data["cuisine_type"],
                    recipe_data["calories"],
                    recipe_data["info_wgt"],
                    recipe_data["info_car"],
                    recipe_data["info_fat"],
                    recipe_data["info_na"],
                    recipe_data["info_pro"],
                    recipe_data["hash_tag"],
                    recipe_data["image_main_url"],
                    recipe_data["image_thumbnail_url"],
                    recipe_data["tip"],
                ),
            )
            recipe_id = cursor.lastrowid

            # ingredient 테이블 삽입
            for ing in parsed_ingredients:
                sql_ingredient = "INSERT INTO ingredient (recipe_id, name, quantity, description) VALUES (%s, %s, %s, %s)"
                cursor.execute(
                    sql_ingredient,
                    (recipe_id, ing["name"], ing["quantity"], ing["description"]),
                )

            # instruction 테이블 삽입
            for i in range(1, 21):
                manual_key = f"manual_{i:02d}"
                image_key = f"manual_img_{i:02d}"
                manual = recipe_data.get(manual_key, "")
                image_url = recipe_data.get(image_key, "")
                if manual:
                    sql_instruction = "INSERT INTO instruction (recipe_id, step_num, description, image_url) VALUES (%s, %s, %s, %s)"
                    cursor.execute(sql_instruction, (recipe_id, i, manual, image_url))

            conn.commit()
            return recipe_id
    except Exception as e:
        print(f"DB Error: {e}")
        conn.rollback()
        return None
    finally:
        conn.close()


# OLLAMA를 사용해서 생성한 레시피 설명을 데이터베이스에 저장하는 메소드
def save_ollama_description(user_id, recipe_id, description):
    if not user_id or not description:
        return
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            sql_deactivate = "UPDATE chat_description SET is_active = FALSE WHERE user_id = %s AND recipe_id = %s AND is_active = TRUE"
            cursor.execute(sql_deactivate, (user_id, recipe_id))
            sql = "INSERT INTO chat_description (user_id, recipe_id, ollama_description, time) VALUES (%s, %s, %s, NOW())"
            cursor.execute(sql, (user_id, recipe_id, description))
            conn.commit()
    except Exception as e:
        print(f"DB Error: {e}")
        conn.rollback()
    finally:
        conn.close()


# 사용자의 선호 식재료, 불호 식재료, 선호 음식, 현재 냉장고에 있는 식재료를 조회하는 메소드
def get_user_preferences(user_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            # 좋아하는 식재료
            cursor.execute(
                "SELECT ingredient FROM user_LD1 WHERE user_no = %s AND preference = '1'",
                [user_id],
            )
            liked_ingredients = [row["ingredient"] for row in cursor.fetchall()]

            # 싫어하는 식재료
            cursor.execute(
                "SELECT ingredient FROM user_LD1 WHERE user_no = %s AND preference = '0'",
                [user_id],
            )
            disliked_ingredients = [row["ingredient"] for row in cursor.fetchall()]

            # 좋아하는 음식
            cursor.execute(
                "SELECT food FROM user_LD2 WHERE user_no = %s AND preference = '1'",
                [user_id],
            )
            liked_foods = [row["food"] for row in cursor.fetchall()]

            # 냉장고 식재료
            cursor.execute(
                "SELECT ingredient FROM user_refrigerator WHERE user_no = %s AND used_code = '0'",
                [user_id],
            )
            fridge_ingredients = [row["ingredient"] for row in cursor.fetchall()]

            return {
                "liked_ingredients": liked_ingredients,
                "disliked_ingredients": disliked_ingredients,
                "liked_foods": liked_foods,
                "fridge_ingredients": fridge_ingredients,
            }
    finally:
        conn.close()


# 사용자의 냉장고 테이블에서 used_code가 0인 식재료의 used_code를 1로 업데이트하는 메소드
def update_used_ingredients(user_no, ingredients):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            if not ingredients:
                return
            placeholders = ",".join(["%s"] * len(ingredients))
            sql_update = f"UPDATE user_refrigerator SET used_code = 1 WHERE user_no = %s AND ingredient IN ({placeholders}) AND used_code = 0"
            params = [user_no] + ingredients
            print(f"SQL Update: user_no={user_no}, ingredients={ingredients}")
            cursor.execute(sql_update, params)
            conn.commit()
    except Exception as e:
        conn.rollback()
        print(f"DB Update Error: {e}")
    finally:
        conn.close()


#  session_id를 생성하는 메소드
def create_chat_session_if_not_exists(session_id: str, user_no: str = None):
    """chat_sessions 테이블에 해당 session_id가 없으면 새로 생성.
    ON DUPLICATE KEY UPDATE를 사용하여 이미 존재하면 아무 작업도 하지 않습니다.
    """

    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            # user_no가 있으면 user_no, 없으면 null을 삽입
            sql = """
                INSERT INTO chat_sessions (session_id, user_no, created_at)
                VALUES (%s, %s, NOW())
                ON DUPLICATE KEY UPDATE session_id = session_id;
            """
            cursor.execute(sql, (session_id, user_no))
            conn.commit()
            print(f"### 세션 ID '{session_id}' 확인 또는 생성 완료.")
    except Exception as e:
        conn.rollback()
        print(f"### 채팅 세션 생성 중 DB 오류 발생: {e}")
    finally:
        conn.close()


# 사용자의 채팅 메시지를 데이터베이스에 저장하는 메소드
def save_chat_message(session_id, sender, content, recipe_id=None):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            sql = """
                INSERT INTO chat_messages (session_id, sender, content, timestamp, recipe_id)
                VALUES (%s, %s, %s, NOW(), %s)
            """
            cursor.execute(sql, (session_id, sender, content, recipe_id))
            conn.commit()
    except Exception as e:
        conn.rollback()
        print(f"DB Error: {e}")
    finally:
        conn.close()


# 사용자의 채팅 기록을 조회하는 메소드
def get_chat_history(session_id, user_no=None, limit: int = 10):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            # 최신 대화 N개를 가져오기 위해 DESC 정렬 후 LIMIT 적용
            sql = """
                SELECT message_id, sender, content, timestamp, recipe_id 
                FROM chat_messages 
                WHERE session_id = %s 
                ORDER BY timestamp DESC
                LIMIT %s
            """
            cursor.execute(sql, (session_id, limit))

            # messages = cursor.fetchall() 로 하면 message가 튜플이 되어서 아래의 messages.reverse() 코드 에러 -> list로 변환
            messages = list(cursor.fetchall())

            # 시간 순서대로 재정렬 (오래된 대화 -> 최신 대화)
            messages.reverse()
            return messages if messages else []
    finally:
        conn.close()


# 사용자의 레시피 이력을 저장하는 메소드
def save_user_recipe_history(user_no, recipe_data, selected_ingredients):

    if not user_no or not recipe_data:
        print("### 사용자 번호 또는 레시피 데이터가 없어서 이력을 저장할 수 없습니다.")
        return

    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            sql = """
                INSERT INTO user_recipe (user_no, food, recipe_id, rec_date, ingredient, calorie)
                values (%s, %s, %s, NOW(), %s, %s)
                """

            ingredient_str = ", ".join(selected_ingredients)
            params = (
                user_no,
                recipe_data.get("name"),
                recipe_data.get("recipe_id"),
                ingredient_str,
                recipe_data.get("calories"),
            )

            cursor.execute(sql, params)
            conn.commit()
            print(
                f"### 사용자 {user_no}의 레시피 이력 저장 완료! 레시피 id : {recipe_data.get('recipe_id')} 저장 완료"
            )

    except Exception as e:
        conn.rollback()
        print(f"### 사용자 레시피 이력 저장 중 오류 발생: {e}")
    finally:
        conn.close()


# 사용자의 레시피 이력을 조회하는 메소드
def get_user_recipe_history(user_no):

    if not user_no:
        return []

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            sql = """
                SELECT index_no, user_no, food, recipe_id, rec_date, ingredient, calorie
                FROM user_recipe
                WHERE user_no = %s
                ORDER BY rec_date DESC
            """
            cursor.execute(sql, (user_no,))
            history_list = cursor.fetchall()

            print(
                f"### 사용자 {user_no}의 레시피 이력 조회 완료: {len(history_list)}개 조회 완료."
            )
            return history_list

    except Exception as e:
        print(f"### 사용자 레시피 이력 조회 중 오류 발생: {e}")
        return []
    finally:
        conn.close()


# 사용자의 레시피 이력에서 선택한 항목을 삭제하는 메소드
def delete_user_recipe_history(user_no, index_no) -> int:
    """사용자의 특정 레시피 이력을 삭제"""

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            sql = "DELETE FROM user_recipe WHERE user_no = %s AND index_no = %s"

            result = cursor.execute(sql, (user_no, index_no))
            conn.commit()

            print(
                f"### 회원번호 {user_no}의 레시피 이력(index: {index_no}) 삭제 완료. {result}행 삭제됨"
            )
            return result
    except Exception as e:
        print(f"### 레시피 이력 삭제 중 DB 오류 발생: {e}")
        conn.rollback()
        return 0
    finally:
        conn.close()
