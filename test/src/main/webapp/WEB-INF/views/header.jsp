<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta charset="UTF-8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">  
<%@ page import="org.springframework.security.core.userdetails.UserDetails" %>
<%@ page import="test.service.CustomUserDetail" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>


.tile {

font-size: 20px;

}

.tile.menu-item {

margin-bottom : 12px;

}

#logo {

margin-top: 10px;

}

       * {
            margin: 0; padding: 0; box-sizing: border-box;
        }

        body {
            font-family: 'Malgun Gothic', sans-serif;
            background-color: #ffffff;
            min-height: 100vh;
            position: relative;
        }

        .container {
            max-width: 800px;
            margin: 100px auto;
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1); /* 은은한 바깥 그림자 */
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

		        .login-btn {
		    background: #764ba2;
		    color: white;
		    border: none;
		    padding: 8px 16px;
		    border-radius: 20px;
		    cursor: pointer;
		    font-size: 0.9rem;
		    font-weight: bold;
		}
		
		.login-btn:hover {
		    background: #5a3a7a;
		}
</style>  


<!-- header.jsp 내부 -->
<div class="menu" style="display: flex; justify-content: space-between; align-items: center; padding: 10px 40px;">

    <!-- 좌측 메뉴 -->
    <div style="display: flex; align-items: center; gap: 30px;">
        <div class="tile" onclick="location.href='${pageContext.request.contextPath}/Main'" id="logo"><h3>🧊 FrostAI</h3></div>
        <div class="tile menu-item" onclick="location.href='${pageContext.request.contextPath}/Main'">이미지 분석</div>
        <div class="tile menu-item" onclick="location.href='${pageContext.request.contextPath}/chatbot'">챗봇과 대화</div>
        <div class="tile menu-item" onclick="location.href='${pageContext.request.contextPath}/board'">게시판</div>
    </div>




    <%-- <!-- 우측 사용자 드롭다운 -->
    <div class="dropdown">
        <button class="dropdown-toggle">
            <img src="https://png.pngtree.com/png-vector/20220821/ourmid/pngtree-user-icon-website-my-page-icon-vector-user-mobile-employee-vector-png-image_48202580.jpg" style="width: 32px; height: 32px; border-radius: 50%;">
        </button>
        <div class="dropdown-content">
            <p style="margin: 0; font-weight: bold;">
                <% 
                    Object kakaouser = session.getAttribute("kakaoUser"); 
                    Object userObj = session.getAttribute("userInform");
                    if (kakaouser == null && userObj instanceof UserDetails) {
                        UserDetails userDetails = (UserDetails) userObj;
                        out.print("안녕하세요 " + userDetails.getUsername() + "님");
                    } else if (kakaouser instanceof Map) {
                        Map<String, Object> kakaoMap = (Map<String, Object>) kakaouser;
                        Map<String, Object> props = (Map<String, Object>) kakaoMap.get("properties");
                        if (props != null && props.get("nickname") != null && props.get("profile_image") != null) {
                            out.print("안녕하세요 " + props.get("nickname") + "님");
                            out.print("<img src='" + props.get("profile_image") + "' alt='프로필' style='width: 100px; height: 100px; border-radius: 50%; margin-right: 8px; '>");
                        } else {
                            out.print("안녕하세요 사용자님");
                        }
                    }
                %>
            </p>
            <a href="/memberpage">마이페이지 이동</a>
            <form action="customlogout" method="post">
                <button type="submit">로그아웃</button>
            </form>
        </div>
    </div> --%>
    
  <%
    Object kakaouser = session.getAttribute("kakaoUser"); 
    Object userObj = session.getAttribute("userInform");
    boolean isLoggedIn = (kakaouser != null) || (userObj instanceof UserDetails);
%>

<% if (isLoggedIn) { %>
    <!-- 로그인된 사용자용 드롭다운 -->
    <div class="dropdown">
        <button class="dropdown-toggle">
            <img src="https://png.pngtree.com/png-vector/20220821/ourmid/pngtree-user-icon-website-my-page-icon-vector-user-mobile-employee-vector-png-image_48202580.jpg" style="width: 32px; height: 32px; border-radius: 50%;">
        </button>
        <div class="dropdown-content">
            <p style="margin: 0; font-weight: bold;">
                <% 
                    if (kakaouser == null && userObj instanceof UserDetails) {
                        UserDetails userDetails = (UserDetails) userObj;
                        out.print("안녕하세요 " + userDetails.getUsername() + "님");
                    } else if (kakaouser instanceof Map) {
                        Map<String, Object> kakaoMap = (Map<String, Object>) kakaouser;
                        Map<String, Object> props = (Map<String, Object>) kakaoMap.get("properties");
                        if (props != null && props.get("nickname") != null && props.get("profile_image") != null) {
                            out.print("안녕하세요 " + props.get("nickname") + "님");
                            out.print("<img src='" + props.get("profile_image") + "' alt='프로필' style='width: 100px; height: 100px; border-radius: 50%; margin-right: 8px; '>");
                        } else {
                            out.print("안녕하세요 사용자님");
                        }
                    }
                %>
            </p>
            <a href="/memberpage">마이페이지 이동</a>
            <form action="customlogout" method="post" style="margin: 0;">
                <button type="submit">로그아웃</button>
            </form>
        </div>
    </div>
<% } else { %>
    <!-- 로그인되지 않은 사용자용 로그인 버튼 -->
    <button class="login-btn" onclick="location.href='/login'">로그인</button>
<% } %>
    
    
</div>






