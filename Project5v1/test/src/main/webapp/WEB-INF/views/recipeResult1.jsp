<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>레시피 상세 - 식재료 분석 및 요리 레시피</title>
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
            margin-bottom: 5px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            
        }

        .header {
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            padding: 20px;
            text-align: center;
            margin-bottom: 50px;
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
           padding: 50px;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .image-container {
        
            width: 100%;
            height: 400px;
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

        .right-panel {
        
            flex: 2;
            overflow-y: auto;
            max-height: 500px;
            padding: 50px;
            border-left: 1px solid #dee2e6;
        }

        .recipe-title {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .recipe-section {
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 20px;
            font-weight: bold;
            color: #27ae60;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .ingredients-box {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #27ae60;
        }

        .ingredients-list {
            line-height: 1.6;
            color: #333;
        }

        .cooking-steps {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }

        .cooking-steps ol {
            padding-left: 20px;
        }

        .cooking-steps li {
            margin-bottom: 12px;
            line-height: 1.6;
            color: #333;
        }

        .back-button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            margin-top: 20px;
            font-size: 14px;
        }

        .back-button:hover {
            background-color: #5a6268;
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
                <!-- 실제 구현시에는 선택된 레시피에 따라 이미지가 동적으로 변경됩니다 -->
                <img src="/mnt/data/onion_pickles.jpg" alt="양파 장아찌" />
            </div>
        </div>
        
        <div class="right-panel">
            <div class="recipe-title">
                🥢 양파 장아찌
            </div>

            <div class="recipe-section">
                <div class="section-title">
                    📝 재료
                </div>
                <div class="ingredients-box">
                    <div class="ingredients-list">
                        • 양파 (작은 것) 5개<br>
                        • 간장 1컵<br>
                        • 식초 1컵<br>
                        • 설탕 1/2컵<br>
                        • 물 1컵<br>
                        • 청양고추 (선택사항) 2개<br>
                        • 월계수잎 (선택사항) 2장
                    </div>
                </div>
            </div>

            <div class="recipe-section">
                <div class="section-title">
                    👩‍🍳 조리법
                </div>
                <div class="cooking-steps">
                    <ol>
                        <li>양파는 껍질을 벗기고 깨끗이 씻어 물기를 제거한다. 작은 양파는 통째로 사용하거나, 큰 양파는 4등분으로 자른다.</li>
                        <li>청양고추는 씨를 제거하고 어슷썰기 한다.</li>
                        <li>냄비에 간장, 식초, 설탕, 물, 월계수잎 (선택사항)을 넣고 끓인다. 설탕이 완전히 녹으면 불을 끄고 식힌다.</li>
                        <li>유리병에 양파와 청양고추를 담고 식힌 장아찌 국물을 부어 넣는다.</li>
                        <li>뚜껑을 닫고 실온에서 하루 정도 숙성시킨 후 냉장고에 넣어 3일 이상 숙성시킨다.</li>
                        <li>충분히 숙성된 후 맛있게 드시면 됩니다. 밥반찬이나 술안주로 좋습니다.</li>
                    </ol>
                </div>
            </div>

            <a href="javascript:history.back()" class="back-button">← 뒤로 가기</a>
        </div>
    </div>
</div>

<!-- JSP에서 전달받은 레시피에 따라 내용을 동적으로 변경하는 스크립트 -->
<script>
// 실제 JSP 구현시에는 서버에서 전달받은 recipe 파라미터에 따라
// 다른 레시피 정보를 표시하도록 구현할 수 있습니다.
// 예: ${param.recipe} 값에 따라 조건부 렌더링
</script>
</body>
</html>