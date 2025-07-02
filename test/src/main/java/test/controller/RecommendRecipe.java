package test.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
@Controller
public class RecommendRecipe {
	
		@GetMapping("/RecommendRecipe")
		public String RecommendRecipe() {
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
