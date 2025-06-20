package test.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import test.TestApplication;
import test.dto.commentDTO;

@Repository
public class commentDAOImpl implements commentDAO{

    private final TestApplication testApplication;
	
	@Autowired
	SqlSession sqlSession;

    commentDAOImpl(TestApplication testApplication) {
        this.testApplication = testApplication;
    }

	@Override
	public List selectCommentByPostId(Long post_id) {
		// TODO Auto-generated method stub
		
		return sqlSession.selectList("test.mapper.boardMapper.selectCommentByPostId", post_id);
	}

	@Override
	public int insertComment(commentDTO commentDto) {
		// TODO Auto-generated method stub
		
		int i = sqlSession.insert("test.mapper.boardMapper.insertComment", commentDto);
		
		return i;
	}

	@Override
	public int updateComment(commentDTO commentDto) {
		// TODO Auto-generated method stub
		
		int i = sqlSession.update("test.mapper.boardMapper.updateComment", commentDto);
		
		return i;
	}

	@Override
	public int deleteComment(Long comment_id) {
		// TODO Auto-generated method stub
		
		int i = sqlSession.delete("test.mapper.boardMapper.deleteComment", comment_id);
		
		return i;
	}

	@Override
	public commentDTO selectComentById(Long comment_id) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("test.mapper.board.selectComentById", comment_id);
	}
}
