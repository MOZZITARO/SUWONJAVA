package test.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import test.controller.User;
import test.dao.UserRepo;

    // 유저 레포지토리 서비스 구현
	// 커스텀
	@Service	
	public class CustomService implements UserDetailsService {

	    @Autowired
	    private UserRepo userRepo;

	    @Override
	    public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {
	    	
	        User user = userRepo.findByUserId(userId)
	            .orElseThrow(() -> new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + userId));
	        System.out.println("불러온 사용자 닉네임: " + user.getUserName());
	        return new CustomUserDetail(user);
	    }
	}
	
	
	
	
	
	

