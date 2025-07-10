<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시판</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: white;
            min-height: 100vh;
            padding: 20px;
            background-color: #f6f6f6;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            overflow: hidden;
        }

        .header {
            background: white;
            color: #374151;
            padding: 40px 30px;
            text-align: center;
            border-bottom: 1px solid #e5e7eb;
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .search-container {
            display: flex;
            gap: 12px;
            max-width: 400px;
            margin: 0 auto;
        }

        .search-input {
            flex: 1;
            padding: 12px 20px;
            border: 2px solid transparent;
            background: linear-gradient(white, white) padding-box,
                       linear-gradient(135deg, #667eea 0%, #764ba2 100%) border-box;
            border-radius: 50px;
            font-size: 16px;
            outline: none;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            background: linear-gradient(white, white) padding-box,
                       linear-gradient(135deg, #667eea 0%, #764ba2 100%) border-box;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
            transform: translateY(-1px);
        }

        .search-input::placeholder {
            color: #6b7280;
        }

        .search-btn {
            padding: 12px 24px;
            background: white;
            color: #6366f1;
            border: 2px solid transparent;
            background: linear-gradient(white, white) padding-box,
                       linear-gradient(135deg, #667eea 0%, #764ba2 100%) border-box;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            background: linear-gradient(#f8fafc, #f8fafc) padding-box,
                       linear-gradient(135deg, #667eea 0%, #764ba2 100%) border-box;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
        }

        .board-content {
            padding: 30px;
        }

        .board-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        }

        .board-header {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
        }

        .board-header th {
            padding: 20px 15px;
            text-align: center;
            font-weight: 600;
            color: #374151;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e5e7eb;
        }

        .board-row {
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .board-row:hover {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            transform: translateY(-1px);
        }

        .board-row:not(:last-child) {
            border-bottom: 1px solid #f1f5f9;
        }

        .board-cell {
            padding: 20px 15px;
            text-align: center;
            vertical-align: middle;
        }

        .board-number {
            font-weight: 600;
            color: #6366f1;
            background: linear-gradient(135deg, #eef2ff 0%, #e0e7ff 100%);
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            font-size: 14px;
        }

        .post-title {
            text-align: left;
            font-weight: 500;
            color: #1f2937;
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .post-title:hover {
            color: #6366f1;
        }

        .author-tag {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            color: #92400e;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }

        .date-text {
            color: #6b7280;
            font-size: 14px;
        }

        .view-count {
            background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
            color: #166534;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 13px;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-top: 30px;
        }

        .page-btn {
            padding: 10px 16px;
            border: none;
            border-radius: 8px;
            background: white;
            color: #6b7280;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .page-btn:hover {
            background: #f8fafc;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .page-btn.active {
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
        }

        .write-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            float: right;
            margin-top: 20px;
            transition: all 0.3s ease;
        }

        .write-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 15px;
            }
            
            .header {
                padding: 30px 20px;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .board-content {
                padding: 20px 15px;
            }
            
            .board-table {
                font-size: 14px;
            }
            
            .board-header th,
            .board-cell {
                padding: 15px 8px;
            }
            
            .post-title {
                max-width: 150px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>게시판</h1>
            <div class="search-container">
                <input type="text" class="search-input" placeholder="검색어를 입력하세요" id="searchInput">
                <button class="search-btn" onclick="searchPosts()">검색</button>
            </div>
        </div>
        
        <div class="board-content">
            <table class="board-table">
                <thead class="board-header">
                    <tr>
                        <th>번호</th>
                        <th>분류</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>조회수</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="post" items="${posts }" varStatus="status">
                    	<tr class="board-row" onclick="location.href='${pageContext.request.contextPath}/post/${post.postId}}'">
                    		<td class="board-cell">
                                <div class="board-number">${totalCount - status.index}</div>
                            </td>
                            <td class="board-cell">
                                <span class="author-tag">${post.category}</span>
                            </td>
                            <td class="board-cell post-title">${post.title}</td>
                            <td class="board-cell">
                                <span class="author-tag">${post.author}</span>
                            </td>
                            <td class="board-cell">
                                <span class="date-text"><fmt:formatDate value="${post.regDate}" pattern="yyyy-MM-dd" /></span>
                            </td>
                            <td class="board-cell">
                                <span class="view-count">${post.views}</span>
                            </td>
                    	</tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <button class="page-btn" onclick="location.href='${pageContext.request.contextPath}/board?page=${currentPage - 1}'">이전</button>
                </c:if>
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <button class="page-btn ${currentPage == i ? 'active' : ''}" onclick="location.href='${pageContext.request.contextPath}/board?page=${i}'">${i}</button>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <button class="page-btn" onclick="location.href='${pageContext.request.contextPath}/board?page=${currentPage + 1}'">다음</button>
                </c:if>
            </div>
            
            <button class="write-btn" onclick="location.href='${pageContext.request.contextPath}/post/write'">글쓰기</button>
        </div>
    </div>
    
    <script>
        function searchPosts() {
            const searchTerm = document.getElementById('searchInput').value;
            location.href = '${pageContext.request.contextPath}/board?search=' + encodeURIComponent(searchTerm);
        }
    </script>
</body>
</html>