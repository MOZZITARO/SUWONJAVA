package test.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class prefer {

	 // 선호 재료 설정페이지 입구
	@GetMapping("/Prefering")
	public String Prefering() {
	    return "Prefer";
	}
	
	
}
