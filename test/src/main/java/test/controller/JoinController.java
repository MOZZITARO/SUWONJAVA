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
        	
              // 1. 입력값 null 체크 및 기본 검증
            if (userDTO.getUser_name() == null || userDTO.getUser_name().trim().isEmpty()) {
                System.out.println("이름이 입력되지 않았습니다.");
                redirectAttributes.addFlashAttribute("error", "이름을 입력해주세요.");
                return "redirect:/joinmain";
            }
            
            if (userDTO.getUser_id() == null || userDTO.getUser_id().trim().isEmpty()) {
                System.out.println("이메일이 입력되지 않았습니다.");
                redirectAttributes.addFlashAttribute("error", "이메일을 입력해주세요.");
                return "redirect:/joinmain";
            }
            
            if (userDTO.getUser_pw() == null || userDTO.getUser_pw().trim().isEmpty()) {
                System.out.println("비밀번호가 입력되지 않았습니다.");
                redirectAttributes.addFlashAttribute("error", "비밀번호를 입력해주세요.");
                return "redirect:/joinmain";
            }

            // 2. 이름 길이 검증 (3자 이상)
            if (userDTO.getUser_name().trim().length() < 3) {
                System.out.println("이름이 너무 짧습니다.");
                redirectAttributes.addFlashAttribute("error", "이름은 3자 이상이어야 합니다.");
                return "redirect:/joinmain";
            }

            // 3. 이메일 형식 검증
            String emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
            if (!userDTO.getUser_id().matches(emailRegex)) {
                System.out.println("잘못된 이메일 형식입니다.");
                redirectAttributes.addFlashAttribute("error", "올바른 이메일 형식을 입력해주세요.");
                return "redirect:/joinmain";
            }

            // 4. 비밀번호 길이 검증 (8자 이상)
            if (userDTO.getUser_pw().length() < 8) {
                System.out.println("비밀번호가 너무 짧습니다.");
                redirectAttributes.addFlashAttribute("error", "비밀번호는 8자 이상이어야 합니다.");
                return "redirect:/joinmain";
            }

            // 5. 이메일 중복 체크
            if (joinService.isUserIdExists(userDTO.getUser_id())) {
                System.out.println("이미 존재하는 이메일입니다.");
                redirectAttributes.addFlashAttribute("error", "이미 존재하는 이메일입니다.");
                return "redirect:/joinmain";
            }

            // 6. 이름 중복 체크 (필요한 경우)
            if (joinService.isUserNameExists(userDTO.getUser_name())) {
                System.out.println("이미 존재하는 이름입니다.");
                redirectAttributes.addFlashAttribute("error", "이미 존재하는 이름입니다.");
                return "redirect:/joinmain";
            }

            // 7. 비밀번호 암호화
            String encodedPw = passwordEncoder.encode(userDTO.getUser_pw());
            userDTO.setUser_pw(encodedPw);

            // 8. 회원가입 처리
            joinService.joinUser(userDTO);
            System.out.println("회원가입이 완료되었습니다: " + userDTO.getUser_id());
            redirectAttributes.addFlashAttribute("message", "회원가입이 완료되었습니다.");
            return "redirect:/loginmain";

        } catch (Exception e) {
            System.out.println("회원가입 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "회원가입 중 오류가 발생했습니다. 다시 시도해주세요.");
            return "redirect:/joinmain";
        }
        
       
    	
        
    }
}
	

