package test.service;

import java.util.List;

import test.dto.postDTO;

public interface postService {
	
	// 게시글 리스트, 검색 조회
	public List selectPostSvc(int page, int pageSize, String search);
	
	// 전체 게시글 수 조회
	public int selectTotalCountSvc(String search);
	
	// 전체 페이지 확인
	public int selectTotalPages(int totalCount, int pageSize);
	
	// 게시글 작성
	public int insertPostSvc(postDTO postDto);
	
	// 게시글 수정
	public int updatePostSvc(postDTO postDto);
	
	// 게시글 삭제
	public int deletePostSvc(Long post_id);
	
	// 게시글 번호로 조회
	public postDTO selectPostById(Long post_id);
	
	// 게시글 조회수 증가
	public int updateViews(Long post_id);
}
