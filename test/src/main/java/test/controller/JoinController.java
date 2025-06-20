package test.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import test.dao.userDAO;
import test.dto.userDTO;
import test.service.userService;

@Controller
public class JoinController {

	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	private userService userService;
	
	@Autowired 
	private userDAO userDAO;
	
	@RequestMapping("/joinmain")
	public String join(
                       ) {
		
		
		
		return "join";
	}
	
	
	@PostMapping("/joinprocess")
	public String join(@ModelAttribute userDTO userdto
                       ) {
		
		String encodedpw = passwordEncoder.encode(userdto.getUser_pw());
		userdto.setUser_pw(encodedpw);
		
		userService.JoinUserid(userdto);
		
		return "login";
	}
	
	
	
	
	
}
