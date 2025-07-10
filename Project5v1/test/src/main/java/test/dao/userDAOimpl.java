package test.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import test.dto.userDTO;

import org.apache.ibatis.session.SqlSession;

@Repository
public class userDAOimpl implements userDAO{

	@Autowired
	private SqlSession SqlSession;
	
	@Override
	public userDTO loginUserid(String user_id) {
		
		userDTO login = SqlSession.selectOne("Aiproject.Login.UserLogin", user_id); 
		return  login;
	}
	
	@Override
	public int JoinUserid(userDTO userDTO) {
		
		
		int Join = SqlSession.insert("Aiproject.Login.UserJoin", userDTO);
		return Join;
	}
	
	
	//컨텐츠 수정
		@Override
		public 	int Changepw(userDTO userDTO) {
	    int changepw = -1;
			              // selectOne
	    changepw = SqlSession.update("Aiproject.user.changepw", userDTO);
	    System.out.println(" 비밀번호 재설정 : " + changepw);
	    return changepw;
			
		}
	
}
