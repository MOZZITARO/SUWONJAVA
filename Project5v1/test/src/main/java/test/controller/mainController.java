package test.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class mainController {

	
	
	@RequestMapping("/imageresult")
	public String imageresult(
                       ) {
		
			
		return "imageresult";
	}
	
	
	
	
	
	
	// 로그인 되었을 경우 추가적 절차
//	@RequestMapping("/Mainhome")
//	public String join(
//                       ) {
//		
//		
//		
//		return "Main";
//	}
//	
	// 메인 페이지 매핑 - 로그인/비로그인 모두 접근 가능
	@GetMapping("/Main")
	public String mainPage(HttpServletRequest request, Authentication authentication) {

		request.getSession(false);
		
	    System.out.println("=== Main 페이지 접근 ===");
	    System.out.println("Authentication: " + authentication);
	    System.out.println("Principal: " + (authentication != null ? authentication.getPrincipal() : "null"));
	    System.out.println("Session ID: " + request.getSession().getId());
	    System.out.println("Is Authenticated: " + (authentication != null ? authentication.isAuthenticated() : "false"));

	    // 로그인된 사용자의 경우 추가 처리
	    if (authentication != null && authentication.isAuthenticated()) {
	        Object principal = authentication.getPrincipal();

	        // UserDetails가 맞을 경우에만 세션 저장
	        if (principal instanceof UserDetails) {
	            UserDetails userDetails = (UserDetails) principal;
	            request.getSession().setAttribute("userInform", userDetails);
	            System.out.println("일반 사용자 세션 정보 저장: " + userDetails.getUsername());
	        }
	        
	        // 카카오 사용자 세션 확인 (이미 세션에 저장되어 있을 경우)
	        HttpSession session = request.getSession();
	        Object kakaoUser = session.getAttribute("kakaoUser");
	        if (kakaoUser != null) {
	            System.out.println("카카오 사용자 세션 정보 확인됨");
	        }
	        
	    } else {
	        System.out.println("비로그인 사용자 - 메인 페이지 접근");
	    }

	    return "Main"; // 로그인/비로그인 모두 동일한 메인 페이지로 이동
	}
	
	// 마이페이지 이동
//	@RequestMapping("/memberpage")
//	public String memberpage(
//                       ) {
//		
//		
//		
//		return "memberpage";
//	}
//	
	
	
}
