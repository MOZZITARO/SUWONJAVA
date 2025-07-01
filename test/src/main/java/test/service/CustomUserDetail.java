package test.service;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import test.controller.User;

// 커스텀 유저디테일 
public class CustomUserDetail implements UserDetails {

    private final User user;

    public CustomUserDetail(User user) {
        this.user = user;
    }

    public User getUser() {              // ✅ 이 메서드를 꼭 추가해야 함!
        return this.user;
    }
  
    public Long getUserno() {
        return user.getUserNo();
    }
    
    @Override
    public String getUsername() {
        return user.getUserId();
    }

    @Override
    public String getPassword() {
        return user.getUserPw();
    }
    
    public String getName() {
    	
    	
        System.out.println("getNickname 호출됨");
        System.out.println("user 객체: " + user);
        System.out.println("user.getUserName(): " + user.getUserName());
    	
    	
        return user.getUserName();
    }


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_USER")); // 필요한 경우 변경
    }
 
    // 필수
    @Override
    public boolean isAccountNonExpired() {
        return true; // 또는 실제 조건
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
    // 기타 UserDetails 필수 메서드들 생략
}
