<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="menu">
    <div class="tile" onclick="location.href='${pageContext.request.contextPath}/Main'"><h3>🧊 FrostAI</h3></div>
    <div class="tile menu-item" onclick="location.href='${pageContext.request.contextPath}/Main'">이미지 분석</div>
    <div class="tile menu-item" onclick="location.href='${pageContext.request.contextPath}/chatbot'">챗봇과 대화</div>
    <div class="tile menu-item" onclick="location.href='${pageContext.request.contextPath}/board'">게시판</div>
    <div class="tile menu-item" onclick="location.href='${pageContext.request.contextPath}/login'">로그인</div>
</div>