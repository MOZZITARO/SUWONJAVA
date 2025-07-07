package test.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.core.io.ByteArrayResource;

import java.io.IOException;

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
        model.addAttribute("userNo", user_no);
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
        model.addAttribute("user_no", user_no);
        return "userPreferemnce"; // Tiles 레이아웃이 적용된 JSP
	}
	
	// upload post flask
	@PostMapping("/upload/{user_no}")
	public String uploadFile(@PathVariable("user_no") Long user_no, 
	                        @RequestParam("image") MultipartFile file, 
	                        Model model, Authentication auth) {
		
		System.out.println("Upload POST 접속");
        System.out.println("user_no: " + user_no);
        System.out.println("file: " + file.getOriginalFilename());
        
        try {
            // MultipartFile을 Flask로 전송하기 위한 준비
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("image", new ByteArrayResource(file.getBytes()) {
                @Override
                public String getFilename() {
                    return file.getOriginalFilename();
                }
            });
            
            HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
            
            String flaskUrl = "http://localhost:5000/upload/" + user_no;
            ResponseEntity<String> response = restTemplate.exchange(flaskUrl, HttpMethod.POST, requestEntity, String.class);
            
            if (response.getStatusCode().is2xxSuccessful()) {
                // Flask에서 성공적으로 처리되면 인덱스 페이지로 리다이렉트
                return "redirect:/index?user_no=" + user_no;
            } else {
                model.addAttribute("error", "파일 업로드 실패");
                return uploadPage(user_no, model, auth);
            }
            
        } catch (IOException e) {
            System.err.println("파일 업로드 오류: " + e.getMessage());
            model.addAttribute("error", "파일 업로드 중 오류 발생");
            return uploadPage(user_no, model, auth);
        } catch (Exception e) {
            System.err.println("Flask 통신 오류: " + e.getMessage());
            model.addAttribute("error", "서버 통신 오류");
            return uploadPage(user_no, model, auth);
        }
	}
	
	// upload page GET 요청을 위한 메서드 (위의 POST에서 참조되는 메서드)
	@GetMapping("/upload/{user_no}")
	public String uploadPage(@PathVariable("user_no") Long user_no, Model model, Authentication auth) {
		System.out.println("Upload page GET 접속");
		System.out.println("user_no: " + user_no);
		
		System.out.println("Authentication isAuthenticated: " + (auth != null && auth.isAuthenticated()));
		System.out.println("Principal: " + (auth != null ? auth.getPrincipal() : "null"));
		
		String flaskUrl = "http://localhost:5000/upload/" + user_no;
		String flaskResponse = restTemplate.getForObject(flaskUrl, String.class);
		System.out.println(">>> Flask HTML response:");
		System.out.println(flaskResponse);
		
		model.addAttribute("flaskContent", flaskResponse);
		model.addAttribute("user_no", user_no);
		return "upload"; // Tiles 레이아웃이 적용된 JSP
	}
	
	// confirm POST 요청 처리
	@PostMapping("/confirm/{user_no}")
	public String confirmSubmit(@PathVariable("user_no") Long user_no,
	                           @RequestParam("ingredient") String ingredient,
	                           @RequestParam("purDate") String purDate,
	                           Model model, Authentication auth) {
		System.out.println("Confirm POST 접속");
		System.out.println("user_no: " + user_no);
		System.out.println("ingredient: " + ingredient);
		System.out.println("purDate: " + purDate);
		
		try {
			// form 데이터를 Flask로 전송하기 위한 준비
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
			
			MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
			body.add("ingredient", ingredient);
			body.add("purDate", purDate);
			
			HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(body, headers);
			
			String flaskUrl = "http://localhost:5000/confirm/" + user_no;
			ResponseEntity<String> response = restTemplate.exchange(flaskUrl, HttpMethod.POST, requestEntity, String.class);
			
			if (response.getStatusCode().is2xxSuccessful()) {
				// Flask에서 성공적으로 처리되면 인덱스 페이지로 리다이렉트
				return "redirect:/index?user_no=" + user_no;
			} else {
				model.addAttribute("error", "데이터 저장 실패");
				return confirmPage(user_no, model, auth);
			}
			
		} catch (Exception e) {
			System.err.println("Flask 통신 오류: " + e.getMessage());
			model.addAttribute("error", "서버 통신 오류");
			return confirmPage(user_no, model, auth);
		}
	}
	
	// confirm page GET 요청을 위한 메서드
	@GetMapping("/confirm/{user_no}")
	public String confirmPage(@PathVariable("user_no") Long user_no, Model model, Authentication auth) {
		System.out.println("Confirm page GET 접속");
		System.out.println("user_no: " + user_no);
		
		System.out.println("Authentication isAuthenticated: " + (auth != null && auth.isAuthenticated()));
		System.out.println("Principal: " + (auth != null ? auth.getPrincipal() : "null"));
		
		String flaskUrl = "http://localhost:5000/confirm/" + user_no;
		String flaskResponse = restTemplate.getForObject(flaskUrl, String.class);
		System.out.println(">>> Flask HTML response:");
		System.out.println(flaskResponse);
		
		model.addAttribute("flaskContent", flaskResponse);
		model.addAttribute("user_no", user_no);
		return "confirm"; // Tiles 레이아웃이 적용된 JSP
	}
}