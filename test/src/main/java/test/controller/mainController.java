package test.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class mainController {

	
	@RequestMapping("/Mainhome")
	public String join(
                       ) {
		
		
		
		return "Main";
	}
	
	
	
	
}
