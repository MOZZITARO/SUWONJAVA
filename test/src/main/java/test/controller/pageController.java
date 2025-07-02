package test.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

@Controller
public class pageController {
	
	@Autowired
	private RestTemplate restTemplate;
	
	
	// 회원 냉장고 flask
	@GetMapping("/inputUserRefrigerator")
	public String proxyFlask1(@RequestParam("user_no") Long user_no, Model model, Authentication auth) {
		System.out.println("inputUserRefrigerator get 접속");
		System.out.println("user_no: " + user_no);
		
		System.out.println("Authentication isAuthenticated: " + (auth != null && auth.isAuthenticated()));
	    System.out.println("Principal: " + auth != null ? auth.getPrincipal() : "null");
		
		String flaskUrl = "http://localhost:5000/inputUserRefrigerator/" + user_no;
        String flaskResponse = restTemplate.getForObject(flaskUrl, String.class);
        System.out.println(">>> Flask HTML response:");
        System.out.println(flaskResponse);
        
        model.addAttribute("flaskContent", flaskResponse);
//        model.addAttribute("user_no", user_no);
        return "Refrigerator"; // Tiles 레이아웃이 적용된 JSP
	}
	
	
	// 회원 선호도 flask
	@GetMapping("/inputUserPreference")
	public String proxyFlask2(@RequestParam("user_no") Long user_no, Model model, Authentication auth) {
		System.out.println("inputUserPreference get 접속");
		System.out.println("user_no: " + user_no);
		
		System.out.println("Authentication isAuthenticated: " + (auth != null && auth.isAuthenticated()));
	    System.out.println("Principal: " + auth != null ? auth.getPrincipal() : "null");
		
		String flaskUrl = "http://localhost:5000/preference/" + user_no;
        String flaskResponse = restTemplate.getForObject(flaskUrl, String.class);
        System.out.println(">>> Flask HTML response:");
        System.out.println(flaskResponse);
        
        model.addAttribute("flaskContent", flaskResponse);
//        model.addAttribute("user_no", user_no);
        return "userPreferemnce"; // Tiles 레이아웃이 적용된 JSP
	}

}
