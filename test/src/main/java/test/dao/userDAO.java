package test.dao;

import test.dto.userDTO;

public interface userDAO {

	public userDTO loginUserid(String user_id); 
	public int JoinUserid(userDTO userDTO);
	public int Changepw(userDTO userDTO);
}
