package test.dao;

import java.util.List;

import test.dto.commentDTO;

public interface commentDAO {
	
	// 해당 게시글에 있는 댓글 조회
	public List selectCommentByPostId(Long post_id);
	
	// 댓글 작성
	public int insertComment(commentDTO commentDto);
	
	// 댓글 수정
	public int updateComment(commentDTO commentDto);
	
	// 댓글 삭제
	public int deleteComment(Long comment_id);
	
	// 댓글 찾기
	public commentDTO selectComentById(Long comment_id);
}
