package test.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import test.dto.commentDTO;
import test.dto.postDTO;

@Repository
public class postDAOImpl implements postDAO {
	
	@Autowired
	SqlSession sqlSession;

	@Override
	public List selectPost(int start, int pageSize, String search) {
		// TODO Auto-generated method stub
		
		return sqlSession.selectList("test.mapper.boardMapper.selectPost", new PostSearch(start, pageSize, search));
	}
	
	@Override
	public int selectTotalCount(String search) {
		// TODO Auto-generated method stub
		
		return sqlSession.selectOne("test.mapper.boardMapper.selectPostCount", search);
	}
	
	@Override
	public int insertPost(postDTO postDto) {
		// TODO Auto-generated method stub
		int i = sqlSession.insert("test.mapper.boardMapper.inserPost", postDto);
		
		return i;
	}

	@Override
	public int updatePost(postDTO postDto) {
		// TODO Auto-generated method stub
		int i = sqlSession.update("test.mapper.boardMapper.updatePost", postDto);
		return i;
	}
	// 해야할것 - 댓글 삽입 수정 삭제, 글 삭제, 글 수정, 관리자 기능

	@Override
	public int deletePost(Long post_id) {
		// TODO Auto-generated method stub
		int i = sqlSession.delete("test.mapper.boardMapper.deletePost", post_id);
		return i;
	}
	
	@Override
	public postDTO selectPostById(Long post_id) {
		// TODO Auto-generated method stub
		
		return sqlSession.selectOne("test.mapper.boardMapper.selectPostId", post_id);
		
	}
	
	// 내부 클래스: 검색 조건을 위한 객체
	private static class PostSearch {
		private int start;
		private int pageSize;
		private String search;
		
		public PostSearch(int start, int pageSize, String search) {
			this.start = start;
			this.pageSize = pageSize;
			this.search = search;
		}
 	}

	@Override
	public int updateViews(Long post_id) {
		// TODO Auto-generated method stub
		int i = sqlSession.update("test.mapper.boardMapper.updateViews", post_id);
		return i;
	}

	
	
}
