package test.service;

import java.util.List;

import test.dto.fileDTO;

public interface fileService {
	
	// 게시글 번호로 파일 조회
	public List selectFileByPostId(Long post_id);
		
	// 파일 업로드
	public int insertFile(fileDTO fileDto);
	
	// 파일 번호로 파일 조회
	public fileDTO selectFileById(Long file_id);
	
}
