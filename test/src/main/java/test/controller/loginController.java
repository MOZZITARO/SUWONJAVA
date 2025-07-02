package test.controller;

import java.util.Collections;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import test.dto.userDTO;
import test.dao.userDAO;
import test.service.userService;

@Controller
public class loginController {

	// 에러 플래그
	private static boolean errorLogged = false;

	@Autowired
	private AuthenticationManager authenticationManager;

	@Autowired
	private userService userService;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Autowired
	private userDAO userDAO;

	@GetMapping("/loginmain")
	public String login(HttpServletRequest request) {
//		System.out.println("=== 로그인 페이지 진입 ===");
//	    
//	    HttpSession session = request.getSession(false);
//	    if (session != null) {
//	        System.out.println("⚠️ 로그인 페이지인데 세션이 존재함: " + session.getId());
//	        System.out.println("새 세션인가요? " + session.isNew());
//	    } else {
//	        System.out.println("✅ 세션이 정상적으로 없습니다.");
//	    }
		
			
		return "Login";
	}

	@PostMapping("/Loginaccess")
	public String login(@RequestParam("user_id") String userId, @RequestParam("user_pw") String userPw,
			HttpServletRequest request, RedirectAttributes redirectAttributes) {

		try {
			// 1. 인증 토큰 생성
			UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(userId, userPw);
			System.out.println("토큰 확인용도 : " + authToken);

			// 2. 인증 처리 (UserDetailsService 통해 DB와 대조)
			Authentication authentication = authenticationManager.authenticate(authToken);
			System.out.println("인증 확인용도 : " + authentication);

			// 3. 인증 정보 SecurityContext에 저장
			SecurityContextHolder.getContext().setAuthentication(authentication);

			// 4. 세션에 SecurityContext 저장 (Spring Security용)
			HttpSession session = request.getSession(true);
			UserDetails userDetails = (UserDetails) authentication.getPrincipal();
			session.setAttribute("userInfo", userDetails);
			System.out.println("유저정보확인 : " + userDetails);
			session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY,
					SecurityContextHolder.getContext());
			System.out.println("세션 확인용도 : " + session);
			System.out.println("로그인 성공: " + userId);
			return "redirect:/Main"; 

		} catch (AuthenticationException e) {
			if (!errorLogged) {
				System.out.println("로그인 실패: " + e.getMessage());
				errorLogged = true;
			}
			redirectAttributes.addFlashAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
			return "redirect:/loginmain"; // 실패 시 다시 로그인 페이지
		}
	}

	@GetMapping("/session-check")
	@ResponseBody
	public String checkSession(HttpSession session) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null && auth.isAuthenticated()) {
			return "인증된 사용자: " + auth.getName();
		} else {
			return "인증 안 됨";
		}
	}

	@RequestMapping("/check-session")
	public String checkSession(HttpServletRequest request) {
	    HttpSession session = request.getSession(false);
	    
	    System.out.println("=== 세션 상태 확인 ===");
	    if (session != null) {
	        System.out.println("세션 ID: " + session.getId());
	     
	        System.out.println("세션 유효: " + !session.isNew());
	    } else {
	        System.out.println("세션이 null입니다.");
	    }
	    
	    // 쿠키 확인
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
	        for (Cookie cookie : cookies) {
	            if ("JSESSIONID".equals(cookie.getName())) {
	                System.out.println("JSESSIONID 쿠키 값: " + cookie.getValue());
	                System.out.println("쿠키 경로: " + cookie.getPath());
	                System.out.println("쿠키 도메인: " + cookie.getDomain());
	                System.out.println("쿠키 MaxAge: " + cookie.getMaxAge());
	            }
	        }
	    }
	    
	    return "Login"; // 또는 적절한 뷰
	}
	
	
