<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>계정 삭제</title>
</head>
<body>
    <h2>계정 삭제</h2>
    <form action="/deleteok" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="userId" value="${userNo}">
        <p>정말로 계정을 삭제하시겠습니까?</p>
        <button type="submit">삭제</button>
        
        <a href="/Main">취소</a>
    </form>
    
    <c:if test="${not empty error}">
        <div style="color: red;">${error}</div>
    </c:if>
    
</body>
</html>