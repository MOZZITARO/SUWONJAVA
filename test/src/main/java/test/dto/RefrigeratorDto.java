package test.dto;




import lombok.Data;

import java.time.LocalDate;

@Data
public class RefrigeratorDto {
    private Long indexNo;
    private long userNo; 
    private String ingredient;
    private String usedCode;
   
    private LocalDate purDate;

    
}