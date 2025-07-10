# services/image_classifier.py
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import load_model
from PIL import Image
import cv2
import io
import os

# 모델 경로를 프로젝트 루트의 models 폴더 기준으로 설정
MODEL_PATH = os.path.join(
    os.path.dirname(__file__), "..", "models", "efficientnet_b0_best.keras"
)
CLASSES = ["bean", "beef", "carrot"]  # 실제 클래스에 맞게 수정 필요

# 모델 로딩은 main.py에서 수행하고, 여기서는 예측 함수만 정의합니다.
# def letterbox(...), def preprocess_efficientnet(...) 함수들은 그대로 복사


def letterbox(
    img,
    new_shape=(224, 224),
    color=(114, 114, 114),
    auto=False,
    scaleFill=False,
    scaleup=True,
):
    # (기존 코드 그대로 복사)
    shape = img.shape[:2]
    if isinstance(new_shape, int):
        new_shape = (new_shape, new_shape)
    r = min(new_shape[0] / shape[0], new_shape[1] / shape[1])
    if not scaleup:
        r = min(r, 1.0)
    ratio = r, r
    new_unpad = int(round(shape[1] * r)), int(round(shape[0] * r))
    dw, dh = new_shape[1] - new_unpad[0], new_shape[0] - new_unpad[1]
    if auto:
        dw, dh = np.mod(dw, 32), np.mod(dh, 32)
    dw //= 2
    dh //= 2
    if shape[::-1] != new_unpad:
        img = cv2.resize(img, new_unpad, interpolation=cv2.INTER_LINEAR)
    top, bottom = dh, dh
    left, right = dw, dw
    img = cv2.copyMakeBorder(
        img, top, bottom, left, right, cv2.BORDER_CONSTANT, value=color
    )
    return img


def preprocess_efficientnet(img, size=(224, 224)):
    # (기존 코드 그대로 복사)
    img_pil = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
    img_pil = img_pil.resize(size, Image.Resampling.LANCZOS)
    img = np.array(img_pil)
    img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
    return img


# 예측 함수는 로드된 모델 객체를 인자로 받도록 수정합니다.
async def classify_image(model: tf.keras.Model, file):
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("RGB")
    img_np = np.array(image)
    img_cv = cv2.cvtColor(img_np, cv2.COLOR_RGB2BGR)

    img_letterbox = letterbox(img_cv, new_shape=224)
    img_processed = preprocess_efficientnet(img_letterbox, size=(224, 224))
    img_input = tf.keras.applications.efficientnet.preprocess_input(img_processed)
    img_input = np.expand_dims(img_input, axis=0)

    preds = model.predict(img_input, verbose=0)[0]
    top_idx = np.argmax(preds)
    top_prob = float(preds[top_idx])
    top_class = CLASSES[top_idx]

    return {"class": top_class, "prob": top_prob}
