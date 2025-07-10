package test.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import test.dao.commentDAO;
import test.dto.commentDTO;

@Service
public class commentServiceImpl implements commentService {

	@Autowired
	commentDAO commentDao;

	@Override
	public List selectCommentByPostIdSvc(Long post_id) {
		// TODO Auto-generated method stub
		return commentDao.selectCommentByPostId(post_id);
	}

	@Override
	public int insertCommentSvc(commentDTO commentDto) {
		// TODO Auto-generated method stub
		commentDto.setReg_date(new Date());
		commentDto.setUdt_date(new Date());
		int i = commentDao.insertComment(commentDto);
		return i;
	}

	@Override
	public int updateCommentSvc(commentDTO commentDto) {
		// TODO Auto-generated method stub
		commentDto.setUdt_date(new Date());
		int i = commentDao.updateComment(commentDto);
		return i;
	}

	@Override
	public int deleteCommentSvc(Long comment_id) {
		// TODO Auto-generated method stub
		int i = commentDao.deleteComment(comment_id);
		return i;
	}

	@Override
	public commentDTO selectCommentById(Long comment_id) {
		// TODO Auto-generated method stub
		return commentDao.selectComentById(comment_id);
	}

	
}
