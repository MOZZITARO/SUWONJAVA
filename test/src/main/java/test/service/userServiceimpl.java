package test.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import test.dao.userDAO;
import test.dto.userDTO;


@Service
public class userServiceimpl implements userService{

	@Autowired
	userDAO userDao;  
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Override
	public userDTO loginUserid(String user_id, String user_pw) {
		
		
    userDTO login = userDao.loginUserid(user_id);
    
 // 로그인 로직         # {userid}를 넣었을때의 userpw가 일치
    // 조건
    if (login != null && passwordEncoder.matches(user_pw, login.getUser_pw())) {
       // 조건이 일치하면 쿼리 전달
       return login;
    }
//    로그인 실패
    return null;
  }
    
	@Override
	public int JoinUserid(userDTO userDTO) {
		
		
		int Join = userDao.JoinUserid(userDTO);
		return Join;
		
		
	}
}
	

