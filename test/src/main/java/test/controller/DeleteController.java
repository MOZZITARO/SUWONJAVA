package test.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import test.service.MemberService;
import test.service.deleteService;
import test.service.userService;

@Controller
public class DeleteController {

	
	
	    
	    @Autowired
	    private deleteService deleteService;
	    
	    @Autowired
	    private MemberService MemberService;
	    
	    
	    
	    
	 // GET 방식으로 변경 (페이지를 보여주는 것이므로)
	    @GetMapping("/deletep")
	    public String showDeletePage(
	    		Authentication authentication, Model model
	    		) {
	        // 현재 로그인된 사용자 정보를 JSP에 전달
	        if (authentication != null) {
	            String userNo = authentication.getName(); // 또는 다른 방식으로 ID 추출
	            model.addAttribute("userNo", userNo);
	        }
	        return "Delete";
	    }
	    
	

	    
	 // 실제 삭제 처리
	    @PostMapping("/deleteok")
	    public String deleteUser(Authentication authentication, Model model) {
	        try {
	            // 현재 로그인된 사용자와 삭제하려는 사용자가 같은지 확인
//	            String currentUserId = authentication.getName();
//	            if (!currentUserId.equals(userNo)) {
//	                model.addAttribute("error", "본인 계정만 삭제할 수 있습니다.");
//	                return "Delete";
//	            }
	            
	        	   String username = authentication.getName(); // 현재 로그인된 사용자의 username
	               System.out.println("로그인 사용자: " + username);
	               
	               // username으로 userNo 조회
	               Optional<User> optionalUser = MemberService.findByUserId(username); // username은 유니크
	               if (!optionalUser.isPresent()) {
	                   model.addAttribute("error", "사용자 정보를 찾을 수 없습니다.");
	                   return "Delete";
	               }
	        	
	            Long userNo = optionalUser.get().getUserNo(); // 실제 PK
	            deleteService.deleteUser(userNo);
	            
//	            Long parsedUserId = Long.parseLong(userId);
//	            deleteService.deleteUser(parsedUserId);
//	            System.out.println("삭제 요청된 userId: " + userId);
	            
	            // 삭제 후 로그아웃 처리
	            SecurityContextHolder.clearContext();	          
	            return "redirect:/loginmain?deleted=true"; 
	            
//	        } catch (NumberFormatException e) {
//	            model.addAttribute("error", "유효하지 않은 사용자 ID입니다.");
//	            return "Delete";
	        } catch (Exception e) {
	            model.addAttribute("error", "계정 삭제 중 오류가 발생했습니다.");
//	            model.addAttribute("userId", userId);
	            return "Delete";
	        }
	    }
}
	   
 