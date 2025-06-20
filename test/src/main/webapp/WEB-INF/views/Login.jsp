<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
        /* 공통 */
		* {
		            margin: 0;
		            padding: 0;
		            box-sizing: border-box;
		        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #d946ef 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        /* 공통 */
        
        /* 전체 */
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 24px;
            padding: 48px 40px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
            transform: translateY(0);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            z-index: 1;
        }
        
        /* 제목 */
        .title {
            font-size: 2.5rem;
            font-weight: 800;
            text-align: center;
            margin-bottom: 40px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6, #d946ef);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            position: relative;
        }
        
         /* 제목 자식 요소 : 선 */
     /*   .title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 3px;
            background: linear-gradient(135deg, #6366f1, #d946ef);
            border-radius: 2px;
        } */
        
        /* 로그인 양식 */
        .form-group {
            margin-bottom: 28px;
            position: relative;
        }
        
        /* 로그인 라벨 */
        .form-label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #374151;
            font-size: 0.95rem;
            transition: color 0.3s ease;
        }
        
        /* 로그인 창 */
        .form-input {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e5e7eb;
            border-radius: 16px;
            font-size: 16px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: #fafafa;
            position: relative;
        }
        
        /* 입력창을 포커스(클릭) 했을때 */
        form-input:focus {
            outline: none;
            border-color: #6366f1;
            background: white;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
            transform: translateY(-2px);
        }
        
        /* 입력창을 포커스(클릭) 하지않고 입력창에만 올라갔을때 */
        /* :not :focus >> 포커스와 충돌방지 */
        .form-input:hover:not(:focus) {
		    border-color: #d1d5db;    /* 테두리를 연한 회색으로 변경 */
		    background: #f9fafb;      /* 배경을 아주 연한 회색으로 변경 */
		}
		
		/* 에러났을때 */
		.form-input.error {
		    border-color: #ef4444;    /* 테두리를 빨간색으로 변경 */
		    background: #fef2f2;      /* 배경을 연한 빨간색으로 변경 */
		}
		
		/* 로그인 창 */
		.login-btn {
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white;
            border: none;
            border-radius: 16px;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            margin-bottom: 35px;
            position: relative;
            overflow: hidden;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        
        /* 반짝이는 효과 준비 */
        .login-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.25), transparent);
            transition: left 0.6s cubic-bezier(0.4, 0, 0.2, 1);
        }

         /* 마우스 올렸을 때 효과 */
        .login-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(99, 102, 241, 0.4);
            background: linear-gradient(135deg, #5b5ff9, #8b5cf6, #d946ef);
        }

        /* 반짝이는 효과 실행 */
        .login-btn:hover::before {
            left: 100%;
        }

        .login-btn:active {
            transform: translateY(-1px);
            transition: transform 0.1s ease;  /* 부드러운 전환 */
        }

        .login-btn.loading {
            pointer-events: none;
            background: linear-gradient(135deg, #9ca3af, #6b7280);
        }
        
         /* oauth와 구분선 박스 */
           .divider {
            position: relative;
            text-align: center;
            margin: 35px 0;
        }
        
        /* oauth와 구분선 */
        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, #e5e7eb 20%, #e5e7eb 80%, transparent);
            border-radius: 1px;   
        }
             
        /* 구분선 문구 */
          .divider-text {
            background: rgba(255, 255, 255, 0.95);
            padding: 0 25px;
            color: #6b7280;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
            z-index: 2;
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
        
        
        
        
        
        /* oauth2 박스 : 위치조정 
        .oauth-section {
            text-align: center;
        }
        
           .oauth-title {
            font-size: 1.1rem;
            color: #374151;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
         .google-btn {
            width: 100%;
            padding: 16px;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 16px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            font-size: 16px;
            font-weight: 600;
            color: #374151;
            position: relative;
            overflow: hidden;
        }
        
        /* login - btn과 동일 */
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
            border-color: #4285f4;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(66, 133, 244, 0.15);
            background: #fafbff;
        }

        .google-btn:hover::before {
            left: 100%;
        }
        
         /* 구글 아이콘 */
         .google-icon {
            width: 22px;
            height: 22px;
            background: url('https://img.icons8.com/?size=512&id=17949&format=png') no-repeat center;
            background-size: contain;
        } */
        
        /* 비밀번호를 잊으셨나요 박스*/
         .forgot-password {
            text-align: center;
            margin-top: 20px;
        }

        /* 비밀번호를 잊으셨나요 링크*/
        .forgot-password a {
            color: #6366f1;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        
        .forgot-password a:hover {
            color: #4f46e5;
            text-decoration: underline;
        }
        
            /* 반응형 쿼리 */
            @media (max-width: 480px) {
            body {
                padding: 30px 15px;
            }
            
            .login-container {
                max-width: 400px;
                padding: 40px 30px;
                border-radius: 20px;
            }
            
            .title {
                font-size: 2rem;
                margin-bottom: 30px;
            }
            
            .form-group {
                margin-bottom: 22px;
            }
            
            .form-input {
                padding: 14px 16px;
                font-size: 16px;
                border-radius: 12px;
            }
            
            .login-btn {
                padding: 15px;
                font-size: 16px;
                border-radius: 12px;
                margin-bottom: 30px;
            }
            
            .oauth-btn {
                padding: 13px;
                font-size: 15px;
                gap: 10px;
            }
            
            .divider {
                margin: 30px 0;
            }
            
            .oauth-section h3 {
                font-size: 1rem;
                margin-bottom: 18px;
            }
        }
</style>
<body>
	
	
	<div class="login-container">
        <h1 class="title">로그인</h1>
        
        <form id="loginForm" action="login" method="post">
            <div class="form-group">
                <label class="form-label" for="email">이메일</label>
                <input type="email" id="email" name="user_id" class="form-input" placeholder="이메일을 입력하세요" required>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="password">비밀번호</label>
                <input type="password" id="password" name="user_pw" class="form-input" placeholder="비밀번호를 입력하세요" required>
            </div>
            
            <button type="submit" class="login-btn">로그인</button>
        </form>
        
        <div class="forgot-password">
            <a href="#" onclick="handleForgotPassword()">비밀번호를 잊으셨나요?</a>
        </div>
        
        <div class="divider">
            <span class="divider-text">또는</span>
        </div>
        
         <div class="oauth-section">
        
            <h3>소셜 계정으로 가입하기</h3>
            <button type="button" class="oauth-btn kakao-btn">
                <div class="oauth-icon kakao-icon">K</div>
                카카오로 회원가입
            </button>
        
        
            <button type="button" class="oauth-btn naver-btn">
                <div class="oauth-icon naver-icon">N</div>
                네이버로 회원가입
            </button>
            
        </div>


        
        
    </div>
	
	
	
	
</body>
</html>