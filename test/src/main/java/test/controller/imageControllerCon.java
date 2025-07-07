package test.controller;

import java.io.IOException;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class imageControllerCon {
    private static final Logger logger = LoggerFactory.getLogger(imageControllerCon.class);

    @Autowired
    private RestTemplate restTemplate;

    /**
     * 이미지 파일을 받아 FastAPI 서버로 전송하고, 결과를 받아 리다이렉트하는 메서드 (POST 방식)
     * "Redirect-After-Post" 패턴을 적용하여 폼 중복 제출을 방지
     */
    @PostMapping(value = "/predictImageRecipe")
    public String predictImageRecipe(
            @RequestParam("image") MultipartFile image,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) { // RedirectAttributes: 리다이렉트 시 데이터 전달용

        logger.info("=== 이미지 업로드 요청 받음, 파일명: {}", image.getOriginalFilename());

        if (image.isEmpty()) {
            model.addAttribute("error", "이미지 파일이 선택되지 않았습니다.");
            return "Main"; // 에러 발생 시 Main 페이지로 돌아감
        }

        // FastAPI 서버 URL
        String fastApiUrl = "http://localhost:8000/predict_image_recipe"; // 끝 슬래시 제거

        // 요청 헤더 설정 (Multipart)
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        // 요청 본문(Body) 설정
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        try {
            // MultipartFile을 ByteArrayResource로 변환하여 파일 이름과 함께 추가
            ByteArrayResource resource = new ByteArrayResource(image.getBytes()) {
                @Override
                public String getFilename() {
                    return image.getOriginalFilename();
                }
            };
            body.add("file", resource);
        } catch (IOException e) {
            logger.error("=== 파일 변환 중 오류 발생", e);
            model.addAttribute("error", "파일 처리 중 오류가 발생했습니다: " + e.getMessage());
            return "Main";
        }

        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

        try {
            // FastAPI 서버로 POST 요청 전송
            ResponseEntity<String> response = restTemplate.postForEntity(fastApiUrl, requestEntity, String.class);
            
            logger.info("=== FastAPI 응답 상태 코드: {}", response.getStatusCode());

            if (response.getStatusCode() == HttpStatus.OK) {
                logger.info("=== FastAPI 응답 성공, 결과 페이지로 리다이렉트합니다.");
                
                // 리다이렉트할 페이지로 데이터를 전달하기 위해 RedirectAttributes 사용
                // addFlashAttribute는 1회성 세션처럼 동작하여 리다이렉트 후 바로 사라짐
                redirectAttributes.addFlashAttribute("result", response.getBody());
                
                // 성공 시, GET 방식의 /recipeResult URL로 리다이렉트
                return "redirect:/recipeResult";
                
            } else {
                logger.error("=== FastAPI 서버에서 오류 응답: {}", response.getStatusCode());
                // model을 사용하면 현재 요청에만 데이터가 남음. Main.jsp에 오류 메시지 전달
                model.addAttribute("error", "서버 처리 중 오류가 발생했습니다. 상태 코드: " + response.getStatusCode());
                return "Main"; 
            }
        } catch (Exception e) {
            logger.error("=== FastAPI 서버 요청 실패", e);
            model.addAttribute("error", "외부 서버(AI) 연결에 실패했습니다: " + e.getMessage());
            return "Main";
        }
    }

    /**
     * 레시피 분석 결과를 보여주는 페이지를 렌더링하는 메서드 (GET 방식)
     * predictImageRecipe 메서드에서 리다이렉트된 요청을 받습니다.
     */
    @GetMapping("/recipeResult")
    public String showRecipeResult(Model model) {
        logger.info("=== 레시피 결과 페이지(/recipeResult) 표시 요청");

        // RedirectAttributes로 전달된 데이터는 자동으로 Model에 추가.
        // 따라서 별도의 로직 없이 바로 뷰 이름을 반환
        // 만약 모델에 "result" 속성이 없다면, JSP에서는 '결과 없음'을 표시
        if (!model.containsAttribute("result")) {
            logger.warn("=== 리다이렉트된 결과 데이터('result')가 모델에 없습니다. 메인 페이지로 이동합니다.");
            
             return "redirect:/main";
        }
        
        return "recipeResult"; // /WEB-INF/jsp/recipeResult.jsp 파일을 렌더링
    }
    
}