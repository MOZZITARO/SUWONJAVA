package test.controller;

import test.repository.UserRefrigeratorRepository;
import test.dto.RefrigeratorDto;
import test.dto.RefrigeratorResponseDto;
import test.entity.UserRefrigerator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Map;



import org.springframework.format.annotation.DateTimeFormat;

@RestController
@RequestMapping("/api/refrigerator")
public class RefrigeratorController {



    @Autowired
    private UserRefrigeratorRepository repository;

    @PostMapping
    public ResponseEntity<String> addIngredient(@RequestBody RefrigeratorDto request) {
        UserRefrigerator entity = new UserRefrigerator();
        entity.setUserNo(request.getUserNo());
        entity.setIngredient(request.getIngredient());
        entity.setPurDate(request.getPurDate());
        entity.setUsedCode("0"); // "0" or "N" 등 상황에 맞게 맞추세요.
        entity.setRegDate(LocalDateTime.now());
        entity.setUdtDate(LocalDateTime.now());

        try {
            int inserted = repository.insertUserRefrigerator(entity);
           
            if (inserted > 0) {
                return ResponseEntity.ok("재료추가 완료");
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("재료추가 실패");
            }
        } catch (Exception e) {
           
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("저장 중 오류 발생");
        }
    }


    @GetMapping
    public ResponseEntity<Map<String, Object>> getIngredients(
            @RequestParam long userNo,
            @RequestParam(required = false) String ingredient,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate purDate,
            @RequestParam(defaultValue = "0") String usedCode,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "12") int size) {

        List<UserRefrigerator> list;
        try {
            boolean ingredientValid = ingredient != null && !ingredient.trim().isEmpty();
            boolean purDateValid = purDate != null;

            if (ingredientValid && purDateValid) {
                list = repository.findByUserNoAndIngredientAndPurDateAndUsedCode(userNo, ingredient, purDate, usedCode);
            } else if (ingredientValid) {
                list = repository.findByUserNoAndIngredientAndUsedCode(userNo, ingredient, usedCode);
            } else if (purDateValid) {
                list = repository.findByUserNoAndPurDateAndUsedCode(userNo, purDate, usedCode);
            } else {
                list = repository.findByUserNoAndUsedCode(userNo, usedCode);
            }
        } catch (Exception e) {
            return ResponseEntity.ok(Map.of(
                "content", Collections.emptyList(),
                "totalCount", 0
            ));
        }

        int totalCount = list.size();
        int fromIndex = Math.max(0, (page - 1) * size);
        int toIndex = Math.min(fromIndex + size, totalCount);

        List<RefrigeratorResponseDto> pagedList = list.subList(fromIndex, toIndex).stream()
                .map(item -> new RefrigeratorResponseDto(item.getIndexNo(), item.getIngredient(), item.getPurDate()))
                .collect(Collectors.toList());

        return ResponseEntity.ok(Map.of(
                "content", pagedList,
                "totalCount", totalCount
        ));
    }

    @PutMapping("/{indexNo}")
    public ResponseEntity<String> updateIngredient(@PathVariable Long indexNo, @RequestBody RefrigeratorDto request) {
        UserRefrigerator entity = repository.selectByIndexNo(indexNo);
        if (entity == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("해당 재료를 찾을 수 없습니다.");
        }

        if (request.getIngredient() != null) {
            entity.setIngredient(request.getIngredient());
        }
        if (request.getPurDate() != null) {
            entity.setPurDate(request.getPurDate());
        }
        if (request.getUsedCode() != null && !request.getUsedCode().trim().isEmpty()) {
            entity.setUsedCode(request.getUsedCode());
        }
        entity.setUdtDate(LocalDateTime.now());

        try {
            int updated = repository.updateUserRefrigerator(entity);
            if (updated > 0) {
                return ResponseEntity.ok("수정완료");
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("수정 실패");
            }
        } catch (Exception e) {
          
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("수정 중 오류 발생");
        }
    }

    @DeleteMapping("/{indexNo}")
    public ResponseEntity<String> deleteIngredient(@PathVariable Long indexNo) {
        UserRefrigerator entity = repository.selectByIndexNo(indexNo);
        if (entity == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("해당 자료를 찾을 수 없습니다.");
        }

        try {
            int deleted = repository.deleteByIndexNo(indexNo);
            if (deleted > 0) {
                return ResponseEntity.ok("삭제 완료");
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("삭제 실패");
            }
        } catch (Exception e) {
         
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("삭제 중 오류 발생");
        }
    }
}
