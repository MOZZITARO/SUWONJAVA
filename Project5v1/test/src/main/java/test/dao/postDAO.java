package test.dao;

import java.util.List;

import test.dto.commentDTO;
import test.dto.postDTO;

public interface postDAO {
	
	// 게시글 리스트, 검색 조회
	public List selectPost(int start, int pageSize, String search);
	
	//  전체 게시글 수 조회 
	int selectTotalCount(String search);
	
	// 게시글 작성
	public int insertPost(postDTO postDto);
	
	// 게시글 수정
	public int updatePost(postDTO postDto);
	
	// 게시글 삭제
	public int deletePost(Long post_id);
	
	// 게시글 번호로 조회
	public postDTO selectPostById(Long post_id);
	
	// 게시글 조회수 증가
	public int updateViews(Long post_id);
}
