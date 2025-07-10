<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>



<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>식재료 분석 및 요리 레시피</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Malgun Gothic', sans-serif;
            background-color: #f0f4f8 !important;
            padding: 20px;
            margin: 0;
        }

        .container {
            max-width: 1200px;
            margin: auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            border-radius: 10px 10px 10px 10px;
            margin-top: 50px;
        }

        .header {
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            padding: 20px;
            text-align: center;
            border-radius: 10px 10px 10px 10px;
        }

        .header h1 {
            font-size: 24px;
            font-weight: bold;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin: 0;
        }

        .search-icon {
            font-size: 22px;
            
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }

        .content {
            display: flex;
            padding: 30px;
            gap: 20px;
            min-height: 500px;
            background-color: transparent !important;
            background: none !important;
        }

        .left-panel {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .image-container {
            width: 100%;
            height: 300px;
            background: #f8f9fa;
            border-radius: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #6c757d;
            font-size: 16px;
            border: 2px dashed #dee2e6;
        }

        .image-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 10px;
        }

        .image-path {
            background: #e9ecef;
            padding: 10px;
            border-radius: 6px;
            font-size: 12px;
            color: #495057;
            word-break: break-all;
        }

        .right-panel {
            flex: 2;
            overflow-y: auto;
            max-height: 500px;
            padding-left: 20px;
            border-left: 1px solid #dee2e6;
        }

        .ingredient-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #2c3e50;
        }

        .recipe-list button {
            display: block;
            width: 100%;
            padding: 12px;
            margin-bottom: 10px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            text-align: left;
        }

        .recipe-list button:hover {
            background-color: #2980b9;
        }

        .recipe-detail {
            margin-top: 20px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 5px solid #3498db;
        }

        .recipe-detail p {
            color: #333;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>
            <span class="search-icon">🍳</span>
            식재료 분석 및 요리 레시피
        </h1>
    </div>
    
    <div class="content">
        <div class="left-panel">
            <div class="image-container">
                <img src="/mnt/data/0630.PNG" alt="Onion" />
            </div>
        </div>
        
        <div class="right-panel">
            <div class="ingredient-title">식재료: 양파 (흰 양파)</div>

            <div class="recipe-list">
                <form action="Reciperesult" method="post">
                    <button type="submit" name="recipe" value="양파 장아찌">🥢 요리 1: 양파 장아찌</button>
                    <button type="submit" name="recipe" value="양파 스프">🍲 요리 2: 양파 스프</button>
                    <button type="submit" name="recipe" value="양파 볶음">🍳 요리 3: 양파 볶음</button>
                </form>
            </div>

            
        </div>
    </div>
</div>
</body>
</html>