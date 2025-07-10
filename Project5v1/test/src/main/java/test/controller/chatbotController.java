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
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.List;
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
	
	// user_no와 session_id를 요청 본문에 전달
	@PostMapping(value ="/chat", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody // 이 어노테이션이 '뷰'가 아닌 '데이터'를 반환하도록 만듭니다.
    public ResponseEntity<Object> sendChatMessage(@RequestParam("message") String message, HttpSession session) {
        
        String fastApiUrl = "http://localhost:8000/chat/";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        
        // 세션에서 session_id 가져오기, 없으면 새로 만듦
        String sessionId = (String) session.getAttribute("chat_session_id");
        if(sessionId == null) {
        	sessionId = java.util.UUID.randomUUID().toString();
        	session.setAttribute("chat_session_id", sessionId);
        }
        
        // 세션에서 user_no 가져오기 (로그인한 회원이면 존재)
        String userNo = null;
        Object userObj = session.getAttribute("userInform");
        if(userObj instanceof test.service.CustomUserDetail) {
        	userNo = ((test.service.CustomUserDetail) userObj).getUserno().toString();
        }

        // MultiValueMap<String, String>에 모든 데이터 담기
        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("message", message);
        body.add("session_id", sessionId);
        if(userNo != null) {
        	body.add("user_no", userNo);
        }
        
        // String 세션에서 추천 목록과 인덱스를 가져와서 FastAPI에 전달
        List<Map<String, Object>> recommendations = (List<Map<String, Object>>) session.getAttribute("recipe_recommendations");
        Integer currentIndex = (Integer) session.getAttribute("recommendation_index");
        
        // JSON 문자열로 변환하여 요청 본문에 추가
        try {
        	if(recommendations != null) {
        		body.add("recommendations_json", objectMapper.writeValueAsString(recommendations));
        	}
        	if(currentIndex != null) {
        		body.add("recommendation_index", String.valueOf(currentIndex));
        	}
        } catch (Exception e) {
			// JSON 변환 실패 시 로그 남기기
        	System.err.println("세션 데이터 JSON 변환 실패: " + e.getMessage());
        }
        
        // 제네릭 타입에 오타가 있었습니다. MultiValue-Map -> MultiValueMap
        HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(body, headers);

        try {
            // FastAPI는 JSON 형태의 응답을 주므로, 그대로 받아서 전달합니다.
            ResponseEntity<String> responseFromFastApi = restTemplate.postForEntity(fastApiUrl, requestEntity, String.class);
            System.out.println("responseFromFastApi: " + responseFromFastApi);
            
            Map<String, Object> responseData = objectMapper.readValue(responseFromFastApi.getBody(), Map.class);
            System.out.println("responseData: " + responseData);
            
            // FastAPI가 새로 생성/수정한 추천 목록을 Spring 세션에 저장
            if(responseData.containsKey("new_recommendations")) {
            	// FastAPI가 보낸 새 추천 목록으로 세션을 업데이트
            	List<Map<String, Object>> newRecs = (List<Map<String,Object>>) responseData.get("new_recommendations");
            	session.setAttribute("recipe_recommendations", newRecs);
            }
            if (responseData.containsKey("new_recommendation_index")) {
                // FastAPI가 보낸 새 인덱스로 세션을 업데이트
                session.setAttribute("recommendation_index", responseData.get("new_recommendation_index"));
            }
            
            // FastAPI의 응답을 그대로 클라이언트에게 반환
            return ResponseEntity.ok(responseData); 

        } catch (Exception e) {
            // 에러 발생 시, 프론트엔드가 파싱할 수 있는 JSON 형태의 에러 메시지를 반환
            String errorJson = "{\"message\": \"챗봇 서버 연결에 실패했습니다. 잠시 후 다시 시도해주세요.\", \"recipe\": null}";
            return ResponseEntity.status(500).contentType(MediaType.APPLICATION_JSON).body(errorJson);
        }
    }
	
	// 세션 쿠키를 수동으로 관리
//	@PostMapping(value ="/chat", produces=MediaType.APPLICATION_JSON_VALUE)
//	@ResponseBody // 이 어노테이션이 '뷰'가 아닌 '데이터'를 반환하도록 만듭니다.
//    public ResponseEntity<Object> sendChatMessage(@RequestParam("message") String message, HttpSession session) {
//        
//        String fastApiUrl = "http://localhost:8000/chat/";
//        HttpHeaders headers = new HttpHeaders();
//        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
//        
//        // Spring의 세션 쿠키 이름 가져오기
//        String sessionCookieName = "session.id";
//        
//        // 현재 세션의 쿠기 값 가져오기
//        String sessionCookieValue = (String) session.getAttribute("FASESSION");
//        
//        // RestTemplate 요청 헤더에 쿠키를 추가
//        if(sessionCookieValue != null) {
//        	headers.add("Cookie", "user_no=" + sessionCookieValue);
//        }
//
//        // MultiValueMap<String, String> 타입으로 정확하게 선언합니다.
//        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
//        body.add("message", message);
//
//        // 제네릭 타입에 오타가 있었습니다. MultiValue-Map -> MultiValueMap
//        HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(body, headers);
//
//        try {
//            // FastAPI는 JSON 형태의 응답을 주므로, 그대로 받아서 전달합니다.
//            ResponseEntity<String> responseFromFastApi = restTemplate.postForEntity(fastApiUrl, requestEntity, String.class);
//            System.out.println("responseFromFastApi: " + responseFromFastApi);
//            
//            // FastAPI로부터 받은 세션 쿠키를 Spring 세션에 저장
//            HttpHeaders responseHeaders = responseFromFastApi.getHeaders();
//            if(responseHeaders.containsKey("Set-Cookie")) {
//            	String setCookieHeader = responseHeaders.getFirst("Set-Cookie");
//            	
//            	// 쿠키 값만 파싱
//            	String[] cookieParts = setCookieHeader.split(";")[0].split("=");
//            	if(cookieParts.length > 1) {
//            		session.setAttribute("FASESSION", cookieParts[1]);
//            	}
//            }
//            
//            Map<String, Object> responseData = objectMapper.readValue(responseFromFastApi.getBody(), Map.class);
//            System.out.println("responseData: " + responseData);
//            
//            // FastAPI의 응답을 그대로 클라이언트에게 반환
//            return ResponseEntity.ok(responseData); 
//
//        } catch (HttpClientErrorException e) {
//        	// FastAPI가 4xx, 5xx 에러를 보냈을 때
//        	System.err.println("FastAPI 에러: " + e.getResponseBodyAsString());
//        	return ResponseEntity.status(e.getStatusCode()).body(e.getResponseBodyAsString());
//		  } catch (Exception e) {
//            // 에러 발생 시, 프론트엔드가 파싱할 수 있는 JSON 형태의 에러 메시지를 반환
//            String errorJson = "{\"message\": \"챗봇 서버 연결에 실패했습니다. 잠시 후 다시 시도해주세요.\", \"recipe\": null}";
//            return ResponseEntity.status(500).contentType(MediaType.APPLICATION_JSON).body(errorJson);
//        }
//    }
}
