package test.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
import test.service.CustomUserDetail;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import java.io.IOException;

@Component
public class CustomLoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, 
                                        HttpServletResponse response,
                                        Authentication authentication) 
                                        throws IOException, ServletException {
    	try {
            HttpSession session = request.getSession(true); // 세션이 없으면 생성
            Object principal = authentication.getPrincipal();
            
            if (principal instanceof CustomUserDetail) {
                User user = ((CustomUserDetail) principal).getUser();
                if (user != null) {
                    session.setAttribute("user", user);
                    session.setAttribute("nickname", user.getUserName());
                    System.out.println("로그인 성공 후 세션에 user 저장: " + user.getUserName());
                } else {
                    System.out.println("User 객체가 null입니다.");
                }
            } else {
                System.out.println("Authentication principal 타입: " + 
                    (principal != null ? principal.getClass().getName() : "null"));
            }
        } catch (Exception e) {
            System.err.println("세션 설정 중 오류 발생: " + e.getMessage());
        }

        // 기본 로그인 성공 후 리다이렉트 URL 실행
        super.onAuthenticationSuccess(request, response, authentication);
    }
}