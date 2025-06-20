package test.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import test.dao.postDAO;
import test.dto.postDTO;

@Service
public class postServiceImpl implements postService {
	
	@Autowired
	postDAO postDao;

	@Override
	public List selectPostSvc(int page, int pageSize, String search) {
		// TODO Auto-generated method stub
		
		int start = (page - 1) * pageSize;
		return postDao.selectPost(start, pageSize, search);
	}

	@Override
	public int selectTotalCountSvc(String search) {
		// TODO Auto-generated method stub
		
		return postDao.selectTotalCount(search);
	}

	@Override
	public int selectTotalPages(int totalCount, int pageSize) {
		// TODO Auto-generated method stub
		return (int) Math.ceil((double) totalCount/pageSize);
	}
	
	@Override
	public int insertPostSvc(postDTO postDto) {
		// TODO Auto-generated method stub
		
		postDto.setReg_date(new Date());
		postDto.setUdt_date(new Date());
		
		int i = postDao.insertPost(postDto);
		return i;
	}

	@Override
	public int updatePostSvc(postDTO postDto) {
		// TODO Auto-generated method stub
		postDto.setUdt_date(new Date());
		int i = postDao.updatePost(postDto);
		return 1;
	}

	@Override
	public int deletePostSvc(Long post_id) {
		// TODO Auto-generated method stub
		return 1;
	}

	@Override
	public postDTO selectPostById(Long post_id) {
		// TODO Auto-generated method stub
		return postDao.selectPostById(post_id);
	}

	@Override
	public int updateViews(Long post_id) {
		// TODO Auto-generated method stub
		int i = postDao.updateViews(post_id);
		return i;
	}

	
}
