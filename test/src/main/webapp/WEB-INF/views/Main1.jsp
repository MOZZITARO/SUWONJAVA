<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.security.core.userdetails.UserDetails" %>
<%@ page import="test.service.CustomUserDetail" %>
<%@ page import="test.controller.User" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>냉장고 이미지 분석</title>
    <style>
        * {
            margin: 0; padding: 0; box-sizing: border-box;
        }

        body {
            font-family: 'Malgun Gothic', sans-serif;
            background-color: #ffffff;
            min-height: 100vh;
            position: relative;
            background-color: #f6f6f6;
        }

		    .container {
		    max-width: 1000px; /* 기존 800px → 20% 증가 */
		    margin: 80px auto; /* 상하 여백은 살짝 줄이거나 그대로 유지 */
		    background: white;
		    border-radius: 20px;
		    padding: 48px; /* 기존 40px → 20% 증가 */
		    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
		    position: relative;
		}
        .user-menu {
            position: absolute;
            top: -70px;
            right: 20px;
        }

        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-toggle {
            background: #fff;
            color: #333;
            border: 2px solid #764ba2;
            padding: 8px 16px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: bold;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background-color: #fff;
            min-width: max-content;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            padding: 12px;
            border-radius: 10px;
            white-space: nowrap;
        }

        .dropdown-content a,
        .dropdown-content button {
            display: block;
            width: 100%;
            background: none;
            border: none;
            padding: 8px 0;
            color: #333;
            font-size: 0.9rem;
            text-align: left;
            cursor: pointer;
            text-decoration: none;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: #667eea;
            font-size: 3rem;
            font-weight: 700;
            margin-bottom:5%;
        }

        .header p {
            color: #666;
            font-size: 1.3rem;
            line-height: 1.6;
        }

        .upload-box {
            border: 3px dashed #ccc;
            border-radius: 15px;
            padding: 72px 24px;
            text-align: center;
            background: #fafafa;
            min-height: 240px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .upload-icon {
            font-size: 5.4rem;
            color: #ccc;
            margin-bottom: 15px;
        }

        .upload-text {
            color: #666;
            font-size: 1.44rem;
            margin-bottom: 10px;
        }

        .upload-hint {
            color: #999;
            font-size: 1.08rem;
        }

        .btn-primary {
            padding: 18px 36px;
            background: #2c3e50;
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 1.32rem;
            font-weight: bold;
            cursor: pointer;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container">


    <!-- 마이페이지 드롭다운 -->
<%-- <div class="user-menu">
    <div class="dropdown">
        <div class="dropdown-content">
            <%
            Object kakaouser = session.getAttribute("kakaoUser");
            Object userObj = session.getAttribute("userInform");
            
            // 로그인 상태 체크
            boolean isLoggedIn = false;
            
            if (kakaouser != null && kakaouser instanceof Map) {
                // 카카오 사용자 로그인 상태
                isLoggedIn = true;
                Map<String, Object> kakaoMap = (Map<String, Object>) kakaouser;
                Map<String, Object> props = (Map<String, Object>) kakaoMap.get("properties");
            %>
                <p style="margin: 0; font-weight: bold;">
                    <%
                    if (props != null && props.get("nickname") != null && props.get("profileImage") != null) {
                        out.print("안녕하세요 " + props.get("nickname") + "님");
                        out.print("<img src='" + props.get("profileImage") + "' alt='프로필' style='width: 30px; height: 30px; border-radius: 50%; margin-left: 8px;'>");
                    } else {
                        out.print("안녕하세요 사용자님");
                    }
                    %>
                </p>
                <a href="/memberpage">마이페이지 이동</a>
                <form action="customlogout" method="post" style="margin-top: 10px;">
                    <button type="submit">로그아웃</button>
                </form>
            <%
            } else if (userObj != null && userObj instanceof UserDetails) {
                // 일반 사용자 로그인 상태
                isLoggedIn = true;
                UserDetails userDetails = (UserDetails) userObj;
            %>
                <p style="margin: 0; font-weight: bold;">
                    안녕하세요 <%= userDetails.getUsername() %>님
                </p>
                <a href="/memberpage">마이페이지 이동</a>
                <form action="customlogout" method="post" style="margin-top: 10px;">
                    <button type="submit">로그아웃</button>
                </form>
            <%
            } else {
                // 로그아웃 상태 - 로그인 버튼만 표시
            %>
                <div class="login-section">
                    <p style="margin: 0 0 10px 0; font-weight: bold; color: #666;">로그인이 필요합니다</p>
                    <a href="/login" class="login-btn" style="
                        display: inline-block;
                        padding: 8px 16px;
                        background-color: #4CAF50;
                        color: white;
                        text-decoration: none;
                        border-radius: 4px;
                        font-weight: bold;
                        text-align: center;
                    ">로그인</a>
                </div>
            <%
            }
            %>
        </div>
    </div>
</div> --%>



<%-- <%
    Object userObj = session.getAttribute("userInform");
    if (userObj instanceof test.service.CustomUserDetail) {
        test.service.CustomUserDetail customUser = (test.service.CustomUserDetail) userObj;
        out.print("안녕하세요 " + customUser.getName() + "님");
    } else if (userObj instanceof org.springframework.security.core.userdetails.UserDetails) {
        org.springframework.security.core.userdetails.UserDetails userDetails = (org.springframework.security.core.userdetails.UserDetails) userObj;
        out.print("안녕하세요 " + userDetails.getUsername() + "님");
    }
%>
 --%>

    <!-- 제목 및 설명 -->
    <div class="header">
        <h1>🧊 냉장고 재료 이미지 분석</h1>
        <p>냉장고 재료 이미지를 업로드하면<br>분석하여 조리 가능한 선택지를 제공합니다.</p>
        
    </div>

    <!-- 업로드 박스 -->
    <div class="upload-box">
        <div class="upload-icon">📷</div>
        <div class="upload-text">재료 이미지 드롭 (드래그, 업로드 등)</div>
        <div class="upload-hint">클릭하거나 파일을 드래그하여 업로드하세요</div>
        <button class="btn-primary" onclick="location.href='/imageresult'" style="cursor: pointer;">조회</button>
    </div>

</div>

</body>
</html>
