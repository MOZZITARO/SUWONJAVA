package test.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import test.controller.User;
import test.dao.UserRepo;
import test.dto.userDTO;

//Service
@Service
@Transactional
public class JoinService {
 
	 @Autowired
	    private UserRepo userRepo;
 
	 
	 // 가입 서비스 구현
	 // 이름이 클래스와 같아야함
 public JoinService(UserRepo userRepo) {
     this.userRepo = userRepo;
 }
 
 public User joinUser(userDTO userDTO) {
	 
     // DTO를 Entity로 변환
     User user = new User();
     user.setUserId(userDTO.getUser_id());
     user.setUserPw(userDTO.getUser_pw());
     user.setUserName(userDTO.getUser_name());
     
     // 저장
     return userRepo.save(user);
 }
 
 // 중복 체크 메서드 추가
 public boolean isUserIdExists(String userId) {
     return userRepo.existsByUserId(userId);
 }
 
}
