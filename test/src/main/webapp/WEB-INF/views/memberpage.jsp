<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="test.controller.User" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이 페이지</title>
<style>
body {
  font-family: 'Noto Sans KR', sans-serif;
  margin: 0;
  padding: 0;
  background-color: #f6f6f6;
}

.container {
  max-width: 840px; /* 기존: 700px → 20% 증가 */
  margin: 60px auto;
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  padding: 36px; /* 기존: 30px → 20% 증가 */
}

.title {
  background-color: #2c3e50;
  color: white;
  padding: 20px;
  border-radius: 12px 12px 0 0;
  font-size: 24px;
  font-weight: bold;
  text-align: center;
}

.section {
  margin-top: 30px;
  border-top: 2px solid #ececec;
  padding-top: 20px;
}

h3 {
  margin-bottom: 15px;
  color: #2c3e50;
}

.form-group {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

/* 비밀번호 폼을 세로로 배치 */
.password-form-group {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-bottom: 20px;
}

input[type="password"] {
  flex: 1;
  padding: 12px; /* 기존: 10px → 20% 증가 */
  border: 1px solid #ccc;
  border-radius: 6px;
}

input[type="password"]:focus {
  outline: none;
  border-color: #2c3e50;
  box-shadow: 0 0 4px rgba(44, 62, 80, 0.4);
}

.button-group {
  display: flex;
  gap: 10px;
}

.btn {
  padding: 12px 24px; /* 기존: 10px 20px → 20% 증가 */
  border: none;
  border-radius: 6px;
  color: white;
  cursor: pointer;
  font-weight: bold;
  text-decoration: none;
  display: inline-block;
  text-align: center;
}

.btn-primary {
  background-color: #2c3e50;
}

.btn-primary:hover {
  background-color: #34495e;
}

.btn-danger {
  background-color: #f66;
}

.btn-danger:hover {
  background-color: #e55;
}

.card-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-top: 15px;
}

.card {
  border: 1px solid #eee;
  padding: 15px;
  border-radius: 8px;
  background-color: #fafafa;
  cursor: pointer;
  transition: background-color 0.3s;
}

.card:hover {
  background-color: #f0f0f0;
}

.card-title {
  font-weight: bold;
  margin-bottom: 5px;
  color: #2c3e50;
}

.card-desc {
  color: #555;
  font-size: 14px;
}

/* 알림 메시지 스타일 */
.alert {
  padding: 12px 16px;
  border-radius: 6px;
  font-size: 14px;
  margin-bottom: 20px;
  border: 1px solid;
}

.alert-success {
  background-color: #d4edda;
  border-color: #c3e6cb;
  color: #155724;
}

.alert-danger {
  background-color: #f8d7da;
  border-color: #f5c6cb;
  color: #721c24;
}

.alert-warning {
  background-color: #fff8e1;
  border-color: #ffe082;
  color: #6c4f00;
}

/* 폼 제목 스타일 */
.form-title {
  font-size: 16px;
  font-weight: bold;
  color: #2c3e50;
  margin-bottom: 10px;
}

</style>
</head>
<body>

<div class="container">
<div class="title">마이 페이지</div>




<% 
                        Object kakaouser = session.getAttribute("kakaoUser"); 
                        Object userObj = session.getAttribute("userInform");
                        if (kakaouser == null) {
                        	%>
                        	
                        	
                        	<div class="section">
<h3>계정</h3>

<!-- 성공/에러 메시지 표시 -->
<c:if test="${not empty success}">
    <div class="alert alert-success">
        ✅ ${success}
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="alert alert-danger">
        ❌ ${error}
    </div>
</c:if>
                        	
<div class="form-title">비밀번호 변경</div>
<form action="/mypage-changePassword" method="post" id="passwordChangeForm">
    <!-- CSRF 토큰 -->
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    
    <div class="password-form-group">
        <input type="password" 
               name="currentPw" 
               placeholder="현재 비밀번호" 
               autocomplete="off"
               required>
        <input type="password" 
               name="newpw" 
               placeholder="새 비밀번호 (8자 이상)" 
               autocomplete="new-password"
               required>
        <input type="password" 
               name="conpw" 
               placeholder="새 비밀번호 확인" 
               autocomplete="new-password"
               required>
    </div>
    
    <div class="button-group">
        <button type="submit" class="btn btn-primary">비밀번호 변경</button>
        <a href="/deletep" class="btn btn-danger">탈퇴 페이지</a>
    </div>
</form>
</div>
                  <%      } %>         





<div class="section">
<h3>취향 설정</h3>
<div class="card-list">

<div class="card" onclick="location.href='/RecommendRecipe'" style="cursor: pointer;">
<div class="card-title">대화 이력보기</div>
<div class="card-desc">이전 레시피 내역을 확인할 수 있습니다</div>
</div>



<div class="card" onclick="location.href='/Prefering'" style="cursor: pointer;">
<div class="card-title">음식재료 추가</div>
<div class="card-desc">선호하는 음식 재료를 추가하고 관리할 수 있습니다</div>
</div>


<div class="card" onclick="window.location.href='http://localhost:5000/inputUserRefrigerator/${sessionScope.user_no}'" style="cursor: pointer;">
${sessionScope.user_no} 세션 유저번호
<div class="card-title">냉장고 채우기</div>
<div class="card-desc">냉장고에 있는 음식을 설정하고 관리할 수 있습니다</div>
</div>
</div>
</div>

</div>

<%
    User user = (User) session.getAttribute("user");
    if (user != null) {
%>
    <p>환영합니다, <%= user.getUserName() %>님!</p>
<%
    }
%>
<script>
// 비밀번호 변경 폼 유효성 검사
document.getElementById('passwordChangeForm').addEventListener('submit', function(e) {
    const currentPw = document.querySelector('input[name="currentPw"]').value.trim();
    const newPw = document.querySelector('input[name="newpw"]').value.trim();
    const conPw = document.querySelector('input[name="conpw"]').value.trim();
    
    // 현재 비밀번호 입력 확인
    if (!currentPw) {
        alert('현재 비밀번호를 입력해주세요.');
        e.preventDefault();
        return false;
    }
    
    // 새 비밀번호 길이 확인
    if (newPw.length < 8) {
        alert('새 비밀번호는 8자 이상이어야 합니다.');
        e.preventDefault();
        return false;
    }
    
    // 새 비밀번호 일치 확인
    if (newPw !== conPw) {
        alert('새 비밀번호가 일치하지 않습니다.');
        e.preventDefault();
        return false;
    }
    
    // 현재 비밀번호와 새 비밀번호 같은지 확인
    if (currentPw === newPw) {
        alert('현재 비밀번호와 다른 새 비밀번호를 입력해주세요.');
        e.preventDefault();
        return false;
    }
    
    // 확인 메시지
    if (!confirm('비밀번호를 변경하시겠습니까?')) {
        e.preventDefault();
        return false;
    }
    
    return true;
});

// 성공 메시지가 있으면 3초 후 자동으로 숨기기
document.addEventListener('DOMContentLoaded', function() {
    const successAlert = document.querySelector('.alert-success');
    if (successAlert) {
        setTimeout(function() {
            successAlert.style.transition = 'opacity 0.5s';
            successAlert.style.opacity = '0';
            setTimeout(function() {
                successAlert.remove();
            }, 500);
        }, 3000);
    }
});
</script>

</body>
</html>