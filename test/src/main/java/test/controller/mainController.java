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
	// 로그인 되었을 경우 추가적 절차
	@GetMapping("/Main")
	public String mainPage(HttpServletRequest request, Authentication authentication) {
		
		System.out.println("=== Main 페이지 접근 ===");
	    System.out.println("Authentication: " + authentication);
	    System.out.println("Principal: " + (authentication != null ? authentication.getPrincipal() : "null"));
	    System.out.println("Session ID: " + request.getSession().getId());
	    System.out.println("Is Authenticated: " + (authentication != null ? authentication.isAuthenticated() : "false"));
		
//	    HttpSession session = request.getSession();
//	    Object usersession = session.getAttribute("userInfo");
//	    session.setAttribute("userInform", session);
	    
	    if (authentication != null && authentication.isAuthenticated()) {
	        Object principal = authentication.getPrincipal();

	        // UserDetails가 맞을 경우에만 세션 저장
	        if (principal instanceof UserDetails) {
	            UserDetails userDetails = (UserDetails) principal;
	            request.getSession().setAttribute("userInform", userDetails); // ✅ 이걸 저장
	        }
	    }
	    
	    
	    return "Main";  // src/main/webapp/WEB-INF/views/Main.jsp (jsp 설정에 따라)
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
