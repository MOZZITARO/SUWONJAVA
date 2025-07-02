package test.controller;


import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


import test.dto.userDTO;
import test.service.JoinService;

@Controller
public class JoinController {
    
    private final JoinService joinService;
    private final PasswordEncoder passwordEncoder;
    
    
    // 회원가입 컨트롤러
    public JoinController(JoinService joinService, PasswordEncoder passwordEncoder) {
        this.joinService = joinService;
        this.passwordEncoder = passwordEncoder;
    }
    
    // 회원가입 입구
    @RequestMapping("/joinmain")
    public String joinmain() {
        return "join";
    }
    
    // 회원가입 절차
    @PostMapping("/joinprocess")
    public String join(@ModelAttribute userDTO userDTO, RedirectAttributes redirectAttributes) {
        try {
        	
            // 중복 체크
            if (joinService.isUserIdExists(userDTO.getUser_id())) {
                redirectAttributes.addFlashAttribute("error", "이미 존재하는 아이디입니다.");
                return "redirect:/join";
            }
            
            // 비밀번호 암호화
            String encodedPw = passwordEncoder.encode(userDTO.getUser_pw());
            userDTO.setUser_pw(encodedPw);
            
            // 회원가입 처리
            joinService.joinUser(userDTO);
            
            redirectAttributes.addFlashAttribute("message", "회원가입이 완료되었습니다.");
            return "redirect:/loginmain";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "회원가입 중 오류가 발생했습니다.");
            return "redirect:/joinmain";
        }
        
       
    	
        
    }
}
	

