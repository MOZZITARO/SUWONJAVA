package test.service;

import test.dto.userDTO;

public interface userService {

	
	public userDTO loginUserid(String user_id, String user_pw); 
	public int JoinUserid(userDTO userDTO);
}
