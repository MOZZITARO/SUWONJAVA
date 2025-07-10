<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>레시피 상세 - 식재료 분석 및 요리 레시피</title>
    
    <!-- ⭐ 1단계: 웹 폰트(Pretendard) 불러오기 ⭐ -->
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, sans-serif; /* 새 폰트 적용 */
            background-color: #f0f4f8 !important;
            padding: 20px;
            margin: 0;
            font-size: 15px; /* 전체 기본 글씨 크기를 15px로 살짝 줄임 (기존 16px 기준) */
            line-height: 1.7; /* 줄 간격을 조금 더 넓혀 가독성 확보 */
            color: #333; /* 기본 글자색 */
            -webkit-font-smoothing: antialiased; /* 폰트를 더 부드럽게 */
            -moz-osx-font-smoothing: grayscale;
        }

        .container {
            max-width: 1200px;
            margin-bottom: 5px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            
        }

        .header {
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            padding: 20px;
            text-align: center;
            margin-bottom: 50px;
        }

        .header h1 {
            font-size: 24px;
            font-weight: bold;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin: 0;
        }

        .search-icon {
            font-size: 22px;
            
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }

        .content {
            display: flex;
            padding: 30px;
            gap: 20px;
            min-height: 500px;
            background-color: transparent !important;
            background: none !important;
            
        }

        .left-panel {
           padding: 50px;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .image-container {
        
            width: 100%;
            height: 400px;
            background: #f8f9fa;
            border-radius: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #6c757d;
            font-size: 16px;
            border: 2px dashed #dee2e6;
        }

        .image-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 10px;
        }

        .right-panel {
        
            flex: 2;
            overflow-y: auto;
            max-height: 500px;
            padding: 50px;
            border-left: 1px solid #dee2e6;
        }

        /* 레시피 제목 */
        .recipe-title {
            font-size: 26px; /* 28px -> 26px */
            font-weight: 700; /* 굵은 글씨체 (bold보다 더 굵게) */
            margin-bottom: 20px;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .recipe-section {
            margin-bottom: 30px;
        }

        /* '재료', '만드는 법' 등 섹션 제목 */
        .section-title {
            font-size: 18px; /* 20px -> 18px */
            font-weight: 600; /* 보통(normal)과 굵게(bold)의 중간 */
            color: #27ae60;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .ingredients-box {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #27ae60;
        }

        /* 재료 목록 텍스트 */
        .ingredients-list {
            line-height: 1.8; /* 재료 목록은 줄 간격을 좀 더 넓게 */
            color: #444; /* 너무 진하지 않은 색으로 */
            font-size: 15px;
        }

        .cooking-steps {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }

        .cooking-steps ol {
            padding-left: 20px;
            list-style: none; /* 기본 숫자 리스트 스타일 제거 */
    		counter-reset: step-counter; /* CSS 카운터 초기화 */
        }

        /* 만드는 법 설명 텍스트 */
        .cooking-steps li {
            display: flex; /* li 요소를 flex 컨테이너로 만듦 */
		    align-items: flex-start; /* 아이템들을 위쪽 기준으로 정렬 */
		    gap: 12px; /* 번호와 내용 사이의 간격 */
		    
		    margin-bottom: 24px; /* 각 단계 사이의 간격을 조금 더 넓게 */
		    line-height: 1.7;
		    color: #333;
		    font-size: 16px;
        }
        
        /* CSS 카운터를 사용하여 직접 숫자 생성 및 스타일링 */
		.cooking-steps li::before {
		    counter-increment: step-counter; /* 카운터 1씩 증가 */
		    content: counter(step-counter) "."; /* "1.", "2." ... 형태로 내용 생성 */
		    
		    /* 숫자 스타일 */
		    font-weight: 700; /* 굵게 */
		    font-size: 18px;
		    color: #667eea; /* 포인트 컬러 */
		    min-width: 25px; /* 번호가 차지할 최소 너비 확보 */
		    text-align: right; /* 오른쪽 정렬 (선택사항) */
		    padding-top: 1px; /* 텍스트와 미세한 수직 정렬 맞춤 */
		}
		
		/* li 안의 내용물이 담길 컨테이너 (선택사항이지만 권장) */
		.cooking-steps li .step-content {
		    flex: 1; /* 남은 공간을 모두 차지하도록 함 */
		    
		    /* Flexbox 방향을 세로로 변경 */
		    display: flex;
		    flex-direction: column; /* 자식 요소(이미지, 텍스트)를 위아래로 쌓음 */
		    gap: 8px; /* 이미지와 텍스트 사이의 수직 간격 */
		}

        .back-button {
            /* 기존 스타일 초기화 */
		    display: inline-flex; /* 아이콘과 텍스트 정렬을 위해 flex 사용 */
		    align-items: center;
		    gap: 8px; /* 아이콘과 텍스트 사이 간격 */
		    
		    /* 새로운 스타일 */
		    background-color: #f1f5f9; /* 밝은 회색 배경 */
		    color: #475569; /* 부드러운 텍스트 색상 */
		    border: 1px solid #e2e8f0; /* 얇은 테두리 */
		    padding: 10px 18px; /* 패딩 조정 */
		    border-radius: 20px; /* 둥근 모서리 */
		    font-size: 15px;
		    font-weight: 600; /* 약간 굵게 */
		    text-decoration: none;
		    cursor: pointer;
		    transition: all 0.2s ease-in-out;
        }

        .back-button:hover {
            background-color: #e2e8f0; /* 호버 시 배경색 변경 */
		    color: #1e293b; /* 호버 시 텍스트 색상 진하게 */
		    box-shadow: 0 2px 8px rgba(0,0,0,0.05); /* 부드러운 그림자 효과 */
		    transform: translateY(-1px); /* 살짝 떠오르는 효과 */
        }
        
        /* 아이콘 스타일 (선택사항: SVG 아이콘 사용 시) */
		.back-button svg {
		    width: 18px;
		    height: 18px;
		    stroke-width: 2.5;
		}

        .error {
            color: red;
            text-align: center;
            padding: 20px;
        }

        .recipe-image {
            max-width: 100%;
            border-radius: 8px;
            margin-bottom: 15px;
        }

       .tip-section {
		    background-color: #f8f9fa !important;  /* 배경색 덮어쓰기 */
		    color: #2c3e50 !important;             /* 텍스트 색상 덮어쓰기 */
		    padding: 20px !important;              /* 패딩 추가 */
		    border-radius: 10px !important;        /* 모서리 둥글게 */
		    margin-top: 15px !important;           /* 마진 조정 */
		    border: 1px solid #dee2e6 !important;  /* 테두리 추가 */
		    display: block !important;             /* display 속성 덮어쓰기 */
		    height: auto !important;               /* 높이 자동 조정 */
		    justify-content: initial !important;   /* flex 속성 초기화 */
		    align-items: initial !important;       /* flex 속성 초기화 */
		}

		/* 요리 팁 텍스트 */
        .tip-section p {
            margin: 0 !important;
            line-height: 1.7 !important;
            font-size: 15px !important; /* 1rem -> 15px */
            color: #2c3e50 !important;
        }
        
        ul	{
  		 list-style:none;
   			}
   			
   		.image-container {
            width: 100%;
            padding-top: 75%; /* 4:3 비율 (세로/가로) */
            position: relative; /* 자식 요소의 기준점 */
            background: #f8f9fa;
            border-radius: 12px;
            overflow: hidden; /* 컨테이너를 벗어나는 이미지 숨기기 */
            border: 1px solid #dee2e6;
        }

        .image-container img {
            position: absolute; /* 컨테이너 기준으로 위치 지정 */
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover; /* 이미지가 컨테이너를 꽉 채우도록, 비율은 유지 */
        }

        .no-image-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #6c757d;
            font-size: 16px;
        }
        
        /* ⭐ 스피너 스타일 추가 ⭐ */
        .spinner-container {
            text-align: center;
            padding: 40px 20px;
            color: #667eea;
        }

        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 15px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<!-- <body> 태그 어딘가, 스크립트가 사용하기 편한 곳에 추가 -->
