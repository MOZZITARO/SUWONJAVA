<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background: #f8f9fa;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
}

/* 메인 컨테이너 */
.sign-container {
    background: white;
    border-radius: 24px;
    padding: 48px;
    width: 100%;
    max-width: 440px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(0, 0, 0, 0.04);
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

.logo-section {
    text-align: center;
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 2px solid #f1f3f4;
}

.logo {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 15px;
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

.logo-text {
    font-size: 1.2rem;
    font-weight: 600;
    color: #1f2937;
}

.title {
    font-size: 1.5rem;
    font-weight: 600;
    text-align: center;
    color: #1f2937;
   
}

.subtitle {
    font-size: 0.9rem;
    color: #6b7280;
    text-align: center;
    font-weight: 400;
}

.form-group {
    margin-bottom: 20px;
}

.form-label {
    display: block;
    margin-bottom: 8px;
    font-weight: 500;
    color: #374151;
    font-size: 0.9rem;
}

.form-input {
    width: 100%;
    padding: 12px 16px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    font-size: 15px;
    background: #ffffff;
    transition: all 0.2s ease;
}

.form-input:focus {
    outline: none;
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-input::placeholder {
    color: #9ca3af;
}

.agreement-section {
    margin-bottom: 25px;
    padding: 20px;
    background: #f9fafb;
    border-radius: 8px;
    border: 1px solid #e5e7eb;
}

.form-agree-container {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    margin-bottom: 15px;
}

.form-agree {
    margin-top: 3px;
    width: 16px;
    height: 16px;
    accent-color: #2c3e50;
}

.agree-text {
    color: #374151;
    font-weight: 500;
    font-size: 0.9rem;
    line-height: 1.4;
}

#content {
    width: 100%;
    height: 80px;
    padding: 12px;
    border: 1px solid #d1d5db;
    border-radius: 6px;
    resize: none;
    font-family: inherit;
    font-size: 0.85rem;
    color: #6b7280;
    background: #ffffff;
    line-height: 1.4;
}

.signup-btn {
    width: 100%;
    padding: 14px;
    background: #2c3e50;
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 15px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
    margin-bottom: 20px;
    opacity: 0.6;
}

.signup-btn:not(:disabled) {
    background: #3b82f6;
    opacity: 1;
}

.signup-btn:not(:disabled):hover {
    background: #2563eb;
}

.signup-btn.loading {
    pointer-events: none;
    background: #9ca3af;
}

.divider {
    position: relative;
    text-align: center;
    margin: 25px 0;
}

.divider::before {
    content: '';
    position: absolute;
    top: 50%;
    left: 0;
    right: 0;
    height: 1px;
    background: #e5e7eb;
}

.divider-text {
    background: white;
    padding: 0 16px;
    color: #6b7280;
    font-size: 0.9rem;
    font-weight: 400;
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

.loginmain a{

text-decoration-line: none;


}

.loginmain h3:hover {
    color: #27ae60;
}

/* 반응형 */
@media (max-width: 480px) {
    .signup-container {
        padding: 30px 20px;
        margin: 10px;
    }
    
    .title {
        font-size: 1.3rem;
    }
}
</style>
<body>

        <div class="sign-container">
        <div class="brand-logo">
            <div class="logo-icon"></div>
            <h1 class="brand-name">FridgeAI</h1>         
        </div>
        
        <h1 class="title">회원가입</h1>
        
        
        <form id="signupForm" action="joinprocess" method="post">
            <div class="form-group">
                <label class="form-label" for="name">이름</label>
                <input type="text" id="name" name="user_name" class="form-input" placeholder="이름을 입력하세요" required>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="email">이메일</label>
                <input type="email" id="email" name="user_id" class="form-input" placeholder="이메일을 입력하세요" required>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="password">비밀번호</label>
                <input type="password" id="password" name="user_pw" class="form-input" placeholder="비밀번호를 입력하세요" autocomplete="new-password" required>
            </div>
            
            <div class="agreement-section">
                <div class="form-agree-container">
                    <input type="checkbox" class="form-agree" id="agree" required>
                    <label for="agree" class="agree-text">개인정보 수집 및 이용동의 (필수)</label>
                </div>           	
                
                <textarea id="content" readonly>여러분을 환영합니다.

본 서비스 이용을 위해 다음과 같은 개인정보를 수집합니다:
- 이름: 서비스 이용자 식별 및 고객 지원
- 이메일: 로그인 인증 및 중요 공지사항 전달
- 비밀번호: 계정 보안 및 본인 인증

수집된 개인정보는 서비스 제공 목적으로만 사용되며, 관련 법령에 따라 안전하게 보관됩니다.</textarea>
            </div>
            
            <button type="submit" class="signup-btn">회원가입</button>
        
        <div class="divider">
            <span class="divider-text">또는</span>
        </div>
        
        <div class="oauth-section">
            <div class="loginmain">
            <a href="loginmain"><h3>일반 로그인</h3></a>
            </div>
           <!--  <h3>소셜 계정으로 로그인하기</h3> -->
           <button type="button" class="oauth-btn kakao-btn" onclick="location.href='/oauth2/authorization/kakao'">
    		<div class="oauth-icon kakao-icon">K</div>
             카카오로 로그인
           </button>
            
          <!--   <button type="button" class="oauth-btn naver-btn">
                <div class="oauth-icon naver-icon">N</div>
                네이버로 로그인
            </button>  -->          
        </div>
        
    </div>
    
    <script>
    // 폼 유효성 검사 및 상호작용
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('form');
        const agreeCheckbox = document.getElementById('agree');
        const signupBtn = document.querySelector('.signup-btn');
        
        // 개인정보 동의 체크박스 상태에 따른 버튼 활성화
        function updateSignupButton() {
            if (agreeCheckbox.checked) {
                signupBtn.style.opacity = '1';
                signupBtn.style.background = '#2c3e50';
                signupBtn.disabled = false;
            } else {
                signupBtn.style.opacity = '0.6';
                signupBtn.style.background = '#9ca3af';
                signupBtn.disabled = true;
            }
        }

        agreeCheckbox.addEventListener('change', updateSignupButton);
        updateSignupButton(); // 초기 상태 설정
    });
    </script>
</body>
</html>