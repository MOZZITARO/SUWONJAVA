package test.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import test.dao.userDAO;
import test.dto.userDTO;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private userDAO userDao;

    @Override
    public UserDetails loadUserByUsername(String user_id) throws UsernameNotFoundException {
        userDTO user = userDao.loginUserid(user_id);
        
        if (user == null) {
            throw new UsernameNotFoundException("유저를 찾을 수 없습니다: " + user_id);
        }

        return User.builder()
                .username(user.getUser_id())
                .password(user.getUser_pw())  // 인코딩된 비밀번호
                .roles("USER") // DB에서 권한 컬럼이 있다면 이 부분도 동적으로 처리 가능
                .accountExpired(false)
                .accountLocked(false)
                .credentialsExpired(false)
                .disabled(false)
                .build();
    }
}
