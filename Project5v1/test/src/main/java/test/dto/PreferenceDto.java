package test.dto;

import lombok.Data;
import java.util.List;

@Data
public class PreferenceDto {
	
	private Long userNo;
	private List<String> likeFoods;
	private List<String> dislikeFoods;
	private List<String> likeIngredients;
	private List<String> dislikeIngredients;
	
}
