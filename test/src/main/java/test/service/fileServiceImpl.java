package test.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import test.dao.fileDAO;
import test.dto.fileDTO;



@Service
public class fileServiceImpl implements fileService {

	@Autowired
	fileDAO fileDao;

	@Override
	public List selectFileByPostId(Long post_id) {
		// TODO Auto-generated method stub
		return fileDao.selectFileByPostId(post_id);
	}

	@Override
	public int insertFile(fileDTO fileDto) {
		// TODO Auto-generated method stub
		int i = fileDao.insertFile(fileDto);
		return i;
	}

	@Override
	public fileDTO selectFileById(Long file_id) {
		// TODO Auto-generated method stub
		return fileDao.selectFileById(file_id);
	}

	
}
