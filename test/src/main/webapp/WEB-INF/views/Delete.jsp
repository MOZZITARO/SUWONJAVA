<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>계정 삭제</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
           
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        
        .content {
            padding: 30px;
            text-align: center;
            font-size: 16px;
            
            background-color: #ffffff !important; /* 💡 강제 지정 */
    		color: #2c3e50;
    		 display: inline-block;
    		 margin-left:170px;
    		 
        }
        
        
        .container {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            width: 700px;
            max-width: 90%;
            padding-bottom: 10px;
           
        }
        .header {
            background-color: #2c3e50;
            color: #fff;
            padding: 20px;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
            font-size: 20px;
            font-weight: bold;
            text-align: center;
        }
        
        .btn-box {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }
        
        .btn {
            padding: 10px 20px;
            font-size: 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-cancel {
            background-color: #bdc3c7;
            color: #fff;
        }
        .btn-delete {
            background-color: #e74c3c;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">계정 삭제</div>
        <div class="content">
            정말로 계정을 삭제하시겠습니까?<br>
            이 작업은 되돌릴 수 없습니다.
            <div class="btn-box">
                <form action="/account/delete" method="post">
                    <button type="submit" class="btn btn-delete">삭제</button>
                </form>
                <a href="/mypage">
                    <button class="btn btn-cancel">취소</button>
                </a>
            </div>
        </div>
    </div>
</body>
</html>