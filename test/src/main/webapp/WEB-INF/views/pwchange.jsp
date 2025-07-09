<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 재설정 - FridgeAI</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            padding: 60px 50px;
            width: 100%;
            max-width: 480px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #2c3e50, #27ae60);
        }

        .logo {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 40px;
            font-size: 24px;
            font-weight: 700;
            color: #2c3e50;
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }

        .title {
            font-size: 32px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 12px;
            line-height: 1.2;
        }

        .subtitle {
            font-size: 16px;
            color: #7f8c8d;
            margin-bottom: 50px;
            line-height: 1.5;
        }

        .form-group {
            margin-bottom: 32px;
            text-align: left;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
        }

        .form-input {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #ecf0f1;
            border-radius: 12px;
            font-size: 16px;
            background: #fafbfc;
            transition: all 0.3s ease;
            outline: none;
        }

        .form-input:focus {
            border-color: #27ae60;
            background: white;
            box-shadow: 0 0 0 4px rgba(39, 174, 96, 0.1);
        }

        .password-requirements {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            margin-top: 20px;
            text-align: left;
        }

        .requirement-title {
            font-size: 14px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 12px;
        }

        .requirement-list {
            list-style: none;
        }

        .requirement-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #7f8c8d;
            margin-bottom: 6px;
        }

        .requirement-item.valid {
            color: #27ae60;
        }

        .requirement-check {
            width: 16px;
            height: 16px;
            border-radius: 50%;
            border: 2px solid #bdc3c7;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            transition: all 0.3s ease;
        }

        .requirement-item.valid .requirement-check {
            background: #27ae60;
            border-color: #27ae60;
            color: white;
        }

        .submit-btn {
            width: 100%;
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 18px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(44, 62, 80, 0.3);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .submit-btn:disabled {
            background: #bdc3c7;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .back-link {
            color: #7f8c8d;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #27ae60;
        }

        .success-message {
            background: linear-gradient(135deg, #d5f4e6, #e8f8f5);
            border: 1px solid #27ae60;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            color: #1e7e34;
            font-size: 14px;
            display: none;
        }

        @media (max-width: 768px) {
            .container {
                padding: 40px 30px;
                margin: 20px;
            }
            
            .title {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">
            <div class="logo-icon">🥗</div>
            FridgeAI
        </div>


  <!-- 성공 메시지 표시 (성공했을 때만 표시) -->
<c:if test="${not empty message}">
    <div class="success-message" style="background-color: #e8f5e8; color: #2e7d32; padding: 10px; margin: 10px 0; border-radius: 5px; border: 1px solid #4caf50;">
        ✅ ${message}
    </div>
</c:if>

<!-- 에러 메시지 표시 (에러가 있을 때만 표시) -->
<c:if test="${not empty error}">
    <div class="error-message" style="background-color: #ffebee; color: #c62828; padding: 10px; margin: 10px 0; border-radius: 5px; border: 1px solid #ef5350;">
        ❌ ${error}
    </div>
</c:if>
        

        
<!-- 디버깅용 - 나중에 제거 -->
    <!-- <div style="background: yellow; padding: 10px; margin: 10px;">
        <strong>디버깅 정보:</strong><br>
        토큰 값: [${token}]<br>
        토큰 존재 여부: ${not empty token ? '존재' : '없음'}
    </div> -->

        <h1 class="title">비밀번호 재설정</h1>
        <p class="subtitle">새로운 비밀번호를 설정하여 계정을 안전하게 보호하세요</p>

        <!-- <div class="success-message" id="successMessage">
            ✅ 비밀번호가 성공적으로 변경되었습니다!
        </div> -->

        <form id="resetForm" action="changeok" method="post">
       <!-- ${token}  -->
         <input type="hidden" name="token" value="${token}">
           <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /> 
            <div class="form-group">
                <label for="newPassword" class="form-label">새 비밀번호</label>
                <input 
                    type="password" 
                    id="newPassword" 
                    class="form-input" 
                    placeholder="새 비밀번호를 입력하세요"
                    name="newpw"
                    required
                >
            </div>

            <div class="form-group">
                <label for="confirmPassword" class="form-label">비밀번호 확인</label>
                <input 
                    type="password" 
                    id="confirmPassword" 
                    class="form-input" 
                    placeholder="비밀번호를 다시 입력하세요"
                    name="conpw"
                    required
                >
            </div>

            <!-- <div class="password-requirements">
                <div class="requirement-title">비밀번호 요구사항</div>
                <ul class="requirement-list">
                    <li class="requirement-item" id="req-length">
                        <span class="requirement-check"></span>
                        8자 이상
                    </li>
                    <li class="requirement-item" id="req-uppercase">
                        <span class="requirement-check"></span>
                        대문자 포함
                    </li>
                    <li class="requirement-item" id="req-lowercase">
                        <span class="requirement-check"></span>
                        소문자 포함
                    </li>
                    <li class="requirement-item" id="req-number">
                        <span class="requirement-check"></span>
                        숫자 포함
                    </li>
                    <li class="requirement-item" id="req-special">
                        <span class="requirement-check"></span>
                        특수문자 포함
                    </li>
                    <li class="requirement-item" id="req-match">
                        <span class="requirement-check"></span>
                        비밀번호 일치
                    </li>
                </ul>
            </div> -->

            <button type="submit" class="submit-btn" id="submitBtn">
                비밀번호 변경하기
            </button>
        </form>

        <a href="loginmain" class="back-link">로그인 페이지로 돌아가기</a>
    </div>

    <script>
    document.getElementById('resetForm').addEventListener('submit', function(e) {
        console.log('=== 폼 제출 시작 ===');
        
        const formData = new FormData(this);
        console.log('폼 데이터:');
        for (let [key, value] of formData.entries()) {
            console.log(key + ': ' + value);
        }
        
        console.log('Action URL:', this.action);
        console.log('Method:', this.method);
    });    
        // 잠깐 제출을 막고 확인 (테스트 후 이 줄 제거)
        // e.preventDefault();
        // alert('폼 제출 확인 - 콘솔을 확인하세요');
    
      /*   const newPasswordInput = document.getElementById('newPassword');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const submitBtn = document.getElementById('submitBtn');
        const form = document.getElementById('resetForm');
        const successMessage = document.getElementById('successMessage');

        const requirements = {
            length: /^.{8,}$/,
            uppercase: /[A-Z]/,
            lowercase: /[a-z]/,
            number: /\d/,
            special: /[!@#$%^&*(),.?":{}|<>]/
        };

        function validatePassword() {
            const password = newPasswordInput.value;
            const confirmPassword = confirmPasswordInput.value;
            let allValid = true;

            // Check each requirement
            Object.keys(requirements).forEach(req => {
                const element = document.getElementById(`req-${req}`);
                const isValid = requirements[req].test(password);
                
                if (isValid) {
                    element.classList.add('valid');
                    element.querySelector('.requirement-check').textContent = '✓';
                } else {
                    element.classList.remove('valid');
                    element.querySelector('.requirement-check').textContent = '';
                    allValid = false;
                }
            });

            // Check password match
            const matchElement = document.getElementById('req-match');
            const isMatch = password && confirmPassword && password === confirmPassword;
            
            if (isMatch) {
                matchElement.classList.add('valid');
                matchElement.querySelector('.requirement-check').textContent = '✓';
            } else {
                matchElement.classList.remove('valid');
                matchElement.querySelector('.requirement-check').textContent = '';
                allValid = false;
            }

            // Enable/disable submit button
            submitBtn.disabled = !allValid || !isMatch;
        }

        newPasswordInput.addEventListener('input', validatePassword);
        confirmPasswordInput.addEventListener('input', validatePassword);

        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Simulate password reset
            submitBtn.textContent = '처리 중...';
            submitBtn.disabled = true;
            
            setTimeout(() => {
                successMessage.style.display = 'block';
                form.style.display = 'none';
                
                setTimeout(() => {
                    // Redirect to login page
                    window.location.href = '#login';
                }, 2000);
            }, 1500);
        });

        // Add floating animation to container
        const container = document.querySelector('.container');
        let mouseX = 0;
        let mouseY = 0;
        let containerX = 0;
        let containerY = 0;

        document.addEventListener('mousemove', (e) => {
            mouseX = (e.clientX - window.innerWidth / 2) * 0.01;
            mouseY = (e.clientY - window.innerHeight / 2) * 0.01;
        });

        function animate() {
            containerX += (mouseX - containerX) * 0.1;
            containerY += (mouseY - containerY) * 0.1;
            
            container.style.transform = `translate(${containerX}px, ${containerY}px)`;
            requestAnimationFrame(animate);
        }

        animate(); */
    </script>
</body>
</html>
