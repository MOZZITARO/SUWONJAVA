package test.controller;

import java.util.Collections;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import test.dto.userDTO;
import test.dao.userDAO;
import test.service.userService;

@Controller
public class loginController {

	@Autowired
	private userService userService;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Autowired
	private userDAO userDAO;

	@GetMapping("/loginmain")
	public String login() {
		System.out.println("로그인접속");
		return "Login";
	}

	@PostMapping("/login")
	public String login(@ModelAttribute userDTO userdto, @RequestParam("user_id") String userId, // 입력한 아이디
			@RequestParam("user_pw") String userPw, // 입력한 비밀번호
			HttpServletRequest request, RedirectAttributes redirectAttributes) { // 세션 객체

		// 객체 생성
		ModelAndView mav = new ModelAndView();

//	        String encodedPassword = passwordEncoder.encode(userPw);
//	        System.out.println("암호화 : " + encodedPassword);
//	        String crypto = userDAO.loginUserid(encodedPassword);

		// 로그인 전 세션 상태 확인
		System.out.println("로그인 전 세션 ID: " + request.getSession(false));

		// 로그인 시도 // 입력값
		userDTO user = userService.loginUserid(userId, userPw);

//	        userDAO users = userDAO.findByUsername(username);  // DB에서 암호화된 비밀번호 포함 조회
//	        if (users == null) {
//	            throw new UsernameNotFoundException("User not found");
//	        }

		

		// 로그인 후 세션 확인
		HttpSession session = request.getSession(true);
		System.out.println("로그인 후 세션 ID: " + session.getId());
		System.out.println("세션 attribute 개수: " + Collections.list(session.getAttributeNames()).size());
		
		
		System.out.println("로그인 암호화 비밀번호 : " + userdto.getUser_pw());
		// 로그인 성공 시
		if (user != null) {
			// 로그인 성공 시 userId와 user 객체를 세션에 저장
			System.out.println("세션 여부" + session.isNew());
			session.setAttribute("user_id", user.getUser_id());
			session.setAttribute("user", user); // 사용자 정보
			session.setAttribute("user_name", user.getUser_name());
			session.setAttribute("user_no", user.getUser_no());
			session.setAttribute("user_class", user.getUser_class());
			System.out.println("세션에 유저정보 등록");
			System.out.println("로그인 성공");

//             if(passwordEncoder.matches(userPw, encodedPassword)) {}

			// !!!! 로그인 성공 시 index 페이지로 리다이렉트
			// "이동할 view" 이름
			// mav.setViewName("redirect:/pwreset");

			return "redirect:/pwreset";
		} else {
			// 로그인 실패 시
			System.out.println("로그인 실패");

			// 로그인 실패 시 로그인 페이지로 리다이렉트
			// mav.setViewName("redirect:/Login");

			// "Model 데이터값" 전달
			// 로그인 창에 표시
			mav.addObject("error", "아이디 또는 비밀번호가 일치하지 않습니다."); // 오류 메시지 추가
			mav.addObject("userId", userId); // 로그인 시도한 아이디 값 다시 전달

			return "redirect:/Login";
		}

		// return mav;
	}

	@GetMapping("/session-check")
	@ResponseBody
	public String checkSession(HttpSession session) {
	    if (session.getAttribute("user_id") != null) {
	        return "세션 존재: " + session.getAttribute("user_id");
	    } else {
	        return "세션 없음";
	    }
	}
	
	@RequestMapping("/logout")
	public String joinout(HttpSession session) {

		// 저장정보 (세션 무효화)
		session.invalidate();

		return "redirect:/Login";

	}

	@RequestMapping("/pwreset")
	public String pwreset() {
		return "pwreset";
	}

}
