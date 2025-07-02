package test.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

import test.dto.PreferenceDto;
import test.repository.FoodPreferenceRepository;
import test.repository.IngredientPreferenceRepository;
import test.entity.UserFood;
import test.entity.UseIngredient;

@RestController
@RequestMapping("/api/preferences")
public class ReceiptPreferenceController {

    @Autowired
    private FoodPreferenceRepository foodRepo;

    @Autowired
    private IngredientPreferenceRepository ingredientRepo;

    @Transactional
    @PostMapping
    public ResponseEntity<?> savePreferences(@RequestBody PreferenceDto dto) {
        LocalDateTime now = LocalDateTime.now();

        
 
        
        // 선호하는 음식 저장
        if (dto.getLikeFoods() != null) {
            for (String food : dto.getLikeFoods()) {
                UserFood uf = new UserFood();
                uf.setUserNo(dto.getUserNo());
                uf.setFood(food);
                uf.setPreference("1");
                uf.setRegDate(now);
                uf.setUdtDate(now);
                foodRepo.save(uf);
            }
        }

        // 싫어하는 음식 저장
        if (dto.getDislikeFoods() != null) {
            for (String food : dto.getDislikeFoods()) {
                UserFood uf = new UserFood();
                uf.setUserNo(dto.getUserNo());
                uf.setFood(food);
                uf.setPreference("0");
                uf.setRegDate(now);
                uf.setUdtDate(now);
                foodRepo.save(uf);
            }
        }

        // 선호하는 재료 저장
        if (dto.getLikeIngredients() != null) {
            for (String ing : dto.getLikeIngredients()) {
            	UseIngredient ui = new UseIngredient();
                ui.setUserNo(dto.getUserNo());
                ui.setIngredient(ing);
                ui.setPreference("1");
                ui.setRegDate(now);
                ui.setUdtDate(now);
                ingredientRepo.save(ui);
            }
        }

        // 싫어하는 재료 저장
        if (dto.getDislikeIngredients() != null) {
            for (String ing : dto.getDislikeIngredients()) {
            	UseIngredient ui = new UseIngredient(); // ❗클래스명 일치
                ui.setUserNo(dto.getUserNo());
                ui.setIngredient(ing);
                ui.setPreference("0");
                ui.setRegDate(now);
                ui.setUdtDate(now);
                ingredientRepo.save(ui);
            }
        }

        return ResponseEntity.ok("저장 완료");
    }
}
