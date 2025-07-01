package test.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class prefer {

	@GetMapping("/Prefering")
	public String Prefering() {
	    return "Prefer";
	}
	
	
}
