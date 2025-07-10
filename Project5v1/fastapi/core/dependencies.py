from fastapi import Request, Depends

# 이 함수들은 main.py의 app.state를 사용하므로,
# 라우터 함수 안에서 request 객체를 통해 app.state에 접근해야 합니다.
# 이렇게 하면 main.py에 대한 직접적인 의존성이 사라집니다.


# 의존성 주입(Dependency Injection)을 위한 함수들
def get_yolo_model(request: Request):
    return request.app.state.model_yolo


# 의존성 주입(Dependency Injection)을 위한 함수들
def get_classifier_model(request: Request):
    return request.app.state.model_classifier
