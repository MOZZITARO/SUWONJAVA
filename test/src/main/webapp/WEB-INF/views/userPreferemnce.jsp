<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원별 선호도 페이지</title>
</head>
<body>
    <div class="container">
        <div class="flask-area">
            <c:out value="${flaskContent}" escapeXml="false" />
        </div>
    </div>
</body>
</html>