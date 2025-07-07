<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.security.core.userdetails.UserDetails" %>
<%@ page import="test.service.CustomUserDetail" %>
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
        }

        .container {
            max-width: 800px;
            margin: 100px auto;
            background: white;
            border-radius: 20px;
            padding: 40px;
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
            font-size: 2.5rem;
            font-weight: 700;
        }

        .header p {
            color: #666;
            font-size: 1.1rem;
            line-height: 1.6;
        }

        .upload-box {
            border: 3px dashed #ccc;
            border-radius: 15px;
            padding: 60px 20px;
            text-align: center;
            background: #fafafa;
            min-height: 200px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            transition: border-color 0.3s ease;
            cursor: pointer; /* 클릭 가능하게 표시 */
        }

        .upload-box.dragover {
            border-color: #2c3e50;
            background: #e6f3ff;
        }

        .upload-icon {
            font-size: 3rem;
            color: #ccc;
            margin-bottom: 15px;
        }

        .upload-text {
            color: #666;
            font-size: 1.2rem;
            margin-bottom: 10px;
        }

        .upload-hint {
            color: #999;
            font-size: 0.9rem;
        }

        .btn-primary {
            padding: 15px 30px;
            background: #2c3e50;
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            margin-top: 20px;
        }

        .file-input {
            display: none; /* 숨김 유지 */
        }
        
        .result-section { margin-top: 20px; }
        .recipe-preview { cursor: pointer; border: 1px solid #ccc; padding: 10px; margin: 5px; }
      
    </style>
    <script>
    
    function validateForm() {
        const fileInput = document.querySelector('input[name="image"]');
        if (!fileInput.value) {
            alert('이미지를 선택해 주세요.');
            return false;
        }
        return true;
    }
    
        document.addEventListener('DOMContentLoaded', () => {
            const uploadBox = document.querySelector('.upload-box');
            const fileInput = document.querySelector('input[name="image"]');

            if (!uploadBox || !fileInput) {
                console.error('uploadBox 또는 fileInput 요소를 찾을 수 없습니다.');
                return;
            }

            uploadBox.addEventListener('click', () => {
                console.log('upload-box 클릭됨');
                fileInput.click(); // 파일 선택 대화 상자 열기
                if (fileInput.value) {
                    uploadBox.querySelector('.upload-text').textContent = fileInput.files[0].name;
                    console.log('파일 선택됨: ', fileInput.files[0].name);
                }
            });

            fileInput.addEventListener('change', () => {
                if (fileInput.files.length > 0) {
                    uploadBox.querySelector('.upload-text').textContent = fileInput.files[0].name;
                    console.log('파일 선택됨: ', fileInput.files[0].name);
                }
            });

            // 드래그 이벤트 (선택 사항, 현재 비활성화)
            // uploadBox.addEventListener('dragover', (e) => {
            //     e.preventDefault();
            //     uploadBox.classList.add('dragover');
            // });
            //
            // uploadBox.addEventListener('dragleave', () => {
            //     uploadBox.classList.remove('dragover');
            // });
            //
            // uploadBox.addEventListener('drop', (e) => {
            //     e.preventDefault();
            //     uploadBox.classList.remove('dragover');
            //     const files = e.dataTransfer.files;
            //     if (files.length > 0) {
            //         fileInput.files = files;
            //         uploadBox.querySelector('.upload-text').textContent = files[0].name;
            //         console.log('파일 드롭됨: ', files[0].name);
            //     }
            // });
            
        });
        
        
    </script>
</head>
<body>

<div class="container">

    <!-- 마이페이지 드롭다운 -->
    <div class="user-menu">
        <div class="dropdown">
<!--             <button class="dropdown-toggle">마이페이지 ▼</button> -->
            <div class="dropdown-content">
                <%-- <p style="margin: 0; font-weight: bold;">
                    <% 
                        Object kakaouser = session.getAttribute("kakaoUser"); 
                        Object userObj = session.getAttribute("userInform");
                        if (kakaouser == null && userObj instanceof UserDetails) {
                            UserDetails userDetails = (UserDetails) userObj;
                            out.print("안녕하세요 " + userDetails.getUsername() + "님");
                        } else if (kakaouser instanceof Map) {
                            Map<String, Object> kakaoMap = (Map<String, Object>) kakaouser;
                            Map<String, Object> props = (Map<String, Object>) kakaoMap.get("properties");
                            if (props != null && props.get("nickname") != null) {
                                out.print("안녕하세요 " + props.get("nickname") + "님");
                            } else {
                                out.print("안녕하세요 사용자님");
                            }
                        }
                    %>
                </p> --%>
                <a href="/memberpage">마이페이지 이동</a>
                <form action="customlogout" method="post">
                    <button type="submit">로그아웃</button>
                </form>
            </div>
        </div>
    </div>

    <!-- 제목 및 설명 -->
    <div class="header">
        <h1>🧊 냉장고 재료 이미지 분석</h1>
        <p>냉장고 재료 이미지를 업로드하면<br>분석하여 조리 가능한 선택지를 제공합니다.</p>
    </div>

    <!-- 업로드 폼 -->
    <div class="upload-box">
        <div class="upload-icon">📷</div>
        <div class="upload-text">재료 이미지 업로드</div>
        <div class="upload-hint">클릭해서 파일을 업로드하세요</div>
        <form action="/predictImageRecipe1" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
            <input type="file" name="image" class="file-input" accept="image/*" required>
            <button type="submit" class="btn-primary">조회</button>
        </form>
        <c:if test="${not empty error}">
            <p style="color: red">${error}</p>
        </c:if>
    </div>
    
	<c:if test="${not empty result}">
            <div class="result-section">
                <h3>식재료</h3>
                <ul>
                    <c:forEach var="ing" items="${result.ingredients}">
                        <li>${ing}</li>
                    </c:forEach>
                </ul>
                
                <h3>레시피 목록 (최대 3개)</h3>
                <div>
                    <c:forEach var="recipe" items="${result.recipe}" varStatus="loop">
                        <c:if test="${loop.index < 3}">
                            <a href="/recipeDetail?recipeId=${recipe.recipe_id}" class="recipe-preview">
                                ${recipe.name}
                            </a>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </c:if>
	</div>

</body>
</html>