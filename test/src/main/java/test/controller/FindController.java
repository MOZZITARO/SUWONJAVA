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
    public String sendVerification(@RequestParam String email, String token, Model model) {
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
    
    
    
    // 비밀번호 변경 프로세스
    @PostMapping("/changeok")
    public String changeok(@RequestParam String token,
                           @RequestParam("newpw") String newpw,
                           @RequestParam("conpw") String conpw,
                           Model model) {
        System.out.println("changepw 들어옴");
        System.out.println("token: " + token);
        System.out.println("✅ 컨트롤러 도착");
        
        System.out.println("새 비번: "+ newpw);
        System.out.println("새 비번 확인: "+ conpw);
        
        try {
        // 1. 토큰 유효성 먼저 검사
        if (!passwordResetService.isTokenValid(token)) {
        	System.out.println("토큰이 이상함");
            model.addAttribute("error", "유효하지 않거나 만료된 토큰입니다.");
            return "Login";
        }

        // 토큰이 null이거나 비어있는지 확인
        if (token == null || token.trim().isEmpty()) {
            System.out.println("❌ 토큰이 null이거나 비어있음");
            model.addAttribute("error", "토큰이 없습니다.");
            return "Login";
        }
        
        System.out.println("=== 비밀번호 변경 프로세스 시작 ===");
        System.out.println("받은 token: [" + token + "]");
        System.out.println("받은 newpw: [" + newpw + "]");
        System.out.println("받은 conpw: [" + conpw + "]");
        
        
        // 2. 사용자 조회
        User user = passwordResetService.getUserByToken(token);
        if (user == null) {
        	System.out.println("에러 잘못된 사용자");
            model.addAttribute("error", "유효하지 않은 사용자입니다.");
            return "Login";
        }

        // 3. 비밀번호와 확인 비밀번호 일치 확인
        if (!newpw.equals(conpw)) {
        	System.out.println("비번 서로 다름");
            model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
            model.addAttribute("token", token); // 다시 입력할 수 있도록 token 유지
            return "pwchange"; // 비밀번호 재입력 페이지로 다시 이동
        }

        // 4. 비밀번호 암호화 및 저장
        System.out.println("원래 비밀번호: " + user.getUserPw());
        String encodedPassword = passwordEncoder.encode(newpw);
        System.out.println("암호화된 비밀번호: " + encodedPassword);
        
        user.setUserPw(encodedPassword);
        userRepo.save(user);
        System.out.println("userRepo.save 완료");
        //userService.Changepw(user);
        
        // 5. 토큰 삭제
        tokenRepository.deleteByTokenId(token);

        model.addAttribute("message", "비밀번호가 성공적으로 변경되었습니다.");
        return "Login";
        
        
        } catch (Exception e) {
            System.out.println("에러 발생!");
            e.printStackTrace(); // 반드시 콘솔에 전체 에러 출력
            model.addAttribute("error", "오류 발생: " + e.getMessage());
            return "Login";
        }
        
    }
    
    
    
    
    
    
      
}
