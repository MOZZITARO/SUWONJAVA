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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }


  		 .signup-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            transform: translateY(0);
            transition: all 0.3s ease;
        }

        .signup-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
        }
        
        .title {
            font-size: 2rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 30px;
            color: #2d3748;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
            .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #4a5568;
            font-size: 0.9rem;
        }

        .form-input {
            width: 100%;
            padding: 15px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f7fafc;
        }

        .form-input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .form-input:hover {
            border-color: #cbd5e0;
        }
        
        .agreement-section {
            margin-bottom: 25px;
            padding: 20px;
            background: rgba(102, 126, 234, 0.05);
            border-radius: 12px;
            border: 1px solid rgba(102, 126, 234, 0.1);
        }
        
        
        .form-agree-container {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 15px;
        }
        
        
        .form-agree {
            margin-top: 4px;
            transform: scale(1.2);
            accent-color: #667eea;
        }

        .agree-text {
            color: #4a5568;
            font-weight: 600;
            font-size: 0.9rem;
            line-height: 1.4;
        }
                   
          #content {
            width: 100%;
            height: 80px;
            padding: 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            resize: none;
            font-family: inherit;
            font-size: 0.9rem;
            color: #718096;
            background: rgba(255, 255, 255, 0.7);
            line-height: 1.5;
        }
        
            .signup-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        /* 반짝임 효과 */
        .signup-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .signup-btn:hover::before {
            left: 100%;
        }

        .signup-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }
        
         .signup-btn:active {
            transform: translateY(0);
        }
        
          .signup-btn.loading {
            pointer-events: none;
            background: linear-gradient(135deg, #9ca3af, #6b7280);
        }
        
        /* 또는 */
         .divider {
            position: relative;
            text-align: center;
            margin: 30px 0;
        }

        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, #cbd5e0, transparent);
        }
        
        .divider-text {
            background: rgba(255, 255, 255, 0.95);
            padding: 0 20px;
            color: #718096;
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .oauth-section h3 {
           text-align: center;
            color: #4a5568;
            margin-bottom: 20px;
            font-size: 1.1rem;
            font-weight: 600;
        }
        
        /* 외부로그인 버튼 */
         .oauth-btn {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .oauth-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        
        
        
            .kakao-btn {
            background: #FEE500;
            color: #3C1E1E;
        }

        .kakao-btn:hover {
            background: #FDD835;
        }

        .naver-btn {
            background: #03C75A;
            color: white;
        }

        .naver-btn:hover {
            background: #02B351;
        }
        
        /* 아이콘 통합 */
        .oauth-icon {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 12px;
        }
        
          .kakao-icon {
        background: #3C1E1E;
        color: #FEE500;
        }

        .naver-icon {
            background: white;
            color: #03C75A;
        }
        
        
        /* 반응형 */
         @media (max-width: 480px) {
            .signup-container {
                padding: 30px 20px;
                margin: 10px;
            }
            
            .title {
                font-size: 1.7rem;
            }
       }
        
        
     /*    .google-btn {
            width: 100%;
            padding: 15px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            font-size: 16px;
            font-weight: 500;
            color: #2d3748;
        }

		.google-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(66, 133, 244, 0.1), transparent);
            transition: left 0.5s ease;
        }
        

        .google-btn:hover {
            border-color: #cbd5e0;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

		.google-btn:hover::before {
            left: 100%;
        }
        
        .google-icon {
            width: 20px;
            height: 20px;
            background: url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTIyLjU2IDEyLjI1YzAtLjc4LS4wNy0xLjUzLS4yLTIuMjVIMTJ2NC4yNmg1LjkyYy0uMjYgMS4zNy0xLjA0IDIuNTMtMi4yMSAzLjMxdjIuNzFoMy41N2MyLjA4LTEuOTIgMy4yOC00Ljc0IDMuMjgtOC4wM3oiIGZpbGw9IiM0Mjg1RjQiLz4KPHBhdGggZD0iTTEyIDIzYzIuOTcgMCA1LjQ2LS45OCA3LjI4LTIuNjZsLTMuNTctMi43N2MtLjk4LjY2LTIuMjMgMS4wNi0zLjcxIDEuMDYtMi44NiAwLTUuMjktMS45My02LjE2LTQuNTNIMi4xOHYyLjg0QzMuOTkgMjAuNTMgNy43IDIzIDEyIDIzeiIgZmlsbD0iIzM0QTg1MyIvPgo8cGF0aCBkPSJNNS44NCAxNC4wOWMtLjIyLS42Ni0uMzUtMS4zNi0uMzUtMi4wOXMuMTMtMS40My4zNS0yLjA5VjcuMDdIMi4xOEE5Ljk3IDkuOTcgMCAwIDAgMiAxMmMwIDEuNjEuMzkgMy4xNC0xLjA4IDQuOTNsNy44NC0yLjg0eiIgZmlsbD0iI0ZCQkMwNSIvPgo8cGF0aCBkPSJNMTIgNC43NWMxLjYyIDAgMy4wNi41NyA0LjIxIDEuNjdsMy4xNS0zLjE1QzE3LjQ1IDEuMDkgMTQuOTcgMCAxMiAwIDcuNyAwIDMuOTkgMi40NyAyLjE4IDYuMDdsNy42NSAyLjk4Yy44Ny0yLjYgMy4zLTQuNTMgNi4xNy00LjUzeiIgZmlsbD0iI0VBNDMzNSIvPgo8L3N2Zz4K') no-repeat center;
            background-size: contain;
        } */
        
</style>
<body>
 <div class="signup-container">
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
                <input type="password" id="password" name="user_pw" class="form-input" placeholder="비밀번호를 입력하세요" required>
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

수집된 개인정보는 서비스 제공 목적으로만 사용되며, 관련 법령에 따라 안전하게 보관됩니다.
 				</textarea>
                                           	 
            </div>
            
        
            <button type="submit" class="signup-btn">회원가입</button>
        </form>
        
        <div class="divider">
            <span class="divider-text">또는</span>
        </div>
        
        <div class="oauth-section">
        
            <h3>소셜 계정으로 로그인</h3>
            <button type="button" class="oauth-btn kakao-btn">
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
 // 폼 유효성 검사 및 상호작용
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('form');
        const agreeCheckbox = document.getElementById('agree');
        const signupBtn = document.querySelector('.signup-btn');
        const googleBtn = document.querySelector('.google-btn');
        
     // 개인정보 동의 체크박스 상태에 따른 버튼 활성화
        function updateSignupButton() {
            if (agreeCheckbox.checked) {
                signupBtn.style.opacity = '1';
                signupBtn.disabled = false;
            } else {
                signupBtn.style.opacity = '0.6';
                signupBtn.disabled = true;
            }
        }

        agreeCheckbox.addEventListener('change', updateSignupButton);
        updateSignupButton(); // 초기 상태 설정
        
    });
    </script>
</body>
</html>