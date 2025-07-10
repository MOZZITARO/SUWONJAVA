<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %> <%-- 이 줄을 추가! --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>냉장고 이미지 분석</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: 'Pretendard', -apple-system, sans-serif; background-color: #f4f7f6; color: #333; }
.container { max-width: 800px; margin: 50px auto; background: white; border-radius: 20px; padding: 40px; box-shadow: 0 15px 45px rgba(0, 0, 0, 0.1); }
.header { text-align: center; margin-bottom: 30px; }
h1 { color: #667eea; font-size: 2.2rem; font-weight: 700; }
p { color: #555; font-size: 1rem; line-height: 1.6; }

.upload-box { border: 3px dashed #d1d5db; border-radius: 15px; padding: 40px 20px; text-align: center; background: #f9fafb; transition: all 0.3s ease; cursor: pointer; }
.upload-box.dragover { border-color: #667eea; background: #eef2ff; transform: scale(1.02); }
.upload-icon { font-size: 2.5rem; color: #9ca3af; margin-bottom: 15px; }
.upload-text { color: #374151; font-size: 1.1rem; font-weight: 600; }
.upload-hint { color: #6b7280; font-size: 0.9rem; margin-top: 5px; }

.file-input { display: none; }

.image-preview-area { display: flex; flex-wrap: wrap; gap: 15px; margin-top: 25px; }
.image-preview-item { position: relative; width: 120px; height: 120px; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 8px rgba(0,0,0,0.1); transition: transform 0.2s; }
.image-preview-item:hover { transform: translateY(-3px); }
.preview-img { width: 100%; height: 100%; object-fit: cover; }
.remove-btn { 
    position: absolute; 
    top: 5px; 
    right: 5px; 
    width: 22px; 
    height: 22px; 
    background: rgba(0,0,0,0.6); 
    color: white; 
    border: none; 
    border-radius: 50%; 
    cursor: pointer; 
    /* --- ▼▼▼ 폰트 관련 스타일 삭제 또는 주석 처리 ▼▼▼ --- */
    /* font-size: 14px; 
    line-height: 22px; 
    text-align: center;  */
}
/* --- ▼▼▼ 'X' 모양을 만들기 위한 가상 요소 스타일 추가 ▼▼▼ --- */
.remove-btn::before, .remove-btn::after {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 12px; /* X의 크기 */
    height: 2px; /* X의 굵기 */
    background-color: white;
}
.remove-btn::before {
    transform: translate(-50%, -50%) rotate(45deg);
}
.remove-btn::after {
    transform: translate(-50%, -50%) rotate(-45deg);
}
.status-overlay { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(255,255,255,0.8); display: flex; align-items: center; justify-content: center; font-size: 2rem; opacity: 0; transition: opacity 0.3s; 
	/* ⭐⭐⭐ 해결책: 평소에는 마우스 클릭을 통과시킴 ⭐⭐⭐ */
    pointer-events: none;
}
.status-overlay.success { color: #22c55e; opacity: 1; } /* 초록색 체크 */
.status-overlay.failure { color: #ef4444; opacity: 1; } /* 빨간색 경고 */

/* 분석 결과가 표시될 때만 다시 마우스 이벤트를 받도록 함 */
.status-overlay.success, .status-overlay.failure {
    pointer-events: auto;
}

.button-container { display: flex; justify-content: center; gap: 20px; margin-top: 25px; }
.btn-primary { padding: 12px 28px; background: linear-gradient(45deg, #667eea, #764ba2); color: white; border: none; border-radius: 50px; font-size: 1.1rem; font-weight: bold; cursor: pointer; transition: all 0.3s; box-shadow: 0 4px 15px rgba(102,126,234,0.3); }
.btn-primary:hover { transform: translateY(-2px); box-shadow: 0 7px 20px rgba(118,75,162,0.4); }
.btn-primary:disabled { background: #ccc; cursor: not-allowed; box-shadow: none; }
.btn-gemini { 
    padding: 12px 28px; 
    background: linear-gradient(45deg, #f97316, #ea580c); /* 주황색 계열 그라데이션 */
    color: white; 
    border: none; 
    border-radius: 50px; 
    font-size: 1.1rem; 
    font-weight: bold; 
    cursor: pointer; 
    transition: all 0.3s; 
    box-shadow: 0 4px 15px rgba(249,115,22,0.3);
}
.btn-gemini:hover { transform: translateY(-2px); box-shadow: 0 7px 20px rgba(234,88,12,0.4); }
.btn-gemini:disabled { background: #ccc; cursor: not-allowed; box-shadow: none; }

.loading-spinner { border: 5px solid #f3f3f3; border-top: 5px solid #667eea; border-radius: 50%; width: 50px; height: 50px; animation: spin 1s linear infinite; margin: 30px auto; }
@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }

.results-container { margin-top: 30px; padding-top: 30px; border-top: 1px solid #e5e7eb; }
.analysis-summary { background: #f3f4f6; border-radius: 10px; padding: 20px; margin-bottom: 25px; }
.summary-title { font-size: 1.2rem; font-weight: 600; margin-bottom: 10px; }
.summary-ingredients { display: flex; flex-wrap: wrap; gap: 8px; }
.ingredient-tag { background: #667eea; color: white; padding: 5px 12px; border-radius: 15px; font-size: 0.9rem; }
.recipe-list { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 20px; }
.recipe-card { background: white; border: 1px solid #e5e7eb; border-radius: 15px; text-decoration: none; color: #333; transition: all 0.3s; overflow: hidden; }
.recipe-card:hover { box-shadow: 0 10px 20px rgba(0,0,0,0.1); transform: translateY(-5px); }
.recipe-image { width: 100%; height: 140px; object-fit: cover; background-color: #f0f0f0; } /* 썸네일 표시 공간 */
.recipe-info { padding: 15px; }
.recipe-name { font-weight: 600; margin-bottom: 5px; }
.recipe-source { font-size: 0.8rem; color: #fff; padding: 3px 8px; border-radius: 10px; display: inline-block; }
.source-db { background: #34d399; }
.source-public { background: #60a5fa; }
.source-gemini { background: #c084fc; }
.button-container { display: flex; justify-content: center; gap: 20px; margin-top: 25px; }
    </style>
</head>
<body>

<div class="container">

    <!-- 제목 및 설명 -->
    <div class="header">
        <h1>🧊 냉장고 재료 종합 분석</h1>
        <p>여러 재료 이미지를 한 번에 업로드하면<br>종합 분석하여 최적의 레시피를 추천해 드립니다.</p>
    </div>

    <!-- 파일 선택을 위한 숨겨진 input -->
    <input type="file" id="file-input" class="file-input" accept="image/*" multiple>

    <!-- 업로드 영역 (드래그 앤 드롭 지원) -->
    <div id="upload-box" class="upload-box">
        <div class="upload-icon">📷</div>
        <div class="upload-text">클릭 또는 이미지를 드래그하여 업로드</div>
        <div class="upload-hint">여러 장의 이미지를 선택할 수 있습니다.</div>
    </div>
    
    <!-- 이미지 미리보기 및 상태 표시 영역 -->
    <div id="image-preview-area" class="image-preview-area"></div>

    <!-- 분석 시작 버튼 -->
    <div class="button-container">
        <button id="analyze-btn" class="btn-primary" style="display: none;">🤖 YOLO & EfficientNet 분석</button>
        
        <button id="gemini-btn" class="btn-gemini" style="display: none;">✨ Gemini Vision 분석</button>
        
    </div>

    <!-- 로딩 스피너 -->
    <div id="loading-spinner" class="loading-spinner" style="display: none;"></div>
    
    <!-- 최종 결과 표시 영역 -->
    <div id="results-container" class="results-container"></div>

</div>

<script>
document.addEventListener('DOMContentLoaded', () => {
	// 1. 모든 요소 변수 선언
    const uploadBox = document.getElementById('upload-box');
    const fileInput = document.getElementById('file-input');
    const previewArea = document.getElementById('image-preview-area');
    const analyzeBtn = document.getElementById('analyze-btn');
    const geminiBtn = document.getElementById('gemini-btn'); // Gemini 버튼 추가
    const spinner = document.getElementById('loading-spinner');
    const resultsContainer = document.getElementById('results-container');
    
    let selectedFiles = []; // 업로드할 파일들을 관리하는 배열

    // 2. 모든 이벤트 리스너 등록
    uploadBox.addEventListener('click', () => fileInput.click());
    uploadBox.addEventListener('dragover', handleDragOver);
    uploadBox.addEventListener('dragleave', handleDragLeave);
    uploadBox.addEventListener('drop', handleDrop);
    fileInput.addEventListener('change', handleFileSelect);
    analyzeBtn.addEventListener('click', () => analyzeImages('hybrid')); // 'hybrid' 모드
    geminiBtn.addEventListener('click', () => analyzeImages('gemini')); // 'gemini' 모드
    previewArea.addEventListener('click', handleRemoveFile);

    // --- 3. 이벤트 핸들러 및 기능 함수 정의 ---

    // 파일 선택/드롭 관련 함수들
    function handleDragOver(e) {
        e.preventDefault();
        uploadBox.classList.add('dragover');
    }
    function handleDragLeave(e) {
        e.preventDefault();
        uploadBox.classList.remove('dragover');
    }
    function handleDrop(e) {
        e.preventDefault();
        uploadBox.classList.remove('dragover');
        addFiles(e.dataTransfer.files);
    }
    function handleFileSelect(e) {
        addFiles(e.target.files);
    }

    // 선택된 파일을 배열에 추가하고 미리보기 업데이트
    function addFiles(files) {
        for (const file of files) {
            if (file.type.startsWith('image/')) {
                selectedFiles.push(file);
            }
        }
        updatePreviews();
    }
    
    function updatePreviews() {
        previewArea.innerHTML = '';
        selectedFiles.forEach((file, index) => {
            const reader = new FileReader();
            reader.onload = (e) => {
                const previewItem = document.createElement('div');
                previewItem.className = 'image-preview-item';

                const img = document.createElement('img');
                img.src = e.target.result;
                img.className = 'preview-img';
                img.alt = file.name;

                const btn = document.createElement('button');
                btn.className = 'remove-btn';
                btn.dataset.index = index;
                btn.type = 'button'; // 기본 submit 동작 방지
                // btn.innerHTML = '×';

                const overlay = document.createElement('div');
                overlay.className = 'status-overlay';

                previewItem.appendChild(img);
                previewItem.appendChild(btn);
                previewItem.appendChild(overlay);
                
                previewArea.appendChild(previewItem);
            };
            reader.readAsDataURL(file);
        });
        analyzeBtn.style.display = selectedFiles.length > 0 ? 'inline-block' : 'none';
        geminiBtn.style.display = selectedFiles.length > 0 ? 'inline-block' : 'none'; // Gemini 버튼도 함께 제어
    }

    // 미리보기에서 파일 제거
    function handleRemoveFile(e) {
        const removeBtn = e.target.closest('.remove-btn');
        if (removeBtn) {
            e.preventDefault(); // 기본 동작 방지
            e.stopPropagation(); // 이벤트 버블링 중단

            const indexToRemove = parseInt(removeBtn.dataset.index, 10);
            if (!isNaN(indexToRemove)) {
                selectedFiles.splice(indexToRemove, 1);
                updatePreviews();
            }
        }
    }

    // 분석 시작 (FastAPI 요청)
    async function analyzeImages(mode) {
        if (selectedFiles.length === 0) {
            alert('분석할 이미지를 선택해주세요.');
            return;
        }
        
     	// --- UI 초기화 및 로딩 시작 ---
        resultsContainer.innerHTML = '';
        document.querySelectorAll('.status-overlay').forEach(el => el.className = 'status-overlay');
        spinner.style.display = 'block';
        analyzeBtn.disabled = true;
        geminiBtn.disabled = true; // 두 버튼 모두 비활성화

     	// --- FormData 생성 ---
        const formData = new FormData();
        selectedFiles.forEach(file => {
            formData.append('files', file);
        });
        
     	// --- ▼▼▼ 모드에 따라 URL 분기 ▼▼▼ ---
        let url = '';
        if (mode === 'hybrid') {
            url = 'http://localhost:8000/analyze/hybrid-recipe';
        } else if (mode === 'gemini') {
            url = 'http://localhost:8000/analyze/gemini-vision';
        } else {
            alert('알 수 없는 분석 모드입니다.');
         	// UI 상태를 원상 복구합니다.
            spinner.style.display = 'none';
            analyzeBtn.disabled = false;
            geminiBtn.disabled = false;
            return; // 함수 실행 종료
        }
        
     	// --- API 요청 및 예외 처리 ---
        try {
            const response = await fetch(url, {
                method: 'POST',
                body: formData,
            });
            
         	// HTTP 상태 코드가 200-299 범위가 아닐 경우 에러 처리
            if (!response.ok) {
                const errorData = await response.json();
                
             	// FastAPI에서 보낸 상세 에러 메시지를 사용
                throw new Error(errorData.detail || '분석 중 서버에서 오류가 발생했습니다.');
            }
            const data = await response.json();
            displayResults(data);
        } catch (error) {
        	// 네트워크 오류 또는 위에서 throw한 에러를 처리
            resultsContainer.innerHTML = `<p style="color: red; text-align: center;">${error.message}</p>`;
        } finally {
        	// --- 로딩 종료 및 UI 상태 복구 ---
            spinner.style.display = 'none';
            analyzeBtn.disabled = false;
            geminiBtn.disabled = false; // 두 버튼 모두 다시 활성화
        }
    }

    // 결과 화면 표시
    function displayResults(data) {
        data.analysis_summary.forEach(summary => {
            const previewItem = Array.from(previewArea.children).find(item =>
                item.querySelector('.preview-img').alt === summary.filename
            );
            if (previewItem) {
                const overlay = previewItem.querySelector('.status-overlay');
                overlay.textContent = summary.status === 'success' ? '✅' : '⚠️';
                overlay.classList.add(summary.status === 'success' ? 'success' : 'failure');
            }
        });

        let html = `
            <div class="analysis-summary">
                <h3 class="summary-title">종합 분석 재료</h3>
                <div class="summary-ingredients">
                    ${data.final_ingredients_ko.map(ing => `<span class="ingredient-tag">${ing}</span>`).join('')}
                </div>
            </div>
        `;
        
        const recipes = data.response.recipes;
        if (recipes && recipes.length > 0) {
            html += '<div class="recipe-list">';
            recipes.forEach(recipe => {
                const source = recipe.source || 'db';
                const sourceClass = `source-${source.toLowerCase()}`;
                const imageUrl = recipe.image_thumbnail_url ? recipe.image_thumbnail_url : `https://via.placeholder.com/250x150.png?text=${encodeURIComponent(recipe.name)}`;
                // const detailUrl = `<c:url value="/recipeDetail?recipeId=${recipe.recipe_id}"/>`; // JSTL을 사용한 URL 생성은 서버에서만 가능

                // JavaScript에서는 절대 경로를 직접 만들어야 합니다.
                html += `
                    <a href="/recipeDetail?recipeId=${recipe.recipe_id}" target="_self" class="recipe-card">
                        <img src="${imageUrl}" class="recipe-image" alt="${recipe.name}">
                        <div class="recipe-info">
                            <div class="recipe-name">${recipe.name}</div>
                            <span class="recipe-source ${sourceClass}">${source}</span>
                        </div>
                    </a>
                `;
            });
            html += '</div>';
        } else {
            html += '<p style="text-align: center;">추천할 만한 레시피를 찾지 못했습니다.</p>';
        }
        resultsContainer.innerHTML = html;
    }
});
</script>

</body>
</html>