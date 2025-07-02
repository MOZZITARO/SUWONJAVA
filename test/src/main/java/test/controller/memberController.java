package test.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import test.dao.UserRepo;

@Controller
public class memberController {

	 // 비밀번호 초기화
	// 마이페이지 이동
	@RequestMapping("/memberpage")
	public String memberpage(
                       ) {
		
		System.out.println("memberpage get 접속");
		
		return "memberpage";
	}
		
		
		
	@Autowired
	private PasswordEncoder passwordEncoder;

	@Autowired
	private UserRepo userRepo;	
	
	// 마이페이지에서 비밀번호 변경 (로그인된 사용자)
	@PostMapping("/mypage-changePassword")
	public String changePasswordFromMypage(@RequestParam("currentPw") String currentPw,
	                                     @RequestParam("newpw") String newpw,
	                                     @RequestParam("conpw") String conpw,
	                                     Authentication authentication,
	                                     Model model,
	                                     RedirectAttributes redirectAttributes) {
	    
	    System.out.println("=== 마이페이지 비밀번호 변경 시작 ===");
	    System.out.println("=== /mypage/changePassword POST 요청 수신 ===");
	    System.out.println("요청 URL 도달 확인");
	    System.out.println("=== 권한 정보 확인 ===");
	    System.out.println("사용자명: " + authentication.getName());
	    System.out.println("권한 목록: " + authentication.getAuthorities());
	    System.out.println("Principal: " + authentication.getPrincipal());
	    
	    try {
	        // 1. 현재 로그인된 사용자 정보 가져오기
	        String currentUserId = authentication.getName();
	        System.out.println("현재 사용자 ID: " + currentUserId);
	        
	        User user = userRepo.findByUserId(currentUserId)
	        	    .orElseThrow(() -> {
	        	        System.out.println("❌ 사용자를 찾을 수 없음");
	        	        redirectAttributes.addFlashAttribute("error", "사용자 정보를 찾을 수 없습니다.");
	        	        return new RuntimeException("사용자를 찾을 수 없습니다.");
	        	    });
	        if (user == null) {
	            System.out.println("❌ 사용자를 찾을 수 없음");
	            redirectAttributes.addFlashAttribute("error", "사용자 정보를 찾을 수 없습니다.");
	            return "redirect:/mypage";
	        }
	        
	        // 2. 현재 비밀번호 확인
	        if (!passwordEncoder.matches(currentPw, user.getUserPw())) {
	            System.out.println("❌ 현재 비밀번호가 일치하지 않음");
	            redirectAttributes.addFlashAttribute("error", "현재 비밀번호가 올바르지 않습니다.");
	            return "redirect:/mypage";
	        }
	        
	        // 3. 새 비밀번호와 확인 비밀번호 일치 확인
	        if (!newpw.equals(conpw)) {
	            System.out.println("❌ 새 비밀번호가 일치하지 않음");
	            redirectAttributes.addFlashAttribute("error", "새 비밀번호가 일치하지 않습니다.");
	            return "redirect:/mypage";
	        }
	        
	        // 4. 새 비밀번호 유효성 검사 (선택사항)
	        if (newpw.length() < 8) {
	            System.out.println("❌ 비밀번호가 너무 짧음");
	            redirectAttributes.addFlashAttribute("error", "비밀번호는 8자 이상이어야 합니다.");
	            return "redirect:/mypage";
	        }
	        
	        // 5. 현재 비밀번호와 새 비밀번호가 같은지 확인
	        if (passwordEncoder.matches(newpw, user.getUserPw())) {
	            System.out.println("❌ 현재 비밀번호와 새 비밀번호가 동일함");
	            redirectAttributes.addFlashAttribute("error", "현재 비밀번호와 다른 새 비밀번호를 입력해주세요.");
	            return "redirect:/mypage";
	        }
	        
	        // 6. 비밀번호 암호화 및 저장
	        String encodedPassword = passwordEncoder.encode(newpw);
	        user.setUserPw(encodedPassword);
	        userRepo.save(user);
	        
	        System.out.println("✅ 비밀번호 변경 완료");
	        redirectAttributes.addFlashAttribute("success", "비밀번호가 성공적으로 변경되었습니다.");
	        return "redirect:/mypage";
	        
	    } catch (Exception e) {
	        System.out.println("❌ 예외 발생: " + e.getMessage());
	        e.printStackTrace();
	        redirectAttributes.addFlashAttribute("error", "비밀번호 변경 중 오류가 발생했습니다.");
	        return "redirect:/mypage";
	    }
	    
	    
	    
	    
	    
	}
	
	
}
