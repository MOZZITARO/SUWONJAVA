package test.dto;


import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

import java.time.LocalDate;

@Data
public class RefrigeratorResponseDto {

    @JsonProperty("indexNo")
    private Long indexNo;
    
    private String ingredient;

    private String usedCode;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    @JsonProperty("purDate")
    private LocalDate purDate;

    // 기본 생성자 추가
    public RefrigeratorResponseDto() {
    }

    public RefrigeratorResponseDto(Long indexNo, String ingredient, LocalDate purDate) {
        this.indexNo = indexNo;
        this.ingredient = ingredient;
        this.purDate = purDate;
    }

}