package test.controller;

import java.util.UUID;

import javax.transaction.Transactional;

import test.dao.PasswordResetTokenRepository;
import test.dao.UserRepo;
import test.service.PasswordResetService;
import test.service.userService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class FindController {

	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
    private PasswordResetService passwordResetService;
	
	@Autowired
    private PasswordResetTokenRepository tokenRepository;
	
	
	@Autowired
	private UserRepo userRepo;
	
	@Autowired
	userService userService;
	
	// 비밀번호 메일 전송 및 변경 컨트롤러
	// 메일 입력 폼 페이지
    @RequestMapping("/findpw")
    public String findpw() {
        return "pwreset";
    }
	
	
	@RequestMapping("/changepw")
	public String changepw(@RequestParam("token") String token, Model model
                       ) {
		model.addAttribute("token", token);
		return "pwchange";
	}
	

    
    // 메일 보내기 로직
    @PostMapping("/send-verification")
    public String sendVerification(@RequestParam String email, String token, Model model,  RedirectAttributes redirectAttributes) {
    	System.out.println("인증확인용 출력");
    	try {
    	
//    		     String tokens = UUID.randomUUID().toString();
//    		     
//    		     boolean result = MailService.mailsender(email, tokens);
//    		     if (result) {
//    		    	    
//    		        } else {
//    		            model.addAttribute("error", "메일 전송에 실패했습니다.");
//    		        }
    		     
    		         User user = userRepo.findByUserId(email)
  	        	    .orElseThrow(() -> {
  	        	        System.out.println("❌ 사용자를 찾을 수 없음");
  	        	        redirectAttributes.addFlashAttribute("error", "사용자 정보를 찾을 수 없습니다.");
  	        	        return new RuntimeException("사용자를 찾을 수 없습니다.");
  	        	    });
    		        
    		
    		
    		
    		
    		
    				passwordResetService.requestPasswordReset(email);
		            model.addAttribute("message", "인증 메일이 전송되었습니다.");
    		
    	 } catch (Exception e) {
    	        e.printStackTrace(); // 구체적인 오류 확인
    	        model.addAttribute("error", "메일 전송 중 오류 발생: " + e.getMessage());
         }
    	
    	
    	return "Login";
    }
    
    
    
    // 비밀번호 재설정 폼 페이지
    @RequestMapping("/modifypw")
    public String modifypw() {
        return "pwchange";
    }
    
    
    
      // 컨트롤러 수정 부분
    @PostMapping("/changeok")
    public String changeok(@RequestParam String token,
                           @RequestParam("newpw") String newpw,
                           @RequestParam("conpw") String conpw,
                           Model model, RedirectAttributes redirectAttributes) {
        System.out.println("changepw 들어옴");
        System.out.println("token: " + token);
        System.out.println("✅ 컨트롤러 도착");
        
        System.out.println("새 비번: "+ newpw);
        System.out.println("새 비번 확인: "+ conpw);
        
        try {
            // 1. 토큰 유효성 먼저 검사
            if (!passwordResetService.isTokenValid(token)) {
                System.out.println("토큰이 이상함");
                redirectAttributes.addFlashAttribute("error", "유효하지 않거나 만료된 토큰입니다.");
                return "redirect:/loginmain"; // redirect로 변경
            }

            // 토큰이 null이거나 비어있는지 확인
            if (token == null || token.trim().isEmpty()) {
                System.out.println("❌ 토큰이 null이거나 비어있음");
                redirectAttributes.addFlashAttribute("error", "토큰이 없습니다.");
                return "redirect:/loginmain"; // redirect로 변경
            }
            
            System.out.println("=== 비밀번호 변경 프로세스 시작 ===");
            System.out.println("받은 token: [" + token + "]");
            System.out.println("받은 newpw: [" + newpw + "]");
            System.out.println("받은 conpw: [" + conpw + "]");
            
            // 2. 사용자 조회
            User user = passwordResetService.getUserByToken(token);
            if (user == null) {
                System.out.println("에러 잘못된 사용자");
                redirectAttributes.addFlashAttribute("error", "유효하지 않은 사용자입니다.");
                return "redirect:/loginmain"; // redirect로 변경
            }

            // 3. 비밀번호와 확인 비밀번호 일치 확인
            if (!newpw.equals(conpw)) {
                System.out.println("비번 서로 다름");
                redirectAttributes.addFlashAttribute("error", "비밀번호가 일치하지 않습니다.");
                return "redirect:/changepw?token=" + token; // redirect로 변경하고 token 파라미터 추가
            }
            
            // 3.5 비밀번호 유효성 검사 추가
            if (newpw.length() < 8) {
                System.out.println("비밀번호 길이 부족");
                redirectAttributes.addFlashAttribute("error", "비밀번호는 8자 이상이어야 합니다.");
                return "redirect:/changepw?token=" + token; // redirect로 변경하고 token 파라미터 추가
            }

            if (!hasUppercase(newpw)) {
                System.out.println("비밀번호에 대문자 없음");
                redirectAttributes.addFlashAttribute("error", "비밀번호에 영어 대문자가 있어야 합니다.");
                return "redirect:/changepw?token=" + token; // redirect로 변경하고 token 파라미터 추가
            }
            
            if (!hasDigit(newpw)) {
                System.out.println("비밀번호에 숫자 없음");
                redirectAttributes.addFlashAttribute("error", "비밀번호에 숫자가 있어야 합니다.");
                return "redirect:/changepw?token=" + token; // redirect로 변경하고 token 파라미터 추가
            }
            
            if (!hasSpecialChar(newpw)) {
                System.out.println("비밀번호에 특수문자 없음");
                redirectAttributes.addFlashAttribute("error", "비밀번호에 특수문자가 있어야합니다.");
                return "redirect:/changepw?token=" + token; // redirect로 변경하고 token 파라미터 추가
            }
            
            // 4. 비밀번호 암호화 및 저장
            System.out.println("원래 비밀번호: " + user.getUserPw());
            String encodedPassword = passwordEncoder.encode(newpw);
            System.out.println("암호화된 비밀번호: " + encodedPassword);
            
            user.setUserPw(encodedPassword);
            userRepo.save(user);
            System.out.println("userRepo.save 완료");
            
            // 5. 토큰 삭제
            tokenRepository.deleteByTokenId(token);

            redirectAttributes.addFlashAttribute("message", "비밀번호가 성공적으로 변경되었습니다.");
            return "redirect:/loginmain"; // redirect로 변경
            
        } catch (Exception e) {
            System.out.println("에러 발생!");
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "오류 발생: " + e.getMessage());
            return "redirect:/loginmain"; // redirect로 변경
        }
    }
    
    
    
    // 비밀번호 유효성 검사 메서드들
    private boolean hasUppercase(String password) {
        for (char c : password.toCharArray()) {
            if (c >= 'A' && c <= 'Z') {
                return true;
            }
        }
        return false;
    }

    private boolean hasDigit(String password) {
        for (char c : password.toCharArray()) {
            if (c >= '0' && c <= '9') {
                return true;
            }
        }
        return false;
    }

    private boolean hasSpecialChar(String password) {
        String specialChars = "!@#$%^&*()_+-=[]{}|;':\",./<>?";
        for (char c : password.toCharArray()) {
            if (specialChars.indexOf(c) != -1) {
                return true;
            }
        }
        return false;
    }
    
    
      
}
