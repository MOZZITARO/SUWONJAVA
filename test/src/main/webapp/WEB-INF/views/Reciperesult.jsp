<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${recipe.name} - 레시피 상세</title>
    <style>
        /* 상세 페이지를 위한 간단한 CSS */
        body { font-family: sans-serif; padding: 20px; }
        .recipe-container { max-width: 800px; margin: auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .recipe-title { color: #333; }
        .recipe-image { max-width: 100%; border-radius: 8px; margin-bottom: 20px; }
        .section-title { color: #555; border-bottom: 2px solid #eee; padding-bottom: 5px; margin-top: 20px; }
        .ingredients-list, .instructions-list { list-style: none; padding-left: 0; }
        .ingredients-list li, .instructions-list li { margin-bottom: 10px; line-height: 1.6; }
        .error { color: red; }
    </style>
</head>
<body>
    <div class="recipe-container">
        <c:if test="${not empty error}">
            <h2 class="error">${error}</h2>
        </c:if>

        <c:if test="${not empty recipe}">
            <h1 class="recipe-title">${recipe.name}</h1>
            <c:if test="${not empty recipe.image_main_url}">
                <img src="${recipe.image_main_url}" alt="${recipe.name}" class="recipe-image"/>
            </c:if>

            <h2 class="section-title">재료</h2>
            <ul class="ingredients-list">
                <c:forEach var="ing" items="${recipe.ingredients}">
                    <li>${ing.name} - ${ing.quantity} ${ing.description}</li>
                </c:forEach>
            </ul>

            <h2 class="section-title">만드는 법 (AI 요리사's Tip ✨)</h2>
            <ol class="instructions-list">
                <c:forEach var="inst" items="${recipe.instructions}">
                    <li>${inst.description}</li>
                </c:forEach>
            </ol>

            <c:if test="${not empty recipe.tip}">
                <h2 class="section-title">요리 팁</h2>
                <p>${recipe.tip}</p>
            </c:if>
        </c:if>
    </div>
</body>
</html>
 