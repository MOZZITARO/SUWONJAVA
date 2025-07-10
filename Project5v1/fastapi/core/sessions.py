# core/sessions.py
from fastapi import Request


def get_user_no_from_session(request: Request) -> str | None:
    if not request or "user_no" not in request.session:
        return None

    print("세션 ID (get_user_no_from_session):", request.session["user_no"])
    return request.session.get("user_no")
