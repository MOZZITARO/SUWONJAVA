<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                <div class="header-icon">
                    <svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25"/>
                    </svg>
                </div>
                추천레시피 이력
            </h1>
        </div>

        <div class="filter-section">
            <div class="filter-row">
                <div class="search-section">
                    <input type="text" class="search-input" placeholder="음식명 검색..." id="searchInput">
                    <button class="search-btn" onclick="searchRecipes()">
                        <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                        검색
                    </button>
                </div>
                <div class="date-filters">
                    <span class="date-label">조회 기간:</span>
                    <input type="date" class="date-input" id="startDate">
                    <span class="date-label">~</span>
                    <input type="date" class="date-input" id="endDate">
                    <button class="date-search-btn" onclick="searchByDate()">
                        <svg width="14" height="14" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                        조회
                    </button>
                </div>
            </div>
            <div class="filter-tags">
                <div class="filter-tag" onclick="filterByTag('korean')">한식</div>
                <div class="filter-tag" onclick="filterByTag('western')">양식</div>
                <div class="filter-tag" onclick="filterByTag('chinese')">중식</div>
                <div class="filter-tag" onclick="filterByTag('japanese')">일식</div>
                <div class="filter-tag" onclick="filterByTag('healthy')">건강식</div>
                <div class="filter-tag" onclick="filterByTag('quick')">간편식</div>
                <div class="filter-tag" onclick="filterByTag('diet')">다이어트</div>
            </div>
        </div>

        <div class="content-section">
            <div class="recipe-item">
                <div class="recipe-header">
                    <div class="recipe-date">2024.06.14</div>
                    <div class="recipe-calories">529kcal</div>
                </div>
                <div class="recipe-title" onclick="location.href='/DetailRecipe'" style="cursor: pointer";>단호박씨 들어간 단호박 찜닭</div>
                <div class="recipe-ingredients">단호박, 닭육수, 사육, 계란, 홍나물, 양온, 양파, 대파</div>
                <div class="recipe-actions">
                    <div class="recipe-tags">
                        <span class="recipe-tag">한식</span>
                        <span class="recipe-tag">건강식</span>
                    </div>
                    <button class="favorite-btn active" onclick="toggleFavorite(this)">❤️</button>
                </div>
            </div>

            <div class="recipe-item">
                <div class="recipe-header">
                    <div class="recipe-date">2024.06.14</div>
                    <div class="recipe-calories">350kcal</div>
                </div>
                <div class="recipe-title">닭가슴살 오트로스 베이크</div>
                <div class="recipe-ingredients">닭가슴살, 오트로스, 브로콜리, 양온, 양파, 올리브오일</div>
                <div class="recipe-actions">
                    <div class="recipe-tags">
                        <span class="recipe-tag">양식</span>
                        <span class="recipe-tag">다이어트</span>
                    </div>
                    <button class="favorite-btn active" onclick="toggleFavorite(this)">❤️</button>
                </div>
            </div>

            <div class="recipe-item">
                <div class="recipe-header">
                    <div class="recipe-date">2024.06.15</div>
                    <div class="recipe-calories">430kcal</div>
                </div>
                <div class="recipe-title">연어 마요네즈 라이스 볼 셀러드</div>
                <div class="recipe-ingredients">연어, 마요네즈, 아보카도, 오쿠친, 그래놀라, 올리브</div>
                <div class="recipe-actions">
                    <div class="recipe-tags">
                        <span class="recipe-tag">일식</span>
                        <span class="recipe-tag">건강식</span>
                    </div>
                    <button class="favorite-btn active" onclick="toggleFavorite(this)">❤️</button>
                </div>
            </div>

            <div class="recipe-item">
                <div class="recipe-header">
                    <div class="recipe-date">2024.06.16</div>
                    <div class="recipe-calories">280kcal</div>
                </div>
                <div class="recipe-title">두부 스테이크 샐러드</div>
                <div class="recipe-ingredients">두부, 상추, 토마토, 오이, 발사믹 드레싱, 올리브오일</div>
                <div class="recipe-actions">
                    <div class="recipe-tags">
                        <span class="recipe-tag">건강식</span>
                        <span class="recipe-tag">다이어트</span>
                        <span class="recipe-tag">채식</span>
                    </div>
                    <button class="favorite-btn" onclick="toggleFavorite(this)">🤍</button>
                </div>
            </div>

            <div class="recipe-item">
                <div class="recipe-header">
                    <div class="recipe-date">2024.06.17</div>
                    <div class="recipe-calories">520kcal</div>
                </div>
                <div class="recipe-title">김치 볶음밥</div>
                <div class="recipe-ingredients">김치, 쌀밥, 계란, 대파, 참기름, 김</div>
                <div class="recipe-actions">
                    <div class="recipe-tags">
                        <span class="recipe-tag">한식</span>
                        <span class="recipe-tag">간편식</span>
                    </div>
                    <button class="favorite-btn" onclick="toggleFavorite(this)">🤍</button>
                </div>
            </div>
        </div>

        <div class="pagination">
            <button class="page-btn" onclick="changePage('prev')">이전</button>
            <span class="page-info">1 / 3</span>
            <button class="page-btn" onclick="changePage('next')">다음</button>
        </div>
    </div>

    <script>
        // 페이지 로드시 현재 날짜 설정
        window.onload = function() {
            const today = new Date();
            const lastWeek = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
            
            document.getElementById('startDate').value = lastWeek.toISOString().split('T')[0];
            document.getElementById('endDate').value = today.toISOString().split('T')[0];
        };

        function searchRecipes() {
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
        }

        function toggleFavorite(button) {
            if (button.classList.contains('active')) {
                button.classList.remove('active');
                button.innerHTML = '🤍';
            } else {
                button.classList.add('active');
                button.innerHTML = '❤️';
            }
        }

        function changePage(direction) {
            console.log('페이지 변경:', direction);
            // 실제 구현시 페이지네이션 로직 추가
        }

        // 검색 입력시 엔터키 처리
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchRecipes();
            }
        });
    </script>
</body>
</html>