package test.dto;




import lombok.Data;

import java.time.LocalDate;

@Data
public class RefrigeratorDto {
    private Long indexNo;
    private long userNo; // int -> long
    private String ingredient;
    private String UsedCode;
   
    private LocalDate purDate;

    
}