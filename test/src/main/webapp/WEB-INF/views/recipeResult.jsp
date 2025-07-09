<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
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

        .error {
            color: red;
            text-align: center;
            padding: 20px;
        }

        .recipe-image {
            max-width: 100%;
            border-radius: 8px;
            margin-bottom: 15px;
        }

       .tip-section {
    background-color: #f8f9fa !important;  /* 배경색 덮어쓰기 */
    color: #2c3e50 !important;             /* 텍스트 색상 덮어쓰기 */
    padding: 20px !important;              /* 패딩 추가 */
    border-radius: 10px !important;        /* 모서리 둥글게 */
    margin-top: 15px !important;           /* 마진 조정 */
    border: 1px solid #dee2e6 !important;  /* 테두리 추가 */
    display: block !important;             /* display 속성 덮어쓰기 */
    height: auto !important;               /* 높이 자동 조정 */
    justify-content: initial !important;   /* flex 속성 초기화 */
    align-items: initial !important;       /* flex 속성 초기화 */
}

.tip-section p {
    margin: 0 !important;
    line-height: 1.6 !important;
    font-size: 1rem !important;
    color: #2c3e50 !important;
}
        
        ul	{
  		 list-style:none;
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
    
    <c:if test="${not empty error}">
        <div class="error">
            <h2>${error}</h2>
        </div>
    </c:if>

    <c:if test="${not empty recipe}">
        <div class="content">
            <div class="left-panel">
                <div class="image-container">
                    <c:if test="${not empty recipe.image_main_url}">
                        <img src="${recipe.image_main_url}" alt="${recipe.name}" />
                    </c:if>
                    <c:if test="${empty recipe.image_main_url}">
                        이미지 없음
                    </c:if>
                </div>
            </div>
            
            <div class="right-panel">
                <div class="recipe-title">
                    🥢 ${recipe.name}
                </div>

                <div class="recipe-section">
                    <div class="section-title">
                        📝 재료
                    </div>
                    <div class="ingredients-box">
                        <div class="ingredients-list">
                            <c:forEach var="ing" items="${recipe.ingredients}">
                                • ${ing.name} - ${ing.quantity} ${ing.description}<br>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <%
                List<String> alEast = Arrays.asList(
                    "http://www.foodsafetykorea.go.kr/uploadimg/cook/20_00028_1.png",
                    "http://www.foodsafetykorea.go.kr/uploadimg/cook/20_00028_2.png",
                    "http://www.foodsafetykorea.go.kr/uploadimg/cook/20_00028_3.png"
                );
                request.setAttribute("stepImages", alEast);
                %>

                <div class="recipe-section">
                    <div class="section-title">
                        👩‍🍳 만드는 법 (AI 요리사's Tip ✨)
                    </div>
                    <div class="cooking-steps">
                        <ul >
                            <c:forEach var="inst" items="${recipe.instructions}" varStatus="status">
                                <li list-style: none;>
                                    <c:if test="${not empty stepImages[status.index]}">
                                        <img src="${stepImages[status.index]}" alt="조리 이미지 ${status.index}" class="recipe-image" />
                                    </c:if><br>
                                    ${inst.description}
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

                <c:if test="${not empty recipe.tip}">
                    <div class="recipe-section">
                        <div class="section-title">
                            💡 요리 팁
                        </div>
                        <div class="tip-section">
                            <p>${recipe.tip}</p>
                        </div>
                    </div>
                </c:if>

                <a href="/Main" class="back-button">← 뒤로 가기</a>
            </div>
        </div>
    </c:if>
</div>

<!-- JSP에서 전달받은 레시피에 따라 내용을 동적으로 변경하는 스크립트 -->
<script>
// 실제 JSP 구현시에는 서버에서 전달받은 recipe 파라미터에 따라
// 다른 레시피 정보를 표시하도록 구현할 수 있습니다.
// 예: ${param.recipe} 값에 따라 조건부 렌더링
</script>
</body>
</html>