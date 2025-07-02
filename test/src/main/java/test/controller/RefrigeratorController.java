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
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.format.annotation.DateTimeFormat;

@CrossOrigin(origins = "http://127.0.0.1:5000/")
@RestController //rest api 처리용 컨트롤러로 스프링이 인식 => @RespondseBody + @Controller
@RequestMapping("/api/refrigerator")
public class RefrigeratorController {

    @Autowired
    private UserRefrigeratorRepository repository;

    // 재료 추가
    @PostMapping
    public ResponseEntity<String> addIngredient(@RequestBody RefrigeratorDto request) {
        UserRefrigerator entity = new UserRefrigerator();
        entity.setUserNo(request.getUserNo());
        entity.setIngredient(request.getIngredient());
        entity.setPurDate(request.getPurDate());
        entity.setUsedCode("0");

        try {
            repository.save(entity);
            return ResponseEntity.ok("재료추가 완료");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("저장 중 오류 발생");
        }
    }

    // 특정 재료 조회 (usedCode optional, 조건별 분기 처리)
    @GetMapping
    public ResponseEntity<List<RefrigeratorResponseDto>> getIngredients(
            @RequestParam long userNo,
            @RequestParam(required = false) String ingredient,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate purDate,
            @RequestParam(required = false) String usedCode) {

        try {
            // 디버깅: 수신된 파라미터 출력
            System.out.println("Received params: userNo=" + userNo + ", ingredient=" + ingredient + 
                              ", purDate=" + purDate + ", usedCode=" + usedCode);

            List<UserRefrigerator> list;

            // 조건 분기 개선
            boolean ingredientValid = ingredient != null && !ingredient.trim().isEmpty();
            boolean purDateValid = purDate != null;
            boolean usedCodeValid = usedCode != null && !usedCode.trim().isEmpty();

            if (ingredientValid && purDateValid && usedCodeValid) {
                list = repository.findByUserNoAndIngredientAndPurDateAndUsedCode(userNo, ingredient.trim(), purDate, usedCode);
            } else if (ingredientValid && purDateValid) {
                list = repository.findByUserNoAndIngredientAndPurDate(userNo, ingredient.trim(), purDate);
            } else if (ingredientValid && usedCodeValid) {
                list = repository.findByUserNoAndIngredientAndUsedCode(userNo, ingredient.trim(), usedCode);
            } else if (purDateValid && usedCodeValid) {
                list = repository.findByUserNoAndPurDateAndUsedCode(userNo, purDate, usedCode);
            } else if (ingredientValid) {
                list = repository.findByUserNoAndIngredient(userNo, ingredient.trim());
            } else if (purDateValid) {
                list = repository.findByUserNoAndPurDate(userNo, purDate);
            } else if (usedCodeValid) {
                list = repository.findByUserNoAndUsedCode(userNo, usedCode);
            } else {
                list = repository.findByUserNo(userNo);
            }

            // 디버깅: 조회된 데이터 출력
            System.out.println("Queried data: " + list);

            List<RefrigeratorResponseDto> response = list.stream()
                    .map(item -> new RefrigeratorResponseDto(item.getIndexNo(), item.getIngredient(), item.getPurDate()))
                    .collect(Collectors.toList());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println("Error in getIngredients: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Collections.emptyList());
        }
    }
    // 나머지 메서드 (addIngredient, updateIngredient, deleteIngredient)는 그대로 유지


    // 재료 수정
    @PutMapping("/{indexNo}")
    public ResponseEntity<String> updateIngredient(@PathVariable Long indexNo, @RequestBody RefrigeratorDto request) {
        Optional<UserRefrigerator> optional = repository.findById(indexNo);

        if (!optional.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("해당 재료를 찾을 수 없습니다.");
        }

        UserRefrigerator entity = optional.get();

        if (request.getIngredient() != null) {
            entity.setIngredient(request.getIngredient());
        }
        if (request.getPurDate() != null) {
            entity.setPurDate(request.getPurDate());
        }
        if (request.getUsedCode() != null && !request.getUsedCode().trim().isEmpty()) {
            entity.setUsedCode(request.getUsedCode());
        }

        try {
            repository.save(entity);
            return ResponseEntity.ok("수정완료");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("수정 중 오류 발생");
        }
    }

    // 재료 삭제
    @DeleteMapping("/{indexNo}")
    public ResponseEntity<String> deleteIngredient(@PathVariable Long indexNo) {
        if (!repository.existsById(indexNo)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("해당 자료를 찾을 수 없습니다.");
        }

        try {
            repository.deleteById(indexNo);
            return ResponseEntity.ok("삭제 완료");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("삭제 중 오류 발생");
        }
    }
}
