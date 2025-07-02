<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
<!-- <meta charset="UTF-8"> -->
<title><tiles:insertAttribute name="title" ignore="true" /></title>
    <style>
        .menu { display: flex; justify-content: space-around; background-color: white; padding: 10px; }
        .menu-item { padding: 10px; cursor: pointer; color: black; }
        .content { height: 400px; background-color: blue; color: white; display: flex; justify-content: center; align-items: center; margin-top: 10px; }
        .tile { width: 100px; height: 50px; text-align: center; line-height: 50px; }
    </style>
</head>
<body>
    <div><tiles:insertAttribute name="header" /></div>
    <div><tiles:insertAttribute name="body" /></div>
</body>
</html>