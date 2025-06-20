package test.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import test.dto.fileDTO;

@Repository
public class fileDAOImpl implements fileDAO {
	
	@Autowired
	SqlSession sqlSession;

	@Override
	public List selectFileByPostId(Long post_id) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("test.mapper.boardMapper.selectFileByPostId", post_id);
	}

	@Override
	public int insertFile(fileDTO fileDto) {
		// TODO Auto-generated method stub
		int i = sqlSession.insert("test.mapper.boardMapper.insertFile", fileDto);
		return i;
	}

	@Override
	public fileDTO selectFileById(Long file_id) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("test.mapper.boardMapper.selectFileById", file_id);
	}


	
}
