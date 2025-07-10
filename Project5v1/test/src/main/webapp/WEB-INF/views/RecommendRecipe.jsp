<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>추천레시피 이력 - 냉장고 요리사</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;
            background-color: #f6f6f6;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1000px;
            margin-top: 20px;
            background: #ffffff;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            border: 1px solid #e2e8f0;
            
        }

        .header {
            background: #3498db;
            color: white;
            padding: 32px;
            text-align: center;
            position: relative;
            border-radius: 30px 10px;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="20" cy="20" r="1" fill="white" opacity="0.1"/><circle cx="80" cy="40" r="1" fill="white" opacity="0.1"/><circle cx="40" cy="80" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }

        .header h1 {
            font-size: 2.2rem;
            font-weight: 700;
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .header-icon {
            width: 36px;
            height: 36px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .filter-section {
            background: #f8fafc;
            padding: 24px 32px;
            border-bottom: 1px solid #e2e8f0;
        }

        .filter-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .search-section {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .search-input {
            padding: 10px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 20px;
            font-size: 0.95rem;
            outline: none;
            width: 240px;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .search-btn {
             padding: 8px 16px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 4px;                  
        }

        .search-btn:hover {
            background: #2980b9;
            transform: translateY(-1px);
        }

        .date-filters {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .date-label {
            font-size: 0.9rem;
            color: #4a5568;
            font-weight: 500;
        }

        .date-input {
            padding: 8px 12px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.85rem;
            outline: none;
            transition: all 0.3s ease;
            color: #4a5568;
        }

        .date-input:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.1);
        }

        .date-search-btn {
            padding: 8px 16px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .date-search-btn:hover {
            background: #2980b9;
            transform: translateY(-1px);
        }

        .filter-tags {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .filter-tag {
            padding: 6px 12px;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            font-size: 0.8rem;
            color: #4a5568;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-tag:hover {
            background: #3498db;
            color: white;
            border-color: #3498db;
        }

        .content-section {
            padding: 32px;
        }

        .recipe-item {
            background: white;
            border: 1px solid #f1f5f9;
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 16px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .recipe-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            border-color: #3498db;
        }

        .recipe-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }

        .recipe-date {
            color: #718096;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .recipe-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
        }

        .recipe-calories {
            display: inline-flex;
            align-items: center;
            background: linear-gradient(135deg, #ff6b6b, #ff8e53);
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .recipe-ingredients {
            color: #4a5568;
            font-size: 0.95rem;
            line-height: 1.5;
            margin-bottom: 16px;
        }

        .recipe-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .recipe-tags {
            display: flex;
            gap: 6px;
        }

        .recipe-tag {
            padding: 4px 8px;
            background: #e8f4f8;
            color: #2980b9;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .favorite-btn {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.2rem;
            transition: all 0.3s ease;
            padding: 8px;
            border-radius: 50%;
        }

        .favorite-btn:hover {
            background: #fff5f5;
            transform: scale(1.1);
        }

        .favorite-btn.active {
            color: #e53e3e;
        }

        .favorite-btn:not(.active) {
            color: #cbd5e0;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
            margin-top: 40px;
            padding: 24px;
            border-top: 1px solid #f1f5f9;
        }

        .page-btn {
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            background: white;
            border-radius: 8px;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s ease;
            color: #4a5568;
        }

        .page-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .page-btn:not(.active):hover {
            border-color: #667eea;
            color: #667eea;
        }

        .page-info {
            color: #718096;
            font-size: 0.9rem;
            margin: 0 16px;
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 16px;
            }

            .header, .filter-section, .content-section {
                padding: 20px;
            }

            .filter-row {
                flex-direction: column;
                gap: 16px;
                align-items: stretch;
            }

            .search-section {
                justify-content: center;
            }

            .search-input {
                width: 200px;
            }

            .date-filters, .filter-tags {
                justify-content: center;
            }

            .date-filters {
                flex-wrap: wrap;
            }

            .recipe-header {
                flex-direction: column;
                gap: 8px;
            }

            .recipe-actions {
                flex-direction: column;
                gap: 12px;
                align-items: flex-start;
            }
            
            .delete-btn {
			    background: #f8f9fa;
			    border: 1px solid #dee2e6;
			    color: #868e96;
			    padding: 8px;
			    border-radius: 50%;
			    cursor: pointer;
			    transition: all 0.3s ease;
			    display: flex;
			    align-items: center;
			    justify-content: center;
			    width: 36px;
			    height: 36px;
			}
			
			.delete-btn:hover {
			    background: #e53e3e;
			    color: white;
			    border-color: #e53e3e;
			    transform: scale(1.1);
			}
			
			/* 삭제될 때 적용될 애니메이션 */
			.recipe-item.removing {
			    transition: opacity 0.5s ease, transform 0.5s ease, max-height 0.5s ease;
			    opacity: 0;
			    transform: scale(0.95);
			    max-height: 0;
			    padding-top: 0;
			    padding-bottom: 0;
			    margin-bottom: 0;
			    overflow: hidden;
			    border: none;
			}
        }
    </style>
</head>
<body>
    <div class="container">
    	<input type="hidden" id="currentUserNo" value="${user_no}" />
        <%-- ... (header, filter-section은 그대로) ... --%>

        <div class="content-section">
            <c:if test="${not empty error}">
                <p style="color: red; text-align: center;">${error}</p>
            </c:if>

            <c:if test="${empty historyList}">
                <p style="text-align: center; color: #777;">추천받은 레시피 이력이 없습니다.</p>
            </c:if>

            <c:forEach var="history" items="${historyList}">
                <div class="recipe-item" id="history-row-${history.index_no}">
                    <div class="recipe-header">
                        <div class="recipe-date">
                            <%-- [수정] JSTL 충돌을 피하기 위해 날짜 파싱 부분을 더 안전하게 변경 --%>
                            <c:set var="recDateString" value="${history.rec_date}" />
                            <c:if test="${recDateString != null}">
                                <fmt:parseDate value="${recDateString}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" />
                                <fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd" />
                            </c:if>
                        </div>
                        <div class="recipe-calories">
                            <%-- calorie가 null일 경우 '정보 없음' 표시 --%>
                            <c:choose>
                                <c:when test="${not empty history.calorie and history.calorie > 0}">
                                    ${history.calorie}kcal
                                </c:when>
                                <c:otherwise>
                                    정보 없음
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <%-- [수정] JSTL 충돌을 피하기 위해 onclick의 EL을 변수로 분리 --%>
                    <c:set var="detailUrl" value="/recipeDetail?recipeId=${history.recipe_id}" />
                    <div class="recipe-title" onclick="location.href='${detailUrl}'" style="cursor: pointer;">
                        ${history.food}
                    </div>
                    
                    <div class="recipe-ingredients">
                        <strong>선택했던 재료:</strong> ${history.ingredient}
                    </div>
                    
                    <%-- ... (나머지 부분) ... --%>
                    <div class="recipe-actions">
        <div class="recipe-tags">
            <%-- 재료를 쉼표로 분리하여 태그처럼 표시 (예시) --%>
            <c:forEach var="tag" items="${history.ingredient.split(',')}">
                <span class="recipe-tag">#<c:out value="${tag.trim()}"/></span>
            </c:forEach>
        </div>
        
        <%-- 삭제 버튼 --%>
        <button class="delete-btn"
                data-index-no="${history.index_no}"
                title="이력 삭제">
            <%-- SVG 아이콘으로 깔끔하게 표시 --%>
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z"/>
                <path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4zM2.5 3h11V2h-11z"/>
            </svg>
        </button>
    </div>
                </div>
            </c:forEach>
        </div>

        <%-- ... (pagination) ... --%>
    </div>

    <script>
        // 페이지 로드시 현재 날짜 설정
        /*window.onload = function() {
            const today = new Date();
            const lastWeek = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
            
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');
            if (startDateInput && endDateInput) {
            	startDateInput.value = lastWeek.toISOString().split('T')[0];
            	endDateInput.value = today.toISOString().split('T')[0];
            }
            
         	// 삭제 버튼 이벤트 리스너 등록
            addDeleteEventListeners();
        }; */

        /* function searchRecipes() {
            const searchTerm = document.getElementById('searchInput').value;
            console.log('검색:', searchTerm);
            // 실제 구현시 검색 로직 추가
        }

        function searchByDate() {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            
            if (!startDate || !endDate) {
                alert('시작 날짜와 종료 날짜를 모두 선택해주세요.');
                return;
            }
            
            if (new Date(startDate) > new Date(endDate)) {
                alert('시작 날짜는 종료 날짜보다 이전이어야 합니다.');
                return;
            }
            
            console.log('날짜별 조회:', startDate, '~', endDate);
            // 실제 구현시 날짜별 필터링 로직 추가
        }

        function filterByTag(tag) {
            console.log('태그 필터:', tag);
            // 실제 구현시 태그 필터링 로직 추가
        }*/

        /* function toggleFavorite(button) {
            if (button.classList.contains('active')) {
                button.classList.remove('active');
                button.innerHTML = '🤍';
            } else {
                button.classList.add('active');
                button.innerHTML = '❤️';
            }
        } */

        /* function changePage(direction) {
            console.log('페이지 변경:', direction);
            // 실제 구현시 페이지네이션 로직 추가
        }

        // 검색 입력시 엔터키 처리
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchRecipes();
            }
        }); */
        
        
        
     	// 모든 삭제 버튼에 이벤트 리스너를 동적으로 추가하는 함수
        /*function addDeleteEventListeners() {
            document.querySelectorAll('.delete-btn').forEach(button => {
                // 중복 등록을 방지하기 위해 기존 리스너 제거
                button.removeEventListener('click', handleDeleteClick);
                // 새 리스너 등록
                button.addEventListener('click', handleDeleteClick);
            });
        }*/
        
     	// HTML 문서 구조가 준비되면 즉시 실행
        document.addEventListener('DOMContentLoaded', function() {
            
            // 페이지에 있는 모든 삭제 버튼을 찾아서 각각 이벤트 리스너를 등록
            const deleteButtons = document.querySelectorAll('.delete-btn');
            deleteButtons.forEach(button => {
            	// 기존에 혹시라도 등록된 리스너가 있다면 깨끗하게 제거
                button.removeEventListener('click', handleDeleteClick); 
                // 새로운 리스너를 딱 한 번만 등록
                button.addEventListener('click', handleDeleteClick);
            });

        }); // DOMContentLoaded 이벤트 리스너 끝

        // 삭제 버튼 클릭 시 실행될 함수
        function handleDeleteClick(event) {
        	
        	// 기본 동작(있다면) 중지
            event.preventDefault();
            
            console.log("--- 삭제 버튼 클릭 이벤트 시작 ---");
            const button = event.currentTarget; // 클릭된 버튼
            
         	// ⭐⭐⭐ 해결책: 변수 값을 함수 맨 위에서 한번만 가져오고, 바로 확인합니다. ⭐⭐⭐
            const indexNo = button.dataset.indexNo;
    		const userNoInput = document.getElementById('currentUserNo');
    		const userNo = userNoInput.value;
            
            console.log("1. userNo:", userNo );
            console.log("2. indexNo:", indexNo );

            // 디버깅을 위해 현재 input 요소와 그 값을 출력
            console.log("currentUserNo input element:", userNoInput);
            if (userNoInput) {
                console.log("Value from input:", userNoInput.value);
            }
            
         	// userNo가 없는 경우를 대비한 방어 코드
            if (!userNo || !indexNo) {
                alert('사용자 정보 또는 이력 번호가 올바르지 않습니다.');
                console.error('userNo 또는 indexNo를 찾을 수 없음:', { userNo, indexNo });
                return;
            }
            
         	
            
            // 사용자에게 정말 삭제할 것인지 확인
            if (confirm('정말로 이 레시피 이력을 삭제하시겠습니까?')) {
            	
            	// 변환된 문자열로 URL 생성
            	const url = '/user/' + userNo + '/recipe-history/' + indexNo;
            	console.log("3. 생성된 최종 URL:", url);
        
                // Spring 컨트롤러의 삭제 API 호출
                fetch(url, {
                    method: 'DELETE',
                    headers: {
                        // Spring Security CSRF 토큰이 활성화된 경우, 헤더에 토큰을 포함해야 합니다.
                        // 'X-CSRF-TOKEN': '여기에 CSRF 토큰 값' 
                    }
                })
                .then(response => {
                	console.log("4. 서버 응답 받음:", response);
                    // 응답이 성공적인지(2xx 상태 코드) 확인
                    if (response.ok) {
                    	
                    	// 응답 본문이 없을 수도 있으므로, 확인 후 파싱
                        const contentType = response.headers.get("content-type");
                        if (contentType && contentType.indexOf("application/json") !== -1) {
                        	return response.json(); // 성공 시 json 본문을 파싱
                    	} else {
                    		// JSON이 아니면 성공했다는 의미의 빈 객체 반환
                        	return {};
                    	}
                
                    } else {
                    	// 실패 시 에러 처리를 위해 Promise를 거부
                    	return Promise.reject(response);
                    }
                })
                .then(data => {
                    // 성공적으로 삭제되었을 때
                    console.log('5. 삭제 성공:', data.message || "성공적으로 삭제되었습니다.");
                    
                    // 화면에서 해당 아이템을 부드럽게 제거
                    const itemToRemove = document.getElementById('history-row-' + indexNo);
                    if (itemToRemove) {
                        // CSS 클래스를 추가하여 애니메이션 효과 시작
                        itemToRemove.classList.add('removing');
                        
                        // 애니메이션이 끝난 후 DOM에서 완전히 제거
                        setTimeout(() => {
                            itemToRemove.remove();
                        }, 500); // CSS transition 시간과 일치시킴
                    }
                })
                .catch(errResponse => {
                    // fetch 요청 자체가 실패했거나, 응답이 2xx가 아닐 때
                    // 응답 본문(JSON)을 읽으려고 시도
                    console.error('6. 삭제 요청 중 오류 발생:', errResponse);
                    errResponse.text().then(text => {
                    	try {
                    		const errorBody = JSON.parse(text);
	                    	// FastAPI나 Spring이 보낸 에러 메시지를 alert으로 표시
                        	alert('삭제 실패: ' + (errorBody.detail || errorBody.message || '서버 오류가 발생했습니다.'));
                    	} catch(e) {
                    		// 응답 본문이 JSON이 아니거나 다른 문제 발생 시
                        	alert('삭제 실패: ' + text);
                    	}
                    });
                });
            }
        }
        
        
    </script>
</body>
</html>