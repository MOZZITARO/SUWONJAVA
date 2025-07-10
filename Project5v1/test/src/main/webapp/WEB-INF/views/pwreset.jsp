<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FridgeAI - 비밀번호 재설정</title>
</head>
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background: #fafafa;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px 20px;
    color: #2c3e50;
}

/* 로고 및 브랜드 */
.brand-logo {
    text-align: center;
    margin-bottom: 48px;
}

.logo-icon {
    width: 60px;
    height: 60px;
    background: #27ae60;
    border-radius: 16px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 16px;
    box-shadow: 0 4px 20px rgba(39, 174, 96, 0.15);
}

.logo-icon::after {
    content: '🔐';
    font-size: 28px;
}

.brand-name {
    font-size: 1.8rem;
    font-weight: 700;
    color: #2c3e50;
    letter-spacing: -0.5px;
    margin-bottom: 8px;
}

.brand-subtitle {
    font-size: 0.95rem;
    color: #7f8c8d;
    font-weight: 400;
}

/* 전체 박스 */
.reset-container {
    background: white;
    border-radius: 24px;
    padding: 48px;
    width: 100%;
    max-width: 440px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(0, 0, 0, 0.04);
    text-align: center;
}

/* 비밀번호 재설정 제목 */
.title {
    font-size: 2rem;
    font-weight: 600;
    text-align: center;
    margin-bottom: 40px;
    color: #2c3e50;
    letter-spacing: -0.5px;
}

/* 성공 메시지 */
.success-message {
    background: #f0f9f4;
    border: 1.5px solid #27ae60;
    border-radius: 16px;
    padding: 20px;
    margin-bottom: 32px;
    color: #1e7e34;
    font-weight: 500;
    text-align: center;
    font-size: 0.9rem;
    display: none;
    line-height: 1.5;
}

/* 에러 메시지 스타일 추가 */
.error-message {
    background: #ffebee;
    border: 1.5px solid #ef5350;
    border-radius: 16px;
    padding: 20px;
    margin-bottom: 32px;
    color: #c62828;
    font-weight: 500;
    text-align: center;
    font-size: 0.9rem;
    line-height: 1.5;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

/* 폼 전체 설정 */
.form-group {
    margin-bottom: 32px;
    position: relative;
    text-align: left;
}

/* "이메일 주소" 라벨 */
.form-label {
    display: block;
    margin-bottom: 12px;
    font-weight: 500;
    color: #34495e;
    font-size: 0.95rem;
}

/* 이메일 주소 입력창 */
.form-input {
    width: 100%;
    padding: 16px 20px;
    border: 1.5px solid #e8ecef;
    border-radius: 12px;
    font-size: 16px;
    background: #fafbfc;
    transition: all 0.2s ease;
    font-family: inherit;
}

.form-input:focus {
    outline: none;
    border-color: #27ae60;
    background: white;
    box-shadow: 0 0 0 3px rgba(39, 174, 96, 0.1);
}

.form-input:hover:not(:focus) {
    border-color: #d5dbdb;
    background: white;
}

/* 가입해주신 ~ 안내 텍스트 */
.info-text {
    color: #7f8c8d;
    font-size: 0.9rem;
    line-height: 1.6;
    margin-bottom: 32px;
    text-align: center;
    font-weight: 400;
}

/* 확인버튼 */
.reset-btn {
    width: 100%;
    padding: 18px;
    background: #2c3e50;
    color: white;
    border: none;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
    margin-bottom: 32px;
    font-family: inherit;
}

.reset-btn:hover {
    background: #34495e;
    transform: translateY(-1px);
    box-shadow: 0 4px 16px rgba(44, 62, 80, 0.2);
}

.reset-btn:active {
    transform: translateY(0);
}

/* 로그인으로 돌아가기 */
.back-to-login {
    text-align: center;
}

.back-to-login a {
    color: #7f8c8d;
    text-decoration: none;
    font-size: 0.9rem;
    font-weight: 500;
    transition: all 0.2s ease;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.back-to-login a:hover {
    color: #27ae60;
    transform: translateX(-2px);
}

.back-to-login a::before {
   
    font-size: 14px;
    transition: transform 0.2s ease;
}

.back-to-login a:hover::before {
    transform: translateX(-2px);
}

/* 반응형 */
@media (max-width: 480px) {
    body {
        padding: 20px 16px;
    }
    
    .reset-container {
        padding: 32px 24px;
        border-radius: 20px;
    }
    
    .brand-name {
        font-size: 1.6rem;
    }
    
    .title {
        font-size: 1.75rem;
        margin-bottom: 32px;
    }
    
    .form-group {
        margin-bottom: 28px;
    }
    
    .form-input {
        padding: 14px 16px;
    }
    
    .reset-btn {
        padding: 16px;
        margin-bottom: 28px;
    }
    
    .info-text {
        font-size: 0.85rem;
        margin-bottom: 28px;
    }
}

/* 애니메이션 */
@keyframes slideDown {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.success-message, .error-message {
    animation: slideDown 0.3s ease-out;
}
</style>
<body>

    <div class="reset-container">
        <div class="brand-logo">
            <div class="logo-icon"></div>
            <h1 class="brand-name">FridgeAI</h1>
            <p class="brand-subtitle">새로운 비밀번호를 설정하여 계정을 안전하게 보호하세요</p>
        </div>

        <h2 class="title">비밀번호 재설정</h2>
        
        <!-- 성공 메시지 표시 (성공했을 때만 표시) -->
        <c:if test="${not empty message}">
            <div class="success-message" style="display: block;">
                ✅ ${message}
            </div>
        </c:if>

        <!-- 에러 메시지 표시 (에러가 있을 때만 표시) -->
        <c:if test="${not empty error}">
            <div class="error-message">
                ❌ ${error}
            </div>
        </c:if>
        
        <div class="success-message" id="successMessage">
            📧 비밀번호 재설정 메일이 발송되었습니다!<br>
            이메일을 확인해 주세요.
        </div>
        
         <form id="resetForm" action="send-verification" method="post">
            <div class="form-group">
                <label class="form-label" for="email">이메일 주소</label>
                <input type="email" id="email" name="email" class="form-input" placeholder="example@naver.com" autocomplete="off" required>
            </div>
            
            <p class="info-text">
                가입하신 이메일 주소를 입력해 주시면<br>
                비밀번호 재설정 메일이 발송됩니다.
            </p>
            
            <button type="submit" class="reset-btn">확인</button>
        </form>
        
        <div class="back-to-login">
            <a href="#" onclick="goBackToLogin()">
                로그인으로 돌아가기
            </a>
        </div>
    </div>

    <script>
        function goBackToLogin() {
            // 로그인 페이지로 이동 로직
            window.history.back();
        }
    </script>
</body>
</html>