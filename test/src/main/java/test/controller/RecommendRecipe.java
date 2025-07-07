package test.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
@Controller
public class RecommendRecipe {
	
	@Autowired
	private RestTemplate restTemplate;
	
	
	
	@GetMapping("/user/recipe-history")
	public String showUserRecipeHistory(@RequestParam("user_no") Long user_no, Model model) {
		
		try {
			String fastApiUrl = "http://localhost:8000/history/user/" + user_no;
			
			ResponseEntity<Map> response = restTemplate.getForEntity(fastApiUrl, Map.class);
			System.out.println("response: " + response);
			
			List<Map<String, Object>> historyData = (List<Map<String, Object>>) response.getBody().get("history");
			System.out.println("historyData: " + historyData);
			
			model.addAttribute("historyList", historyData);
		} catch (Exception e) {
			System.err.println("사용자 레시피 이력 조회 오류: " + e.getMessage());
			model.addAttribute("error", "사용자 레시피 이력 정보를 가져오는 것을 실패했습니다.");
		}
		
		return "RecommendRecipe";
	}
		
		
		
		
		@GetMapping("/DetailRecipe")
		public String DetailRecipe() {
			return "DetailRecipe";
		}
		
		// 이미지분석 상세레시피 입구
		@PostMapping("/Reciperesult")
		public String Reciperesult() {
			return "Reciperesult";
		}
		
}
