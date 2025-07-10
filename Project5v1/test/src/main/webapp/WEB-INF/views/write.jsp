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
    <title>글쓰기</title>
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
        }

        .container {
            max-width: 1200px;
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .form-content {
            padding: 50px 60px;
        }

        .form-row {
            display: flex;
            gap: 30px;
            margin-bottom: 30px;
        }

        .form-row .form-group {
            margin-bottom: 0;
        }

        .form-col-3 {
            flex: 0 0 300px;
        }

        .form-col-9 {
            flex: 1;
        }

        .form-col-full {
            flex: 1;
        }

        .form-group {
            margin-bottom: 30px;
        }

        .form-label {
            display: block;
            margin-bottom: 12px;
            font-weight: 600;
            color: #374151;
            font-size: 16px;
        }

        .form-select {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 16px;
            background: white;
            color: #374151;
            transition: all 0.3s ease;
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 12px center;
            background-repeat: no-repeat;
            background-size: 16px;
            padding-right: 48px;
        }

        .form-input {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 16px;
            background: white;
            color: #374151;
            transition: all 0.3s ease;
            outline: none;
        }

        .form-textarea {
            width: 100%;
            min-height: 400px;
            padding: 20px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 16px;
            background: white;
            color: #374151;
            transition: all 0.3s ease;
            outline: none;
            resize: vertical;
            font-family: inherit;
        }

        .form-select:focus,
        .form-input:focus,
        .form-textarea:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }

        .form-input::placeholder,
        .form-textarea::placeholder {
            color: #9ca3af;
        }

        .file-upload {
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .file-input {
            width: 100%;
            padding: 16px 20px;
            border: 2px dashed #d1d5db;
            border-radius: 12px;
            background: #f9fafb;
            color: #6b7280;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .file-input:hover {
            border-color: #667eea;
            background: #f0f4ff;
            color: #667eea;
        }

        .file-input input[type="file"] {
            position: absolute;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }

        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 40px;
        }

        .btn {
            padding: 16px 32px;
            border: none;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 120px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #6b7280;
            color: white;
        }

        .btn-secondary:hover {
            background: #4b5563;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(107, 114, 128, 0.3);
        }

        .divider {
            margin: 30px 0;
            text-align: center;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #e5e7eb;
        }

        .divider span {
            background: white;
            padding: 0 20px;
            color: #6b7280;
            font-size: 14px;
        }

        .google-btn {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            background: white;
            color: #374151;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .google-btn:hover {
            border-color: #d1d5db;
            background: #f9fafb;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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
            
            .form-content {
                padding: 30px 20px;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>${post.post_id == null ? null ? '글쓰기' : '글 수정'}</h1>
            <c:if test="${param.error == 'onlyAdminCanPostNotice' }">
            	<p style="color:red;"> 공지사항은 관리자만 작성할 수 있습니다.</p>
            </c:if>
        </div>
        
        <div class="form-content">
            <form action="${pageContext.request.contextPath}/post/${post.post_id != null ? 'edit/' + post.post_id : 'write'}" method="${post.post_id != null ? 'post' : 'post'}" enctype="multipart/form-data">
                <input type="hidden" name="post_id" value="${post.post_id}">
                <div class="form-row">
                    <div class="form-group form-col-3">
                        <label class="form-label">분류</label>
                        <select name="category" class="form-select" ${post.post_id != null || !isAdmin ? 'disabled' : ''}>
                            <c:if test="${isAdmin }">
	                            <option value="공지" ${post.category == '공지' ? 'selected' : ''}>공지</option>                        	
                            </c:if>
                            <option value="자유" ${post.category == '자유' ? 'selected' : ''}>자유</option>
                            <option value="질문" ${post.category == '질문' ? 'selected' : ''}>질문</option>
                            <option value="정보" ${post.category == '정보' ? 'selected' : ''}>정보</option>
                        </select>
                    </div>

                    <div class="form-group form-col-9">
                        <label class="form-label">제목</label>
                        <input type="text" name="title" class="form-input" value="${post.title}" placeholder="제목을 입력하세요" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">내용</label>
                    <textarea name="content" class="form-textarea" placeholder="내용을 입력하세요" required>${post.content}</textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">파일 업로드</label>
                    <div class="file-upload">
                        <div class="file-input">
                            <input type="file" name="file" multiple>
                            📎 파일 선택 · 선택된 파일 없음
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">이미지 업로드</label>
                    <div class="file-upload">
                        <div class="file-input">
                            <input type="file" name="image" multiple accept="image/*">
                            📷 이미지 선택 · 선택된 이미지 없음
                        </div>
                    </div>
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-primary">${post.post_id == null ? '등록' : '수정'}</button>
                    <button type="button" class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}${post.post_id != null ? '/post/' + post.post_id : '/board'}'">취소</button>
                </div>
            </form>
        </div>
    </div>

    <script>
    	const fileInput = document.querySelector('input[name="file"]');
    	const fileLabel = document.querySelector('.file-input:nth-child(1)');
    	const imageInput = document.querySelector('input[name="image"]');
    	const imageLabel = document.querySelector('.file-input:nth-child(2)');

    	fileInput.addEventListener('change', function(e) {
        	const files = Array.from(e.target.files);
        	if (files.length > 0) {
            	const fileNames = files.map(file => file.name).join(', ');
            	fileLabel.innerHTML = `📎 ${files.length}개 파일 선택 · ${fileNames}`;
        	} else {
            	fileLabel.innerHTML = '📎 파일 선택 · 선택된 파일 없음';
        	}
    	});

    	imageInput.addEventListener('change', function(e) {
        	const images = Array.from(e.target.files);
        	if (images.length > 0) {
            	const imageNames = images.map(image => image.name).join(', ');
            	imageLabel.innerHTML = `📷 ${images.length}개 이미지 선택 · ${imageNames}`;
        	} else {
            	imageLabel.innerHTML = '📷 이미지 선택 · 선택된 이미지 없음';
        	}
    	});
    </script>
</body>
</html>