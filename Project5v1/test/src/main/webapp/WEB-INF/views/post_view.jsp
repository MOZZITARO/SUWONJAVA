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
    <title>글 보기</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .header h1 {
            color: #667eea;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .post-content {
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 2px solid #f0f0f0;
        }

        .post-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            padding: 20px;
            background: rgba(102, 126, 234, 0.1);
            border-radius: 12px;
            border-left: 4px solid #667eea;
        }

        .post-body {
            font-size: 16px;
            line-height: 1.6;
            color: #555;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 12px;
            min-height: 200px;
        }

        .post-meta {
            margin-top: 15px;
            font-size: 14px;
            color: #888;
            text-align: right;
        }

        .comments-section {
            margin-top: 40px;
        }

        .comments-header {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
        }

        .comment-form {
            background: rgba(102, 126, 234, 0.05);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .comment-input {
            width: 100%;
            min-height: 80px;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 14px;
            resize: vertical;
            transition: all 0.3s ease;
            background: white;
        }

        .comment-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .comment-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .comment-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .comments-list {
            margin-top: 20px;
        }

        .comment {
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            position: relative;
        }

        .comment.reply {
            margin-left: 40px;
            background: rgba(102, 126, 234, 0.02);
            border-left: 3px solid #667eea;
        }

        .comment-author {
            font-weight: 600;
            color: #667eea;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .comment-content {
            color: #555;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 10px;
        }

        .comment-actions {
            display: flex;
            gap: 10px;
            font-size: 12px;
        }

        .comment-action {
            color: #888;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 15px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .comment-action:hover {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
        }

        .comment-time {
            font-size: 12px;
            color: #aaa;
            margin-left: auto;
        }

        .edit-form {
            display: none;
            margin-top: 10px;
        }

        .edit-input {
            width: 100%;
            min-height: 60px;
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            resize: vertical;
        }

        .edit-buttons {
            margin-top: 10px;
            display: flex;
            gap: 10px;
        }

        .edit-save, .edit-cancel {
            padding: 8px 16px;
            border: none;
            border-radius: 15px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .edit-save {
            background: #667eea;
            color: white;
        }

        .edit-cancel {
            background: #ccc;
            color: white;
        }

        .reply-form {
            display: none;
            margin-top: 15px;
            padding: 15px;
            background: rgba(102, 126, 234, 0.05);
            border-radius: 8px;
            margin-left: 20px;
        }

        .reply-input {
            width: 100%;
            min-height: 60px;
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            resize: vertical;
        }
        
        .reply-action {
            color: #888;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 15px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .reply-action:hover {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
        }

        .back-button {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }

        .back-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(118, 75, 162, 0.4);
        }
        
        .files-section {
            margin-top: 20px;
            padding: 20px;
            background: rgba(102, 126, 234, 0.05);
            border-radius: 12px;
        }
        .file-item {
            margin-bottom: 10px;
            padding: 10px;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
        }
        .file-item img {
            max-width: 100px;
            max-height: 100px;
            margin-right: 10px;
        }
        .post-actions {
            margin-top: 10px;
        }
        .post-action {
            margin-right: 10px;
            padding: 5px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            cursor: pointer;
        }
        .post-action:hover {
            background-color: #f0f0f0;
        }
    </style>
</head>
<body>
    <div class="container">
        <button class="back-button" onclick="history.back()">← 목록으로 돌아가기</button>
        
        <div class="header">
            <h1>글 보기</h1>
        </div>
        
        <div class="post-content">
            <div class="post-title" id="postTitle">
                ${post.title }
            </div>
            <div class="post-body" id="postBody">
                ${post.content }
            </div>
            <div class="post-meta">
                작성자: ${post.author } | 작성시간: <fmt:formatDate value="${post.reg_date }" pattern="yyyy년 MM월 dd일 HH:mm"/> |
                수정시간: <fmt:formatDate value="${post.udt_date }" pattern="yyyy년 MM월 dd일 HH:mm"/>
            </div>
            
            <div class="post-actions">
            	<c:set var="isAdmin" value="${sessionScope.user_class == 1 }"/>
                <c:if test="${isAdmin || sessionScope.user_no == post.user_no}">
                    <span class="post-action" onclick="location.href='/post/edit/${post.post_id}'">수정</span>
                    <span class="post-action" onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='/post/delete/${post.post_id}'">삭제</span>
                </c:if>
            </div>
        </div>
        
        <c:if test="${not empty files}">
            <div class="files-section">
                <h3>첨부 파일</h3>
                <c:forEach var="file" items="${files}">
                    <div class="file-item">
                        <c:if test="${file.file_type == 'image' || not empty file.thumbnail_path}">
                            <img src="${pageContext.request.contextPath}/download?file_id=${file.file_id}&thumbnail=true" alt="${file.file_name}">
                        </c:if>
                        <a href="${pageContext.request.contextPath}/download?fileId=${file.file_id}">${file.file_name}</a>
                        (${file.file_type}, ${file.file_size} bytes)
                        <c:if test="${file.file_type == 'image'}">
                            (${file.width}x${file.height} pixels)
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        
        <div class="comments-section">
            <div class="comments-header">
                댓글 <span id="commentCount">${fn:length(conments) }</span>개
            </div>
            
            <div class="comment-form">
                <form action="${pageContext.request.contextPath}/post/${post.post_id}/comment" method="post">
                    <textarea class="comment-input" name="content" id="newCommentInput" placeholder="댓글을 입력하세요..."></textarea>
                    <button type="submit" class="comment-submit">댓글 작성</button>
                </form>
            </div>
            
            <div class="comments-list" id="commentsList">
                <c:forEach var="comment" items="${comments}">
                    <c:if test="${comment.parent_id == null}">
                        <div class="comment" id="comment-${comment.comment_id}">
                            <div class="comment-author">${comment.author}</div>
                            <div class="comment-content" id="content-${comment.comment_id}">${comment.content}</div>
                            <div class="comment-actions">
                            	<c:set var="isAdmin" value="${sessionScope.userClass == 1}" />
                                <c:if test="${ isAdmin || sessionScope.user_name == comment.author}">
                                    <span class="comment-action" onclick="editComment(${comment.comment_id})">수정</span>
                                    <span class="comment-action" onclick="deleteComment(${comment.comment_id}, false)">삭제</span>
                                </c:if>
                                <span class="reply-action" onclick="showReplyForm(${comment.comment_id})">답글</span>
                                <span class="comment-time">
                                    작성시간: <fmt:formatDate value="${comment.reg_date}" pattern="yyyy-MM-dd HH:mm" /> |
                                    수정시간: <fmt:formatDate value="${comment.udt_date}" pattern="yyyy-MM-dd HH:mm" />
                                </span>
                            </div>
                            <div class="edit-form" id="edit-${comment.comment_id}">
                                <form action="${pageContext.request.contextPath}/post/${post.post_id}/comment" method="post">
                                    <input type="hidden" name="comment_id" value="${comment.comment_id}">
                                    <textarea class="edit-input" name="content" id="edit-input-${comment.comment_id}">${comment.content}</textarea>
                                    <div class="edit-buttons">
                                        <button type="submit" class="edit-save">저장</button>
                                        <button type="button" class="edit-cancel" onclick="cancelEdit(${comment.comment_id})">취소</button>
                                    </div>
                                </form>
                            </div>
                            <div class="reply-form" id="reply-form-${comment.comment_id}">
                                <form action="${pageContext.request.contextPath}/post/${post.post_id}/comment" method="post">
                                    <input type="hidden" name="parent_id" value="${comment.comment_id}">
                                    <textarea class="reply-input" name="content" id="reply-input-${comment.comment_id}" placeholder="답글을 입력하세요..."></textarea>
                                    <div class="edit-buttons">
                                        <button type="submit" class="edit-save">답글 작성</button>
                                        <button type="button" class="edit-cancel" onclick="hideReplyForm(${comment.comment_id})">취소</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <c:forEach var="reply" items="${comments}">
                            <c:if test="${reply.parent_id == comment.comment_id}">
                                <div class="comment reply" id="comment-${reply.comment_id}">
                                    <div class="comment-author">${reply.author}</div>
                                    <div class="comment-content" id="content-${reply.comment_id}">${reply.content}</div>
                                    <div class="comment-actions">
                                    	<c:set var="isAdmin" value="${sessionScope.userClass == 1}" />
                                        <c:if test="${ isAdmin || sessionScope.user_name == reply.author}">
                                            <span class="comment-action" onclick="editComment(${reply.comment_id})">수정</span>
                                            <span class="comment-action" onclick="deleteComment(${reply.comment_id}, true)">삭제</span>
                                        </c:if>
                                        <span class="comment-time">
                                            작성시간: <fmt:formatDate value="${reply.reg_date}" pattern="yyyy-MM-dd HH:mm" /> |
                                            수정시간: <fmt:formatDate value="${reply.udt_date}" pattern="yyyy-MM-dd HH:mm" />
                                        </span>
                                    </div>
                                    <div class="edit-form" id="edit-${reply.comment_id}">
                                        <form action="${pageContext.request.contextPath}/post/${post.post_id}/comment" method="post">
                                            <input type="hidden" name="comment_id" value="${reply.comment_id}">
                                            <textarea class="edit-input" name="content" id="edit-input-${reply.comment_id}">${reply.content}</textarea>
                                            <div class="edit-buttons">
                                                <button type="submit" class="edit-save">저장</button>
                                                <button type="button" class="edit-cancel" onclick="cancelEdit(${reply.comment_id})">취소</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>

    <script>
    function editComment(comment_id) {
        document.getElementById(`content-${comment_id}`).style.display = 'none';
        document.getElementById(`edit-${comment_id}`).style.display = 'block';
    }

    function cancelEdit(comment_id) {
        document.getElementById(`content-${comment_id}`).style.display = 'block';
        document.getElementById(`edit-${comment_id}`).style.display = 'none';
    }

    function deleteComment(comment_id, isReply) {
        if (!confirm('정말 삭제하시겠습니까?')) return;
        fetch(`${pageContext.request.contextPath}/post/deleteComment/${comment_id}`, {
            method: 'DELETE'
        }).then(() => {
            location.reload();
        });
    }

    function showReplyForm(comment_id) {
        document.getElementById(`reply-form-${comment_id}`).style.display = 'block';
    }

    function hideReplyForm(comment_id) {
        document.getElementById(`reply-form-${comment_id}`).style.display = 'none';
        document.getElementById(`reply-input-${comment_id}`).value = '';
    }
    
    // 엔터키로 댓글 작성 (Ctrl + Enter)
    document.getElementById('newCommentInput').addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && e.ctrlKey) {
            this.form.submit();
        }
    });
    </script>
</body>
</html>