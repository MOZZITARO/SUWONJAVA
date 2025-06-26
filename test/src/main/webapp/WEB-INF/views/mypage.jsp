<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset ="UTF-8">
	<title>마이페이지</title>
<<<<<<< HEAD
	<link rel="stylesheet" href="/css/mypage.css">
=======
	<link rel="stylesheet" href="mypageStyle.css">
>>>>>>> e5d7888d09e691826ae7e5d86b2c05dffaa96d93
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>

<div class="container">
	<section class ="account-section">
		<h2>비밀번호 변경</h2>
<<<<<<< HEAD
		<form method="post" action="/changePassword">
			<label>현재 비밀번호 <input type="password" name="currentPassword"></label>		
			<label>새 비밀번호<input type="password" name="newPassword"></label>
	
		<c:if test="${not empty message}">
			<p style="color:red;">${message}</p>
		</c:if>

			
			<div class="btn-group">
				<button type="submit" class="btn change">비밀번호 변경</button>
				<button class="btn cancel" type="reset">탈퇴</button>
=======
		<form method="post" action="changePassword">
			<label>현재 비밀번호 <input type="password" name="currentPassword"></label>		
			<label>새 비밀번호<input type="password" name="newPassword"></label>
			<div class="btn-group">
				<button class="btn change">변경</button>
				<button class="btn cancel" type="reset">취소</button>ㅠ>
>>>>>>> e5d7888d09e691826ae7e5d86b2c05dffaa96d93
			</div>
		</form>
	</section>

	<section class="plus-function">
		<h2>부가 기능</h2>
		<form action="goToHistory" method="get">
			<button class="setting-btn">추천레시피 이력</button>
		</form>
		<form action="preferenceFoods" method="get">
			<button class="setting-btn">호불호 음식 선택</button>
		</form>
		<form action="fridge" method="get">
			<button class="setting-btn">냉장고 채우기</button>
		</form>	
	</section>
</div>
</body>
</html>