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
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #d946ef 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        
        /* 전체 박스 */
         .reset-container {
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
            text-align: center;
        }
        
          .reset-container:hover {
            transform: translateY(-8px);
            box-shadow: 0 35px 70px rgba(0, 0, 0, 0.2);
        }

        /* 비밀번호 재설정 */
        .title {
            font-size: 2.2rem;
            font-weight: 800;
            text-align: center;
            margin-bottom: 40px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6, #d946ef);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            position: relative;
        }

        .title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 3px;
            background: linear-gradient(135deg, #6366f1, #d946ef);
            border-radius: 2px;
        }
        
        /* 폼 전체 설정 */
          .form-group {
            margin-bottom: 32px;
            position: relative;
            text-align: left;
        }

         /* "이메일 주소" */
        .form-label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #374151;
            font-size: 0.95rem;
            transition: color 0.3s ease;
        }
        
        /* 이메일 주소 입력창 */
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

        .form-input:focus {
            outline: none;
            border-color: #6366f1;
            background: white;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
            transform: translateY(-2px);
        }

        .form-input:hover:not(:focus) {
            border-color: #d1d5db;
            background: #f9fafb;
        }
        
        /* 가입해주신 ~ */
          .info-text {
            color: #6b7280;
            font-size: 0.88rem;
            line-height: 1.6;
            margin-bottom: 32px;
            text-align: center;
            font-weight: 500;
        }
        
        /* 확인버튼 */
            .reset-btn {
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
            margin-bottom: 32px;
            position: relative;
            overflow: hidden;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .reset-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.25), transparent);
            transition: left 0.6s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .reset-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(99, 102, 241, 0.4);
            background: linear-gradient(135deg, #5b5ff9, #8b5cf6, #d946ef);
        }

        .reset-btn:hover::before {
            left: 100%;
        }
        
        /* 로그인으로 돌아가기 */
         .back-to-login {
            text-align: center;
        }

        .back-to-login a {
            color: #6366f1;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .back-to-login a:hover {
            color: #4f46e5;
            text-decoration: underline;
            transform: translateX(-3px);
        }
        
         /* 성공 메시지 */
        .success-message {
            background: #f0fdf4;
            border: 2px solid #22c55e;
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 24px;
            color: #059669;
            font-weight: 600;
            text-align: center;
            font-size: 0.9rem;
            display: none;
            animation: slideDown 0.5s ease-out;
        }
        
        /* 반응형 */
        @media (max-width: 480px) {
            .reset-container {
                padding: 36px 24px;
                margin: 10px;
                border-radius: 20px;
            }
            
            .title {
                font-size: 2rem;
                margin-bottom: 32px;
            }

            .form-input {
                padding: 14px 16px;
            }

            .reset-btn {
                padding: 16px;
                font-size: 16px;
            }
        }
        
</style>
<body>
<div class="reset-container">

        <h1 class="title">비밀번호 재설정</h1>
        
        <div class="success-message" id="successMessage">
            📧 비밀번호 재설정 메일이 발송되었습니다!<br>
            이메일을 확인해 주세요.
        </div>
        
        <form id="resetForm">
            <div class="form-group">
                <label class="form-label" for="email">이메일 주소</label>
                <input type="email" id="email" name="email" class="form-input" placeholder="example@naver.com" required>
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
</body>
</html>