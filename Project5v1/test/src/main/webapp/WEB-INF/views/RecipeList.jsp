<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>식재료 분석 및 요리 레시피</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            margin: 0;
            background-color: #f0f4f8;
        }
        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }
        .title {
            font-size: 24px;
            font-weight: bold;
            padding: 10px;
            background-color: #2c3e50;
            color: white;
            border-radius: 8px;
            width: 90%;
            text-align: center;
            margin-bottom: 20px;
        }
        .content {
            display: flex;
            width: 90%;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .left-panel {
            width: 40%;
            padding: 20px;
            text-align: center;
            border-right: 1px solid #ccc;
        }
        .left-panel img {
            max-width: 80%;
            max-height: 300px;
            border-radius: 8px;
            background-color: #f7f7f7;
        }
        .right-panel {
            width: 60%;
            padding: 20px;
        }
        .ingredient-name {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .recipe-list {
            margin-bottom: 20px;
        }
        .recipe-list button {
            display: block;
            width: 100%;
            padding: 10px;
            margin-bottom: 5px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-align: left;
            font-size: 16px;
        }
        .recipe-list button:hover {
            background-color: #2980b9;
        }
        .recipe-detail {
            background-color: #ecf0f1;
            padding: 15px;
            border-radius: 6px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="title">🔍 식재료 분석 및 요리 레시피</div>
    <div class="content">
        <!-- 왼쪽 이미지 영역 -->
        <div class="left-panel">
            <img src="${ingredientImagePath}" alt="재료 이미지" />
            <div class="ingredient-name">식재료: 양파</div> <!-- 예시 -->
        </div>

        <!-- 오른쪽 요리 목록 및 상세 영역 -->
        <div class="right-panel">
            <div class="recipe-list">
                <strong>요리 리스트</strong>
                <!-- 실제로는 JSTL로 반복 처리 가능 -->
                <form method="post" action="Reciperesult">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" name="recipeName" value="양파 장아찌">요리 1: 양파 장아찌</button>
                    <button type="submit" name="recipeName" value="양파 스프">요리 2: 양파 스프</button>
                </form>
            </div>

            <div class="recipe-detail">
                <strong>[선택한 요리명]</strong><br/>
                <p>레시피 내용을 여기에 동적으로 출력합니다.</p>
            </div>
        </div>
    </div>
</div>
</body>
</html>