<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>요리 이미지 생성</title>
  <style>
    body {
    font-family: 'Noto Sans KR', sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f5f5f5;
  }

  .title {
    text-align: center;
    font-size: 36px;
    font-weight: bold;
    margin-top: 40px;
  }

  .container {
    display: flex;
    justify-content: center;
    gap: 60px;
    padding: 20px 40px;  /* 상하 여백을 줄였습니다 */
    max-width: 1400px;
    margin: auto;
    margin-top: 25px;
  }

  .left-section, .right-section {
    background-color: white;
    padding: 30px;       /* 전체 패딩 소폭 줄였습니다 */
    border-radius: 20px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
    width: 45%;
    margin-top: 10px;    /* 위 여백 추가 */
    margin-bottom: 20px; /* 아래 여백 추가 */
  }

    #recipe-image {
      width: 100%;
      height: 260px;
      background-color: #ddd;
      border-radius: 12px;
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #666;
      font-size: 18px;
    }

    .category {
      background-color: #333;
      color: white;
      display: inline-block;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 14px;
      margin-bottom: 10px;
    }

    .recipe-name {
      font-size: 28px;
      font-weight: bold;
      margin: 10px 0;
    }

    .description {
      color: #555;
      margin-bottom: 20px;
    }

    .section-title {
      font-size: 22px;
      font-weight: bold;
      border-bottom: 2px solid #ccc;
      margin: 25px 0 15px;
      padding-bottom: 5px;
    }

    .ingredients {
      width: 100%;
      border-collapse: collapse;
    }

    .ingredients td {
      padding: 10px 5px;
      border-bottom: 1px solid #eee;
    }

    .step {
      background-color: #eaf4ff;
      border-left: 6px solid #3498db;
      padding: 15px;
      margin-bottom: 20px;
      border-radius: 8px;
    }

    .step h4 {
      margin: 0 0 8px;
      font-size: 16px;
      color: #2c3e50;
    }

    .tip-box {
      background: #27ae60;
      color: white;
      padding: 20px;
      border-radius: 10px;
      font-size: 15px;
    }

    .tip-box h4 {
      margin-top: 0;
      font-size: 16px;
    }

    .tip-box ul {
      padding-left: 20px;
      margin: 10px 0 0 0;
    }

    .tip-box li {
      margin-bottom: 6px;
    }
  </style>
</head>
<body>

  

  <div class="container">
    <!-- 좌측 섹션 -->
    <div class="left-section">
      <div id="recipe-image">[ 레시피 이미지 영역 ]</div>

     
      <div class="recipe-name">김치볶음밥</div>
      <div class="description">집에서 쉽게 만드는 한국의 대표 볶음밥. 신김치의 깊은 맛이 일품!</div>

      <div class="section-title">🥬 재료</div>
      <table class="ingredients">
        <tr><td>진밥</td><td>2공기</td></tr>
        <tr><td>신김치</td><td>1/2컵</td></tr>
        <tr><td>계란</td><td>2개</td></tr>
        <tr><td>대파</td><td>1/2대</td></tr>
        <tr><td>식용유</td><td>2큰술</td></tr>
        <tr><td>참기름</td><td>1작은술</td></tr>
        <tr><td>김</td><td>적당량</td></tr>
      </table>
    </div>

    <!-- 우측 섹션 -->
    <div class="right-section">
      <div class="section-title">🔍 조리 과정</div>

      <div class="step">
        <h4>1. 재료 준비하기</h4>
        <p>신김치는 국물을 짜고 적당한 크기로 썰어주세요. 대파는 송송 썰고, 계란은 고루 풀어 놓습니다.</p>
      </div>

      <div class="step">
        <h4>2. 김치 볶기</h4>
        <p>팬에 식용유를 두르고 중불에서 김치를 먼저 볶아주세요. 김치에서 고소한 향이 날 때까지 2~3분 볶아요.</p>
      </div>

      <div class="step">
        <h4>3. 밥 넣고 볶기</h4>
        <p>김치가 잘 볶아졌으면 밥을 넣고 잘 섞어가며 볶아주세요. 김치와 밥이 잘 어우러지도록 볶습니다.</p>
      </div>

      <div class="step">
        <h4>4. 계란 볶고 마무리</h4>
        <p>볶음밥을 한쪽으로 밀고, 팬 가장자리에 계란을 풀어 스크램블 만든 후 볶음밥과 섞어 주세요. 대파와 참기름 넣고 마무리합니다.</p>
      </div>

      <div class="section-title">💡 요리 팁</div>
      <div class="tip-box">
        <h4>요리 팁</h4>
        <ul>
          <li>김치는 사용하기 전에 볶아서 고소하게 만들어주세요</li>
          <li>김치국물이 너무 많으면 질척하니 적당히 조절하세요</li>
          <li>햄이나 소시지를 추가하면 더 맛있습니다</li>
        </ul>
      </div>
    </div>
  </div>

</body>
</html>