//	@RequestMapping("/logout")
//	public String logout(HttpServletRequest request) {
//		HttpSession session = request.getSession(false);
//		if (session != null) {
//			session.invalidate();
//			System.out.println("로그아웃되었다면세션이만료되어없어져야겠지 : " + session);
//		}
//		
//		
//		
//		SecurityContextHolder.clearContext();
//		
//		
//		// invalidate 이후 다시 시도해봄
//	    HttpSession checkSession = request.getSession(false);
//	    if (checkSession == null) {
//	        System.out.println("세션이 정상적으로 만료되었습니다.");
//	    } else {
//	        System.out.println("세션이 아직 살아 있습니다! : " + checkSession);
//	    }
//
//		return "redirect:/loginmain";
//	}
	
//	@RequestMapping("/logout")
//	public String logout(HttpServletRequest request) {
//	    HttpSession session = request.getSession(false);
//	    
//	    if (session != null) {
//	        String sessionId = session.getId(); // invalidate 전에 ID 저장
//	        System.out.println("로그아웃 전 세션 ID: " + sessionId);
//	        
//	        session.invalidate();
//	        System.out.println("세션 invalidate 완료 - 세션 ID: " + sessionId);
//	    } else {
//	        System.out.println("로그아웃할 세션이 없습니다.");
//	    }
//
//	    // Spring Security 컨텍스트 클리어
//	    SecurityContextHolder.clearContext();
//
//	    // invalidate 이후 세션 상태 확인
//	    HttpSession checkSession = request.getSession(false);
//	    if (checkSession == null) {
//	        System.out.println("✅ 세션이 정상적으로 만료되었습니다.");
//	    } else {
//	        System.out.println("⚠️ 세션이 아직 살아 있습니다! ID: " + checkSession.getId());
//	        System.out.println("새 세션인지 확인: isNew = " + checkSession.isNew());
//	    }
//
//	    return "redirect:/loginmain";
//	}

	 
//	@PostMapping("/customlogout")
//	public String logout(HttpServletRequest request) {
//	    System.out.println("1. 로그아웃 메서드 시작");
//	    System.out.flush(); // 즉시 출력 강제
//	    
//	    HttpSession session = request.getSession(false);
//	    System.out.println("2. 세션 획득 시도 완료");
//	    
//	    if (session != null) {
//	        System.out.println("3. 세션 존재함: " + session.getId());
//	        session.invalidate();
//	        System.out.println("4. 세션 무효화 완료");
//	    } else {
//	        System.out.println("3. 세션이 null입니다");
//	    }
//	    
//	    System.out.println("5. 메서드 종료");
//	    return "redirect:/loginmain";
//	}
	
	// 완전한 로그아웃 처리
	@RequestMapping("/customlogout")
	public String logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
	    System.out.println("=== 로그아웃 시작 ===");
	    
	    // 1. 기존 세션 확인 및 무효화
	    HttpSession session = request.getSession(false);
	    if (session != null) {
	        String sessionId = session.getId();
	        System.out.println("기존 세션 ID: " + sessionId);
	        
	        
	        try {
	            session.invalidate();
	            System.out.println("세션 무효화 완료: " + sessionId);
	        } catch (IllegalStateException e) {
	            System.out.println("세션이 이미 무효화됨: " + e.getMessage());
	        
	        }
	    }
	    
	    

	    // 2. Spring Security 인증 제거 (중요)
	    if (authentication != null) {
	        new SecurityContextLogoutHandler().logout(request, response, authentication);
	        System.out.println("Spring Security 인증 제거 완료");
	    }

	    // 3. 카카오 로그아웃 URL로 리디렉션
	    String clientId = "9b4c237c90a9730aa699691a34248694"; // Kakao REST API 키
	    String redirectUri = "http://localhost:8080/loginmain"; // 로그아웃 후 이동할 페이지

	    String kakaoLogoutUrl = "https://kauth.kakao.com/oauth/logout?client_id=" + clientId +
	            "&logout_redirect_uri=" + redirectUri;

	    System.out.println("카카오 로그아웃으로 리디렉션: " + kakaoLogoutUrl);

	    return "redirect:" + kakaoLogoutUrl;
	        
	        
	    }
	   
	
	
	
	
	
	// 비밀번호 초기화
	@RequestMapping("/pwreset")
	public String pwreset() {
		return "pwreset";
	}

}
