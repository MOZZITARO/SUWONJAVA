package test.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;


import test.service.CustomUserDetail;

@Controller
public class imageController {
    private static final Logger logger = LoggerFactory.getLogger(imageController.class);

    @Autowired
    private RestTemplate restTemplate; 

    @PostMapping(value = "/predictImageRecipe11", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public String predictImageRecipe(
            @RequestParam("image") MultipartFile image,
            HttpSession session,
            Model model) {
    	System.out.println("=== 이미지 업로드 요청, 파일명: {}" + image.getOriginalFilename());
        logger.info("=== 이미지 업로드 요청, 파일명: {}", image.getOriginalFilename());

        // FastAPI로 요청 준비
        String fastApiUrl = "http://localhost:8000/predict_image_recipe/";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        
        try {
            body.add("file", new org.springframework.core.io.ByteArrayResource(image.getBytes()) {
                @Override
                public String getFilename() {
                    return image.getOriginalFilename();
                }
            });
        } catch (IOException e) {
            logger.error("=== 파일 변환 실패, 오류: {}", e.getMessage());
            System.out.println("=== 파일 변환 실패, 오류: {}" + e.getMessage());
            model.addAttribute("error", "파일 처리 중 오류가 발생했습니다: " + e.getMessage());
            return "Main"; // 에러 시 Main.jsp로 돌아감
        }

        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

        try {
            // FastAPI 호출
            ResponseEntity<String> response = restTemplate.postForEntity(fastApiUrl, requestEntity, String.class);
            System.out.println("FastAPI 응답 상태: " + response.getStatusCode());
            System.out.println("FastAPI 응답 본문: " + response.getBody());
            if (response.getStatusCode() == HttpStatus.OK) {
                model.addAttribute("result", response.getBody());
                logger.info("=== FastAPI 응답: {}", response.getBody());
                System.out.println("=== FastAPI 응답: {}"+ response.getBody());
                return "recipeResult"; // recipeResult.jsp
            } else {
                model.addAttribute("error", "FastAPI 오류: " + response.getStatusCode());
                return "Main"; // 에러 시 Main.jsp로 돌아감
            }
        } catch (Exception e) {
            logger.error("=== FastAPI 요청 실패, 오류: {}", e.getMessage());
            System.out.println("=== FastAPI 요청 실패, 오류: {}"+ e.getMessage());
            model.addAttribute("error", "서버 연결 실패: " + e.getMessage());
            return "Main"; // 에러 시 Main.jsp로 돌아감
        }
    }
    
    
    @PostMapping("/predictImageRecipe1")
    public String predictImageRecipe1(@RequestParam("image") MultipartFile file, HttpSession session, Model model) {
        Map<String, Object> response = new HashMap<>();
        
        System.out.println("/predictImageRecipe1 post 접속");
        
        try {
        	
        	// 임시 파일 생성
            File tempFile = File.createTempFile("upload-", ".tmp");
            file.transferTo(tempFile); // MultipartFile을 파일로 저장
        	
            String url = "http://localhost:8000/predict_image_recipe/";
            RestTemplate restTemplate = new RestTemplate();
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("file", new FileSystemResource(tempFile));
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
            ResponseEntity<Map> fastApiResponse = restTemplate.exchange(url, HttpMethod.POST, requestEntity, Map.class);
            response.putAll(fastApiResponse.getBody());
            
            // 임시 파일 삭제
            tempFile.deleteOnExit(); // JVM 종료 시 삭제
            
            // response 확인
            System.out.println("response: " + response);
            
            model.addAttribute("result", response);
        } catch (Exception e) {
            model.addAttribute("error", "FastAPI 호출 오류: " + e.getMessage());
        }
        return "Main"; // Main.jsp로 반환
    }
    
    @GetMapping("/recipeDetail")
    public String recipeDetail(@RequestParam("recipeId") int recipeId, HttpSession session, Model model) {
        try {
            String url = "http://localhost:8000/get_recipe_detail";
            
            // 세션에서 사용자 정보(user_no) 가져오기 (세션에 저장된 키 이름에 맞게 수정 필요)
            String userNo = null;
            Object userObj = session.getAttribute("userInform"); // 예시: SecurityContextHolder 등 실제 사용하는 방식에 맞게 변경
            if (userObj instanceof CustomUserDetail) { // 예시 클래스
                userNo = ((CustomUserDetail) userObj).getUsername(); // 또는 고유 ID
            }
            
            // URL에 user_no 파라미터 추가 (회원인 경우에만)
            String finalUrl = url + "?recipe_id=" + recipeId;
            if (userNo != null && !userNo.isEmpty()) {
                finalUrl += "&user_no=" + userNo;
            }
            logger.info("### FastAPI 요청 URL: {}", finalUrl);
            
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<Map> response = restTemplate.getForEntity(finalUrl, Map.class);
            model.addAttribute("recipe", response.getBody());
        } catch (Exception e) {
        	logger.error("레시피 상세 조회 오류: {}", e.getMessage(), e);
            model.addAttribute("error", "레시피 조회 오류: " + e.getMessage());
        }
        return "recipeResult"; // recipeResult.jsp로 이동
    }
   
}
