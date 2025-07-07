package test.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Map;

import javax.servlet.http.HttpSession;

@Controller
public class chatbotController {

	@Autowired
	private RestTemplate restTemplate;

	private final ObjectMapper objectMapper = new ObjectMapper();
	
	@GetMapping("/chat")
	public String showChatPage(HttpSession session, Model model) {
		
		System.out.println("챗봇 접속 GET");
		// 세션에서 user_no 가져오기 또는 새로 생성
		String userNo = (String) session.getAttribute("user_no");
		if (userNo == null) {
			userNo = java.util.UUID.randomUUID().toString();
			session.setAttribute("user_no", userNo);
		}
		model.addAttribute("userNo", userNo);
		return "chatbot"; // chatbot.jsp
	}

	@PostMapping(value ="/chat", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody // 이 어노테이션이 '뷰'가 아닌 '데이터'를 반환하도록 만듭니다.
    public ResponseEntity<Object> sendChatMessage(@RequestParam("message") String message) {
        
        String fastApiUrl = "http://localhost:8000/chat/";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        // MultiValueMap<String, String> 타입으로 정확하게 선언합니다.
        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("message", message);

        // 제네릭 타입에 오타가 있었습니다. MultiValue-Map -> MultiValueMap
        HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(body, headers);

        try {
            // FastAPI는 JSON 형태의 응답을 주므로, 그대로 받아서 전달합니다.
            ResponseEntity<String> responseFromFastApi = restTemplate.postForEntity(fastApiUrl, requestEntity, String.class);
            System.out.println("responseFromFastApi: " + responseFromFastApi);
            
            Map<String, Object> responseData = objectMapper.readValue(responseFromFastApi.getBody(), Map.class);
            System.out.println("responseData: " + responseData);
            
            // FastAPI의 응답을 그대로 클라이언트에게 반환
            return ResponseEntity.ok(responseData); 

        } catch (Exception e) {
            // 에러 발생 시, 프론트엔드가 파싱할 수 있는 JSON 형태의 에러 메시지를 반환
            String errorJson = "{\"message\": \"챗봇 서버 연결에 실패했습니다. 잠시 후 다시 시도해주세요.\", \"recipe\": null}";
            return ResponseEntity.status(500).contentType(MediaType.APPLICATION_JSON).body(errorJson);
        }
    }
}
