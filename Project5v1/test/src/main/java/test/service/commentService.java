package test.service;

import java.util.List;

import test.dto.commentDTO;

public interface commentService {
	
	// 해당 게시글의 댓글 조회
	public List selectCommentByPostIdSvc(Long post_id);
	
	// 댓글 작성
	public int insertCommentSvc(commentDTO commentDto);
	
	// 댓글 수정
	public int updateCommentSvc(commentDTO commentDto);
	
	// 댓글 삭제
	public int deleteCommentSvc(Long comment_id);
	
	// 댓글 찾기
	public commentDTO selectCommentById(Long comment_id);
}
