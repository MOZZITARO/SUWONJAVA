package test.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import test.dto.userDTO;
import test.service.userService;

@Controller
public class UserController {

	@Autowired
	private userService userService;
	
	
		
	@RequestMapping("/changepw")
	public String changepw(@RequestParam("token") String token, Model model
                       ) {
		model.addAttribute("token", token);
		return "pwchange";
	}
	
	
	@RequestMapping("/newpw")
	public String newpw(@ModelAttribute userDTO userdto
                       ) {
		
		
		int newpw = userService.Changepw(userdto);
		
		
		return "Login";
	}
	
	
	
}
