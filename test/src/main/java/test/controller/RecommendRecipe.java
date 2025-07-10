package test.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
@Controller
public class RecommendRecipe {
	
	@Autowired
	private RestTemplate restTemplate;
	
	
	
	@GetMapping("/user/recipe-history")
	public String showUserRecipeHistory(@RequestParam("user_no") Long user_no, Model model) {
		
		System.out.println("GET /user/recipe-history 사용자 레시피 이력 조회 들어옴");
		
		try {
			String fastApiUrl = "http://localhost:8000/users/" + user_no + "/history";
			
			ResponseEntity<Map> response = restTemplate.getForEntity(fastApiUrl, Map.class);
			System.out.println("response: " + response);
			
			List<Map<String, Object>> historyData = (List<Map<String, Object>>) response.getBody().get("history");
			System.out.println("historyData: " + historyData);
			System.out.println("user_no" + user_no);
			
			model.addAttribute("historyList", historyData);
			model.addAttribute("user_no", user_no);
		} catch (Exception e) {
			System.err.println("사용자 레시피 이력 조회 오류: " + e.getMessage());
			model.addAttribute("error", "사용자 레시피 이력 정보를 가져오는 것을 실패했습니다.");
		}
		
		return "RecommendRecipe";
	}
		
		
	@DeleteMapping("/user/{user_no}/recipe-history/{index_no}")
	@ResponseBody
	public ResponseEntity<String> deleteUserRecipeHistory(
			@PathVariable("user_no") Long user_no, @PathVariable("index_no") Long index_no) {
		
		System.out.println("DELETE /user/{user_no}/recipe-history/{index_no} 사용자 레시피 이력 삭제 들어옴");
		
		try {
			String fastApiUrl ="http://localhost:8000/users/" + user_no + "/history/" + index_no;
			
			// RestTemplate으로 DELETE 요청 보내기
            // exchange() 메소드를 사용하면 DELETE, PUT 등 다양한 HTTP 메소드를 실행할 수 있음
			ResponseEntity<String> fastApiResponse = restTemplate.exchange(fastApiUrl, HttpMethod.DELETE, null, String.class);
			System.out.println("fastApiResponse: " + fastApiResponse);
			
			// FastAPI의 응답을 그대로 클라이언트에게 전달
			return fastApiResponse;
		} catch (HttpClientErrorException e) {
			
			System.err.println("레시피 이력 삭제 오류 (FastAPI): " + e.getResponseBodyAsString()) ;
			return ResponseEntity.status(e.getStatusCode()).body(e.getResponseBodyAsString());
		} catch (Exception e) {
			// 기타 예외 (네트워크 문제 등)
			System.err.println("레시피 이력 삭제 중 서버 오류!" + e.getMessage());
			
			String errorJson = "{\\\"message\\\": \\\"서버 내부 오류로 삭제에 실패했습니다.\\\"}";
			return ResponseEntity.internalServerError().contentType(MediaType.APPLICATION_JSON).body(errorJson);
		}
	}
	
		
//	@GetMapping("/DetailRecipe")
//	public String DetailRecipe() {
//		return "DetailRecipe";
//	}
//	
//	// 이미지분석 상세레시피 입구
//	@PostMapping("/Reciperesult")
//	public String Reciperesult() {
//		return "Reciperesult";
//	}
		
}
