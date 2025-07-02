package test.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
@Controller
public class chatbotController {

	// 비밀번호 초기화
	// 챗봇 입구
		@GetMapping("/chatbot")
		public String chatbot() {
			return "chatbot";
		}
		
		
}
