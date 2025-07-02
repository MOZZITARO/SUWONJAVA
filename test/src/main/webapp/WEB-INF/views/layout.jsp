<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- <meta charset="UTF-8"> -->
<title><tiles:insertAttribute name="title" ignore="true" /></title>
    <style>
        .menu { display: flex; justify-content: space-around; background-color: pink; padding: 10px; }
        .menu-item { padding: 10px; cursor: pointer; color: white; }
        .content { height: 400px; background-color: blue; color: white; display: flex; justify-content: center; align-items: center; margin-top: 10px; }
        .tile { width: 100px; height: 50px; text-align: center; line-height: 50px; }
    </style>
</head>
<body>
    <div>레이아웃 나옴 - 헤더<tiles:insertAttribute name="header" /></div>
    <div>바디 :<tiles:insertAttribute name="body" /></div>
</body>
</html>