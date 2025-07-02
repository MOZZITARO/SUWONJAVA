<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FridgeAI - 로그인</title>
</head>
<style>
/* 공통 */
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
    content: '🧊';
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

/* 메인 컨테이너 */
.login-container {
    background: white;
    border-radius: 24px;
    padding: 48px;
    width: 100%;
    max-width: 440px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(0, 0, 0, 0.04);
}

/* 제목 */
.title {
    font-size: 2rem;
    font-weight: 600;
    text-align: center;
    margin-bottom: 48px;
    color: #2c3e50;
    letter-spacing: -0.5px;
}

/* 폼 그룹 */
.form-group {
    margin-bottom: 32px;
}

.form-label {
    display: block;
    margin-bottom: 12px;
    font-weight: 500;
    color: #34495e;
    font-size: 0.95rem;
}

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

/* 로그인 버튼 */
.login-btn {
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
    margin-bottom: 40px;
    font-family: inherit;
}

.login-btn:hover {
    background: #34495e;
    transform: translateY(-1px);
    box-shadow: 0 4px 16px rgba(44, 62, 80, 0.2);
}

.login-btn:active {
    transform: translateY(0);
}

/* 비밀번호 찾기 */
.forgot-password {
    text-align: center;
    margin-bottom: 40px;
}

.forgot-password a {
    color: #7f8c8d;
    text-decoration: none;
    font-size: 0.9rem;
    font-weight: 500;
    transition: color 0.2s ease;
}

.forgot-password a:hover {
    color: #27ae60;
}

/* 구분선 */
.divider {
    position: relative;
    text-align: center;
    margin: 40px 0;
}

.divider::before {
    content: '';
    position: absolute;
    top: 50%;
    left: 0;
    right: 0;
    height: 1px;
    background: #e8ecef;
}

.divider-text {
    background: white;
    padding: 0 24px;
    color: #7f8c8d;
    font-size: 0.85rem;
    font-weight: 500;
}

/* 소셜 로그인 섹션 */
.oauth-section h3 {
    text-align: center;
    color: #7f8c8d;
    margin-bottom: 24px;
    font-size: 0.9rem;
    font-weight: 500;
}

.oauth-btn {
    width: 100%;
    padding: 16px 20px;
    border: 1.5px solid #e8ecef;
    border-radius: 12px;
    background: white;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 12px;
    cursor: pointer;
    transition: all 0.2s ease;
    font-size: 15px;
    font-weight: 500;
    margin-bottom: 16px;
    font-family: inherit;
}

.oauth-btn:hover {
    border-color: #d5dbdb;
    transform: translateY(-1px);
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.kakao-btn {
    color: #3c1e1e;
}

.kakao-btn:hover {
    background: #fef7e0;
    border-color: #fee500;
}

.naver-btn {
    color: #2c3e50;
}

.naver-btn:hover {
    background: #f0f9f4;
    border-color: #03c75a;
}

/* 아이콘 */
.oauth-icon {
    width: 24px;
    height: 24px;
    border-radius: 6px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 13px;
}

.kakao-icon {
    background: #fee500;
    color: #3c1e1e;
}

.naver-icon {
    background: #03c75a;
    color: white;
}

/* 반응형 */
@media (max-width: 480px) {
    body {
        padding: 20px 16px;
    }
    
    .login-container {
        padding: 32px 24px;
        border-radius: 20px;
    }
    
    .brand-name {
        font-size: 1.6rem;
    }
    
    .title {
        font-size: 1.75rem;
        margin-bottom: 40px;
    }
    
    .form-group {
        margin-bottom: 28px;
    }
    
    .form-input {
        padding: 14px 16px;
    }
    
    .login-btn {
        padding: 16px;
        margin-bottom: 32px;
    }
    
    .oauth-btn {
        padding: 14px 16px;
        font-size: 14px;
        gap: 10px;
    }
    
    .divider {
        margin: 32px 0;
    }
}
</style>
<body>

       <div class="login-container">
        <div class="brand-logo">
            <div class="logo-icon"></div>
            <h1 class="brand-name">FridgeAI</h1>         
        </div>
        
        <h2 class="title">로그인</h2>
        
        <form id="loginForm" action="/Loginaccess" method="post" autocomplete="off">
            <div class="form-group">
                <label class="form-label" for="email">이메일</label>
                <input type="email" id="email" name="user_id" class="form-input" placeholder="이메일을 입력하세요" autocomplete="off" required>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="password">비밀번호</label>
                <input type="password" id="password" name="user_pw" class="form-input" placeholder="비밀번호를 입력하세요" autocomplete="new-password" required>
            </div>
            
            <button type="submit" class="login-btn">로그인</button>
        </form>
        
        <div id=pwjoin>
        <div class="forgot-password">
            <a href="findpw" onclick="handleForgotPassword()">비밀번호를 잊으셨나요?</a>
        </div>
        <div class="forgot-password">
            <a href="joinmain" onclick="handleForgotPassword()">회원가입</a>
        </div>
        </div>
        
        <div class="divider">
            <span class="divider-text">또는</span>
        </div>
        
        <div class="oauth-section">
            <h3>소셜 계정으로 로그인하기</h3>
           <button type="button" class="oauth-btn kakao-btn" onclick="location.href='/oauth2/authorization/kakao'">
    		<div class="oauth-icon kakao-icon">K</div>
             카카오로 로그인
           </button>
            
            <button type="button" class="oauth-btn naver-btn">
                <div class="oauth-icon naver-icon">N</div>
                네이버로 로그인
            </button>           
        </div>
        
    </div>

    <script>
     
    </script>
</body>
</html>