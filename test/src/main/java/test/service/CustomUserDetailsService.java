package test.service;

import org.springframework.beans.factory.annotation.Autowired;
/*import org.springframework.security.core.userdetails.User;*/
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import test.controller.User;
import test.dao.userDAO;
import test.dto.userDTO;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private userDAO userDao;

//    @Override
//    public UserDetails loadUserByUsername(String user_id) throws UsernameNotFoundException {
//        userDTO user = userDao.loginUserid(user_id);
//        
//        if (user == null) {
//            throw new UsernameNotFoundException("유저를 찾을 수 없습니다: " + user_id);
//        }
//
//        return User.builder()
//                .username(user.getUser_id())
//                .password(user.getUser_pw())  // 인코딩된 비밀번호
//                .roles("USER") // DB에서 권한 컬럼이 있다면 이 부분도 동적으로 처리 가능
//                .accountExpired(false)
//                .accountLocked(false)
//                .credentialsExpired(false)
//                .disabled(false)
//                .build();
//    }
    
    // 커스텀 유저 구현
    @Override
    public UserDetails loadUserByUsername(String user_id) throws UsernameNotFoundException {
        System.out.println("loadUserByUsername 호출됨: " + user_id);
        
        userDTO userDto = userDao.loginUserid(user_id);

        if (userDto == null) {
            System.out.println("DB에서 사용자를 찾을 수 없음: " + user_id);
            throw new UsernameNotFoundException("유저를 찾을 수 없습니다: " + user_id);
        }
        
        // DTO를 Entity로 변환
        User user = new User();
        user.setUserNo(userDto.getUser_no()); // DTO의 필드명에 맞게 수정
        user.setUserId(userDto.getUser_id());
        user.setUserPw(userDto.getUser_pw());
        user.setUserName(userDto.getUser_name());
        
        System.out.println("DB에서 사용자 조회 성공: " + user.getUserName());
        
        
        // CustomUserDetail 반환
        CustomUserDetail customUserDetail = new CustomUserDetail(user);
        System.out.println("CustomUserDetail 생성 완료");
        
        // CustomUserDetail 객체 반환 (중요!)
        return customUserDetail;
    }
    
}
