package test.controller;

import javax.servlet.http.HttpSession;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class kakaoController {

	 @RequestMapping("/home")
	    public String dashboard(Authentication authentication, Model model,  HttpServletRequest request) {
		 
		 
//		    HttpSession session = request.getSession();
//		    OAuth2User kakaoUser = (OAuth2User) session.getAttribute("kakaoUser");
//
//		    if (kakaoUser != null) {
//		        Map<String, Object> attributes = kakaoUser.getAttributes();
//		        String nickname = null;
//
//		        // 1. properties.nickname
//		        if (attributes.get("properties") instanceof Map) {
//		            Map<String, Object> properties = (Map<String, Object>) attributes.get("properties");
//		            nickname = (String) properties.get("nickname");
//		            System.out.println("닉네임: " + nickname);
//		        }
//
//		        // 2. kakao_account.profile.nickname
//		        if ((nickname == null || nickname.isEmpty()) && attributes.get("kakao_account") instanceof Map) {
//		            Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");
//		            if (kakaoAccount.get("profile") instanceof Map) {
//		                Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
//		                nickname = (String) profile.get("nickname");
//		                System.out.println("닉네임: " + nickname);
//		            }
//		        }
//
//		        // fallback
//		        if (nickname == null) {
//		            nickname = "닉네임 없음";
//		        }
//		        System.out.println("닉네임: " + nickname);
//		        model.addAttribute("nickname", nickname);
//		    }
		 
		 
		 
//	        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
//	        
//	        // 사용자 정보 세션에 저장
//	        HttpSession session = request.getSession();
//	        session.setAttribute("kakaoUser", oAuth2User);
//	        
//	        model.addAttribute("user", oAuth2User.getAttributes());
		 
	        
	        
	        
//		    HttpSession session = request.getSession();
//		    OAuth2User kakaoUser = (OAuth2User) session.getAttribute("kakaoUser");
//		    
//		    if (kakaoUser != null) {
//		        // 전체 속성 출력해서 구조 확인
//		        System.out.println("=== 카카오 사용자 전체 정보 ===");
//		        System.out.println(kakaoUser.getAttributes());
//		        
//		        // properties 확인
//		        Map<String, Object> properties = (Map<String, Object>) kakaoUser.getAttribute("properties");
//		        System.out.println("=== properties ===");
//		        System.out.println(properties);
//		        
//		        // kakao_account 확인 (닉네임이 여기 있을 수도 있음)
//		        Map<String, Object> kakaoAccount = (Map<String, Object>) kakaoUser.getAttribute("kakao_account");
//		        System.out.println("=== kakao_account ===");
//		        System.out.println(kakaoAccount);
//		        
//		        if (kakaoAccount != null) {
//		            Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
//		            System.out.println("=== profile ===");
//		            System.out.println(profile);
//		        }
//		        
//		        model.addAttribute("userInfo", kakaoUser.getAttributes());
//		    } else {
//		        System.out.println("세션에 kakaoUser가 없습니다.");
//		    }
//	        
	        
		 HttpSession session = request.getSession();

		    if (authentication != null && authentication.isAuthenticated()) {
		        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
		        session.setAttribute("kakaoUser", oAuth2User); // ✅ 세션에 저장

		        // 디버깅 출력 (선택)
		        System.out.println("=== /home 진입: kakaoUser 세션 저장 ===");
		        System.out.println(oAuth2User.getAttributes());
		    } else {
		        System.out.println("인증 정보 없음 또는 인증되지 않음.");
		    }
	        
	        return "redirect:/kakaoMain";
	        
	    }
	 
	 
	 // 위 return과 매핑
	 @RequestMapping("/kakaoMain")
		public String kakaoMain(Model model,  HttpServletRequest request
	                       ) {
				
		 
//		 
//		 HttpSession session = request.getSession();
//		    OAuth2User kakaoUser = (OAuth2User) session.getAttribute("kakaoUser");
//
//		    if (kakaoUser != null) {
//		        Map<String, Object> attributes = kakaoUser.getAttributes();
//		        String nickname = null;
//
//		        // 1. properties.nickname
//		        if (attributes.get("properties") instanceof Map) {
//		            Map<String, Object> properties = (Map<String, Object>) attributes.get("properties");
//		            nickname = (String) properties.get("nickname");
//		            System.out.println("닉네임: " + nickname);
//		        }
//
//		        // 2. kakao_account.profile.nickname
//		        if ((nickname == null || nickname.isEmpty()) && attributes.get("kakao_account") instanceof Map) {
//		            Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");
//		            if (kakaoAccount.get("profile") instanceof Map) {
//		                Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
//		                nickname = (String) profile.get("nickname");
//		                System.out.println("닉네임: " + nickname);
//		            }
//		        }
//
//		        // fallback
//		        if (nickname == null) {
//		            nickname = "닉네임 없음";
//		        }
//		        System.out.println("닉네임: " + nickname);
//		        model.addAttribute("nickname", nickname);
//		    }
//		 
	        
	        
//			 HttpSession session = request.getSession();
//			    OAuth2User kakaoUser = (OAuth2User) session.getAttribute("kakaoUser");
//			    
//			    if (kakaoUser != null) {
//			        // 전체 속성 출력해서 구조 확인
//			        System.out.println("=== 카카오 사용자 전체 정보 ===");
//			        System.out.println(kakaoUser.getAttributes());
//			        
//			        // properties 확인
//			        Map<String, Object> properties = (Map<String, Object>) kakaoUser.getAttribute("properties");
//			        System.out.println("=== properties ===");
//			        System.out.println(properties);
//			        
//			        // kakao_account 확인 (닉네임이 여기 있을 수도 있음)
//			        Map<String, Object> kakaoAccount = (Map<String, Object>) kakaoUser.getAttribute("kakao_account");
//			        System.out.println("=== kakao_account ===");
//			        System.out.println(kakaoAccount);
//			        
//			        if (kakaoAccount != null) {
//			            Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
//			            System.out.println("=== profile ===");
//			            System.out.println(profile);
//			        }
//			        
//			        model.addAttribute("userInfo", kakaoUser.getAttributes());
//			    } else {
//			        System.out.println("세션에 kakaoUser가 없습니다.");
//			    }
		 
		 
		    HttpSession session = request.getSession();
		    OAuth2User kakaoUser = (OAuth2User) session.getAttribute("kakaoUser");

		    if (kakaoUser != null) {
		        Map<String, Object> attributes = kakaoUser.getAttributes();
		        // 닉네임 추출 로직 생략
		        model.addAttribute("kakaoUser", attributes);
		    } else {
		        System.out.println("세션에 kakaoUser가 없습니다."); // 🔥 지금 이 상태
		    }
		 
			return "Main";
		}
	 
		
}
