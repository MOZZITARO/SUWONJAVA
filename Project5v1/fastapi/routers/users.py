# routers/users.py
from fastapi import APIRouter, HTTPException, Path
from fastapi.responses import JSONResponse
import db
from services import recipe_service

router = APIRouter()


# 회원의 레시피 이력 조회
@router.get("/{user_no}/history", summary="사용자 레시피 이력 조회")
async def get_user_history(user_no: int):
    history_list = db.get_user_recipe_history(user_no)
    if history_list is None:
        raise HTTPException(
            status_code=500, detail="사용자 레시피 이력 조회 중 오류 발생"
        )
    return {"history": history_list}


# 회원의 레시피 이력 삭제
@router.delete("/{user_no}/history/{index_no}", summary="회원의 특정 레시피 이력 삭제")
async def delete_user_recipe_history(
    user_no: int = Path(..., title="사용자 번호", ge=1),
    index_no: int = Path(..., title="레시피 이력 번호", ge=1),
):
    """회원의 특정 레시피 추천 이력 삭제"""

    print(f"user_no: {user_no}, index_no: {index_no}")

    delete_count = db.delete_user_recipe_history(user_no, index_no)

    if delete_count == 0:
        raise HTTPException(
            status_code=404,
            detail=f"index_no {index_no}에 해당하는 레시피 이력을 찾을 수 없거나, 삭제할 권한이 없습니다.",
        )

    return JSONResponse(
        status_code=200,
        content={
            "message": f"레시피 이력(index_no {index_no})이 성공적으로 삭제되었습니다."
        },
    )