<div id="recipeData" 
     data-manuals='${fn:escapeXml(manualsJson)}' 
     data-tip='${fn:escapeXml(recipe.tip)}' 
     data-instructions='${fn:escapeXml(instructionsJson)}'
     style="display: none;">
</div>
<div class="container">
    <div class="header">
        <h1>
            <span class="search-icon">🍳</span>
            식재료 분석 및 요리 레시피
        </h1>
    </div>
    
    <c:if test="${not empty error}">
        <div class="error">
            <h2>${error}</h2>
        </div>
    </c:if>

    <c:if test="${not empty recipe}">
        <div class="content">
            <div class="left-panel">
                <div class="image-container">
                    <c:choose>
				        <%-- ⭐⭐⭐ 큰 이미지를 위해 'image_thumbnail_url'을 사용 ⭐⭐⭐ --%>
				        <c:when test="${not empty recipe.image_main_url}">
				            <img src="${recipe.image_main_url}" alt="${recipe.name}" />
				        </c:when>
				        <c:otherwise>
				            <span class="no-image-text">이미지 없음</span>
				        </c:otherwise>
    				</c:choose>
                </div>
            </div>
            
            <div class="right-panel">
                <div class="recipe-title">
                    🥢 ${recipe.name}
                </div>

                <div class="recipe-section">
                    <div class="section-title">
                        📝 재료
                    </div>
                    <div class="ingredients-box">
                        <div class="ingredients-list">
                            <c:forEach var="ing" items="${recipe.ingredients}">
                                • ${ing.name} - ${ing.quantity} ${ing.description}<br>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <div class="recipe-section">
                    <div class="section-title">
                        👩‍🍳 만드는 법 (AI 요리사's Tip ✨)
                    </div>
                    <div class="cooking-steps" id="cookingStepsSection">
                    	<!-- 스피너와 로딩 메시지를 초기에 표시 -->
		                <div class="spinner-container" id="spinnerContainer">
		                    <div class="spinner"></div>
		                    <p>AI 요리사가 설명을 맛있게 다듬고 있어요... 🤖</p>
		                </div>
		                <!-- 실제 조리법이 채워질 리스트 -->
		                <ol id="instructionsList" style="display: none;"></ol>
		                
                        <!-- <ul >
                            <c:forEach var="inst" items="${recipe.instructions}" varStatus="status">
                                 <li>
                    				<%-- instruction 객체에 image_url이 있고 비어있지 않으면 이미지를 표시 --%>
				                    <c:if test="${not empty inst.image_url}">
				                        <img src="${inst.image_url}" alt="조리 이미지 ${status.index + 1}" class="recipe-image" />
				                    </c:if>
				                    <br>
				                    ${inst.description}
                				</li>
                            </c:forEach>
                        </ul> -->
                    </div>
                </div>

                <c:if test="${not empty recipe.tip}">
                    <div class="recipe-section" id="tipSectionContainer">
				        <div class="section-title">
				            💡 요리 팁
				        </div>
				        <!-- ⭐ 팁 섹션에도 스피너 적용 ⭐ -->
				        <div class="tip-section">
				            <div class="spinner-container" id="tipSpinnerContainer">
				                <div class="spinner"></div>
				                <p>AI 요리사가 팁을 맛있게 다듬고 있어요... 🤖</p>
				            </div>
				            <p id="tipContent" style="display: none;"></p>
				        </div>
				    </div>
                </c:if>

                <!-- "뒤로 가기" 버튼 HTML 수정 -->
				<button type="button" onclick="goBack()" class="back-button">
				    <!-- SVG 아이콘 추가 (Heroicons 사용 예시) -->
				    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				      <path stroke-linecap="round" stroke-linejoin="round" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
				    </svg>
				    <span>뒤로 가기</span>
				</button>
            </div>
        </div>
    </c:if>
</div>

<!-- JSP에서 전달받은 레시피에 따라 내용을 동적으로 변경하는 스크립트 -->
<!-- ⭐ 비동기 로딩을 위한 자바스크립트 추가 ⭐ -->
<script>
	//페이지가 완전히 로드된 후 실행
	document.addEventListener('DOMContentLoaded', function() {
	    // JSP에서 전달된 recipe 객체가 있는지 확인
	    <c:if test="${not empty recipe}">
	        // 비동기로 Gemini 설명 가져오기 함수 호출
	        fetchGeneratedInstructions();
	    </c:if>
	});
	
	async function fetchGeneratedInstructions() {
		
		// data- 속성에서 안전하게 JSON 데이터 읽어오기
        const recipeDataElement = document.getElementById('recipeData');
        const instructionsData = JSON.parse(recipeDataElement.dataset.instructions);
        const tip = recipeDataElement.dataset.tip;
		
     	// `instructions` 객체 리스트에서 `description` 텍스트만 추출
        const originalManuals = instructionsData.map(inst => inst.description);
        
	    // 1. FastAPI로 보낼 데이터 준비 (원본 설명 + 팁)
	    const payload = {
            manuals: originalManuals,
            tip: tip
        };
	
	    try {
	        // 2. FastAPI의 새 엔드포인트 호출
	        const response = await fetch('http://localhost:8000/recipes/generate-description', {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/json',
	            },
	            body: JSON.stringify(payload)
	        });
	
	        if (!response.ok) {
	            throw new Error('설명 생성 실패');
	        }
	
	        const data = await response.json();
	        
	        // 3. 성공시, 스피너를 숨기고, 생성된 설명과 팁으로 내용 교체
	        console.log("Gemini가 만든 설명: ", data.generated_instructions)
	        console.log("Gemini가 만든 팁: ", data.generated_tip)
	        updateInstructions(data.generated_instructions, instructionsData);
        	updateTip(data.generated_tip);
	
	    } catch (error) {
	        console.error('Gemini 설명 로딩 오류:', error);
	        // 4. 실패 시, 스피너를 숨기고 원본 설명으로 대체
	        updateInstructions(originalManuals, instructionsData, 'AI 설명 생성에 실패하여 원본을 표시합니다.');
        	updateTip(tip); // 원본 팁 표시
	    }
	}
	
	function updateInstructions(descriptions, originalInstructions, message) {
	    const spinnerContainer = document.getElementById('spinnerContainer');
	    const instructionsList = document.getElementById('instructionsList');
	    const cookingStepsSection = document.getElementById('cookingStepsSection');
	    const recipeDataElement = document.getElementById('recipeData');
        const instructionsData = JSON.parse(recipeDataElement.dataset.instructions);
	    
	    // 기존 내용 비우기
	    instructionsList.innerHTML = '';
	    
	    // 만약 전달된 메시지가 있다면, 상단에 표시
	    if (message) {
	        const notice = document.createElement('p');
	        notice.textContent = message;
	        notice.style.marginBottom = '15px';
	        notice.style.color = '#e74c3c';
	        cookingStepsSection.insertBefore(notice, spinnerContainer);
	    }
	    
	    // 새로운 설명으로 리스트 아이템 채우기
	    descriptions.forEach((desc, index) => {
	        const li = document.createElement('li');
	        
	     	// ⭐ li 안에 내용을 담을 div를 추가합니다.
	        const contentDiv = document.createElement('div');
	        contentDiv.className = 'step-content';
	        
	        const originalInst = originalInstructions[index];
	        // 원본 이미지 URL을 함께 표시 (DB에 instruction.image_url이 있는 경우)
            if (originalInst && originalInst.image_url) {
                const img = document.createElement('img');
                img.src = originalInst.image_url;
                img.alt = `조리 이미지 ${index + 1}`;
                img.className = 'recipe-image';
                contentDiv.appendChild(img); // div 안에 이미지 추가
            }
            contentDiv.appendChild(document.createTextNode(desc)); // div 안에 텍스트 추가
            li.appendChild(contentDiv); // 최종적으로 div를 li에 추가
            
            instructionsList.appendChild(li);
	    });
	    
	    // 스피너 숨기고, 설명 리스트 보이기
	    spinnerContainer.style.display = 'none';
	    instructionsList.style.display = 'block';
	}
	
	// 팁 섹션을 업데이트하는 새로운 함수
	function updateTip(tipText) {
		const tipSectionContainer = document.getElementById('tipSectionContainer');
	    const tipSpinnerContainer = document.getElementById('tipSpinnerContainer');
	    const tipContent = document.getElementById('tipContent');
	    
	    if (tipSectionContainer) {
	        if (tipText) {
	            tipContent.textContent = tipText;
	            tipSpinnerContainer.style.display = 'none';
	            tipContent.style.display = 'block';
	        } else {
	            // 팁 내용이 없으면 팁 섹션 전체를 숨김
	            tipSectionContainer.style.display = 'none';
	        }
	    }
	}
	
	function goBack(){
		// 브라우저의 방문 기록에서 한 단계 뒤로 이동
		console.log("뒤로가기 클릭함!");
		history.back();
	}
</script>
</body>
</html>