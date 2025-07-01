<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>냉장고 요리사 - AI 레시피 챗봇</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;
            background: #ffffff;
            min-height: 100vh;
            background-color: #f6f6f6;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
           
            max-width: 1400px; /* 900px에서 1080px로 20% 증가 */
            background: #ffffff;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            padding: 48px; /* 40px에서 48px로 20% 증가 */
            animation: slideUp 0.6s ease-out;
            border: 1px solid #e2e8f0;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .header1 {
            text-align: center;
            margin-bottom: 48px; /* 40px에서 48px로 20% 증가 */
        }

        .logo {
            width: 96px; /* 80px에서 96px로 20% 증가 */
            height: 96px;
            background: #667eea;
            border-radius: 24px; /* 20px에서 24px로 20% 증가 */
            margin: 0 auto 24px; /* 20px에서 24px로 20% 증가 */
            display: flex;
            align-items: center;
            justify-content: center;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .logo svg {
            width: 48px; /* 40px에서 48px로 20% 증가 */
            height: 48px;
            stroke: white;
            stroke-width: 2;
        }

        h1 {
            color: #667eea;
            font-size: 3rem; /* 2.5rem에서 3rem로 20% 증가 */
            font-weight: 700;
            margin-bottom: 12px; /* 10px에서 12px로 20% 증가 */
        }

        .subtitle {
            color: #718096;
            font-size: 1.32rem; /* 1.1rem에서 1.32rem로 20% 증가 */
            margin-bottom: 24px; /* 20px에서 24px로 20% 증가 */
        }

        .auth-buttons {
            display: flex;
            gap: 14.4px; /* 12px에서 14.4px로 20% 증가 */
            justify-content: center;
            margin-bottom: 36px; /* 30px에서 36px로 20% 증가 */
        }

        .auth-btn {
            padding: 9.6px 19.2px; /* 8px 16px에서 9.6px 19.2px로 20% 증가 */
            border: 2px solid #e2e8f0;
            background: white;
            border-radius: 24px; /* 20px에서 24px로 20% 증가 */
            font-size: 1.08rem; /* 0.9rem에서 1.08rem로 20% 증가 */
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .auth-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .auth-btn:not(.active):hover {
            border-color: #667eea;
            transform: translateY(-2px);
        }

        .feature-cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr); /* 3개를 나란히 배치 */
            gap: 24px; /* 20px에서 24px로 20% 증가 */
            margin-bottom: 48px; /* 40px에서 48px로 20% 증가 */
        }

        .feature-card {
            background: white;
            border-radius: 19.2px; /* 16px에서 19.2px로 20% 증가 */
            padding: 28.8px; /* 24px에서 28.8px로 20% 증가 */
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid #f1f5f9;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }

        .feature-icon {
            width: 57.6px; /* 48px에서 57.6px로 20% 증가 */
            height: 57.6px;
            background: #27ae60;
            border-radius: 14.4px; /* 12px에서 14.4px로 20% 증가 */
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 19.2px; /* 16px에서 19.2px로 20% 증가 */
        }

        .feature-icon svg {
            width: 28.8px; /* 24px에서 28.8px로 20% 증가 */
            height: 28.8px;
            stroke: white;
            stroke-width: 2;
        }

        .feature-card h3 {
            color: #2d3748;
            font-size: 1.44rem; /* 1.2rem에서 1.44rem로 20% 증가 */
            font-weight: 600;
            margin-bottom: 9.6px; /* 8px에서 9.6px로 20% 증가 */
        }

        .feature-card p {
            color: #718096;
            line-height: 1.5;
            font-size: 1.14rem; /* 0.95rem에서 1.14rem로 20% 증가 */
        }

        .chat-container {
            background: white;
            border-radius: 19.2px; /* 16px에서 19.2px로 20% 증가 */
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid #f1f5f9;
            overflow: hidden;
        }

        .chat-header {
            background: #667eea;
            color: white;
            padding: 24px; /* 20px에서 24px로 20% 증가 */
            display: flex;
            align-items: center;
            gap: 14.4px; /* 12px에서 14.4px로 20% 증가 */
        }

        .chat-status {
            width: 9.6px; /* 8px에서 9.6px로 20% 증가 */
            height: 9.6px;
            background: #48bb78;
            border-radius: 50%;
            animation: blink 2s infinite;
        }

        @keyframes blink {
            0%, 50% { opacity: 1; }
            51%, 100% { opacity: 0.3; }
        }

        .chat-messages {
            height: 360px; /* 300px에서 360px로 20% 증가 */
            padding: 24px; /* 20px에서 24px로 20% 증가 */
            overflow-y: auto;
            background: #fafafa;
        }

        .message {
            display: flex;
            margin-bottom: 19.2px; /* 16px에서 19.2px로 20% 증가 */
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .message.bot {
            justify-content: flex-start;
        }

        .message.user {
            justify-content: flex-end;
        }

        .message-bubble {
            max-width: 70%;
            padding: 14.4px 19.2px; /* 12px 16px에서 14.4px 19.2px로 20% 증가 */
            border-radius: 21.6px; /* 18px에서 21.6px로 20% 증가 */
            font-size: 1.14rem; /* 0.95rem에서 1.14rem로 20% 증가 */
            line-height: 1.4;
        }

        .message.bot .message-bubble {
            background: white;
            color: #2d3748;
            border: 1px solid #e2e8f0;
        }

        .message.user .message-bubble {
            background: #667eea;
            color: white;
        }

        .chat-input-container {
            padding: 24px; /* 20px에서 24px로 20% 증가 */
            background: white;
            border-top: 1px solid #e2e8f0;
        }

        .chat-input-wrapper {
            display: flex;
            gap: 14.4px; /* 12px에서 14.4px로 20% 증가 */
            align-items: center;
        }

        .chat-input {
            flex: 1;
            padding: 14.4px 19.2px; /* 12px 16px에서 14.4px 19.2px로 20% 증가 */
            border: 2px solid #e2e8f0;
            border-radius: 24px; /* 20px에서 24px로 20% 증가 */
            font-size: 1.14rem; /* 0.95rem에서 1.14rem로 20% 증가 */
            outline: none;
            transition: all 0.3s ease;
        }

        .chat-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .send-btn {
            width: 52.8px; /* 44px에서 52.8px로 20% 증가 */
            height: 52.8px;
            background: #667eea;
            border: none;
            border-radius: 26.4px; /* 22px에서 26.4px로 20% 증가 */
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .send-btn:hover {
            background: #5a67d8;
            transform: scale(1.05);
        }

        .send-btn svg {
            width: 24px; /* 20px에서 24px로 20% 증가 */
            height: 24px;
            stroke: white;
            stroke-width: 2;
        }

        .quick-suggestions {
            display: flex;
            gap: 9.6px; /* 8px에서 9.6px로 20% 증가 */
            flex-wrap: wrap;
            margin-top: 14.4px; /* 12px에서 14.4px로 20% 증가 */
        }

        .suggestion-chip {
            padding: 7.2px 14.4px; /* 6px 12px에서 7.2px 14.4px로 20% 증가 */
            background: #f7fafc;
            border: 1px solid #e2e8f0;
            border-radius: 19.2px; /* 16px에서 19.2px로 20% 증가 */
            font-size: 1.02rem; /* 0.85rem에서 1.02rem로 20% 증가 */
            color: #4a5568;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .suggestion-chip:hover {
            background: #667eea;
            color: white;
            transform: translateY(-1px);
        }

        @media (max-width: 1200px) {
            .feature-cards {
                grid-template-columns: 1fr;
                gap: 20px;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 28.8px; /* 24px에서 28.8px로 20% 증가 */
                margin: 12px; /* 10px에서 12px로 20% 증가 */
            }

            h1 {
                font-size: 2.4rem; /* 2rem에서 2.4rem로 20% 증가 */
            }

            .feature-cards {
                grid-template-columns: 1fr;
            }

            .auth-buttons {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header1">
           <!--  <div class="logo">
                <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5"/>
                </svg>
            </div> -->
            <h1>🧊 냉장고 요리사</h1>
            <p class="subtitle">AI가 당신의 냉장고 재료로 완벽한 레시피를 추천해드려요</p>
            
           <!--  <div class="auth-buttons">
                <button class="auth-btn active" onclick="switchAuth('guest')">
                    <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" style="display: inline; margin-right: 6px;">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                    </svg>
                    비회원으로 시작
                </button>
                <button class="auth-btn" onclick="switchAuth('member')">
                    <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" style="display: inline; margin-right: 6px;">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    회원 로그인
                </button>
            </div> -->
        </div>

        <div class="feature-cards" id="featureCards">
            <div class="feature-card">
                <div class="feature-icon">
                    <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10 11.25h4M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z"/>
                    </svg>
                </div>
                <h3>냉장고 재료 입력</h3>
                <p>집에 있는 재료만 말씀해주세요. 신선한 재료부터 냉동식품까지 모두 활용해드려요.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">
                    <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25"/>
                    </svg>
                </div>
                <h3>맞춤 레시피 생성</h3>
                <p>AI가 당신의 재료와 취향을 분석해서 최적의 레시피를 실시간으로 만들어드려요.</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">
                    <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0014.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"/>
                    </svg>
                </div>
                <h3>취향 저장 (회원)</h3>
                <p>선호하는 음식 스타일, 알레르기 정보 등을 저장해서 더욱 정확한 추천을 받아보세요.</p>
            </div>
        </div>

        <div class="chat-container">
            <div class="chat-header">
                <div class="chat-status"></div>
                <span>요리사 AI와 대화중</span>
            </div>
            
            <div class="chat-messages" id="chatMessages">
                <div class="message bot">
                    <div class="message-bubble">
                        안녕하세요! 냉장고 요리사입니다 🍳<br>
                        냉장고에 어떤 재료들이 있는지 알려주시면, 맛있는 레시피를 추천해드릴게요!
                    </div>
                </div>
            </div>
            
            <div class="chat-input-container">
                <div class="chat-input-wrapper">
                    <input 
                        type="text" 
                        class="chat-input" 
                        placeholder="예: 양파, 당근, 닭가슴살이 있어요"
                        id="chatInput"
                    >
                    <button class="send-btn" onclick="sendMessage()">
                        <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/>
                        </svg>
                    </button>
                </div>
                
                <div class="quick-suggestions">
                    <div class="suggestion-chip" onclick="quickSend('계란, 파, 김치')">계란, 파, 김치</div>
                    <div class="suggestion-chip" onclick="quickSend('닭가슴살, 양파, 당근')">닭가슴살, 양파, 당근</div>
                    <div class="suggestion-chip" onclick="quickSend('토마토, 양파, 마늘')">토마토, 양파, 마늘</div>
                    <div class="suggestion-chip" onclick="quickSend('감자, 양파, 베이컨')">감자, 양파, 베이컨</div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentAuth = 'guest';
        
        function switchAuth(authType) {
            currentAuth = authType;
            const buttons = document.querySelectorAll('.auth-btn');
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            updateFeatureCards();
            updateChatPlaceholder();
        }
        
        function updateFeatureCards() {
            const featureCards = document.getElementById('featureCards');
            if (currentAuth === 'member') {
                featureCards.style.transform = 'scale(1.02)';
                setTimeout(() => {
                    featureCards.style.transform = 'scale(1)';
                }, 200);
            }
        }
        
        function updateChatPlaceholder() {
            const input = document.getElementById('chatInput');
            if (currentAuth === 'member') {
                input.placeholder = "예: 매운 음식으로 만족스러운 저녁 만들어줘";
            } else {
                input.placeholder = "예: 양파, 당근, 닭가슴살이 있어요";
            }
        }
        
        function sendMessage() {
            const input = document.getElementById('chatInput');
            const message = input.value.trim();
            if (!message) return;
            
            addMessage(message, 'user');
            input.value = '';
            
            // 시뮬레이션된 AI 응답
            setTimeout(() => {
                let response;
                if (currentAuth === 'member') {
                    response = "취향을 고려해서 완벽한 레시피를 찾고 있어요... 🔍<br><br>당신의 선호도와 저장된 정보를 바탕으로 맞춤 레시피를 준비해드릴게요!";
                } else {
                    response = "좋은 재료들이네요! 🥕<br><br>이 재료들로 만들 수 있는 몇 가지 레시피를 찾고 있어요. 잠시만 기다려주세요...";
                }
                addMessage(response, 'bot');
            }, 1000);
        }
        
        function quickSend(message) {
            document.getElementById('chatInput').value = message;
            sendMessage();
        }
        
        function addMessage(text, sender) {
            const messagesContainer = document.getElementById('chatMessages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${sender}`;
            
            const bubbleDiv = document.createElement('div');
            bubbleDiv.className = 'message-bubble';
            bubbleDiv.innerHTML = text;
            
            messageDiv.appendChild(bubbleDiv);
            messagesContainer.appendChild(messageDiv);
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }
        
        // Enter 키로 메시지 전송
        document.getElementById('chatInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });
    </script>
</body>
</html>