package test.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class Refrigerator {

	
	
	
	// 비밀번호 초기화
	@RequestMapping("/Refrigerator")
	public String Refrigerator() {
		return "Refrigerator";
	}
	
}
