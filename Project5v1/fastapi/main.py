# 2025-07-07 기존 python파일 리팩토링 작업(yolo 모델을 사용한 레시피 추천 폴더) 및 efficientnet 모델을 사용한 레시피 추천 폴더 통합 및 이미지 분석 기능 통합

# main.py
from fastapi import FastAPI, Depends
from starlette.middleware.sessions import SessionMiddleware
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from dotenv import load_dotenv
import torch
import tensorflow as tf
from tensorflow.keras.models import load_model
import uvicorn
import os
import redis
from contextlib import asynccontextmanager

# 새로 만든 라우터들을 import
from routers import recipes, chat, users, image_analysis

# .env 파일 로드
load_dotenv()


# --- 모델 로딩 ---
# 앱의 생명주기(lifespan)를 사용하여 시작 시 모델 로드
# @app.on_event("startup") -- on_event는 사용 중단 예정
async def lifespan_load_models(app: FastAPI):

    print("---Loading models...---")

    # YOLO 모델
    # yolo_path = os.path.join("models", "va_best.pt")
    yolo_path = os.getenv("YOLO_MODEL_PATH")
    app.state.model_yolo = torch.hub.load(
        "ultralytics/yolov5", "custom", path=yolo_path, force_reload=True
    ).to("cpu")
    print("YOLOv5 model loaded.")

    # EfficientNet 모델
    # classifier_path = os.path.join("models", "efficientnet_b0_best.keras")
    classifier_path = os.getenv("CLASSIFIER_MODEL_PATH")
    app.state.model_classifier = load_model(classifier_path)
    print("EfficientNet model loaded.")
    print("--- Models loaded successfully. ---")

    yield  # FastAPI 앱 실행

    # 앱 종료
    print("--- Cleaning up resources... ---")


# --- FastAPI 앱 설정 ---
app = FastAPI(
    title="통합 레시피 추천 API",
    description="YOLO, EfficientNet, Gemini 등 다양한 모델을 사용한 레시피 추천 시스템",
    lifespan=lifespan_load_models,
)

# --- 미들웨어 설정 ---
origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(
    SessionMiddleware,
    secret_key=os.getenv("SECRET_KEY"),  # .env에서 불러오기
    session_cookie="user_no",
    same_site="lax",
)
app.mount("/static", StaticFiles(directory="static"), name="static")

# Redis 클라이언트 (필요 시)
redis_client = redis.Redis(host="localhost", port=6379, decode_responses=True)

# --- 라우터 포함 ---
app.include_router(recipes.router, prefix="/recipes", tags=["DB/Public API Recipes"])
app.include_router(image_analysis.router, prefix="/analyze", tags=["Image Analysis"])
app.include_router(chat.router, prefix="/chat", tags=["Chatbot"])
app.include_router(users.router, prefix="/users", tags=["Users"])


# --- 루트 엔드포인트 ---
@app.get("/", tags=["Root"])
def read_root():
    return {"message": "Welcome to Recipe API"}


# --- 앱 실행 ---
if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
