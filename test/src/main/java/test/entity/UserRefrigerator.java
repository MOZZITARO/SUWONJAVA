package test.entity;

import lombok.Data;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class UserRefrigerator {

    private long indexNo;
    private long userNo;
    private String ingredient;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate purDate;

    private String usedCode;

    private LocalDateTime regDate;
    private LocalDateTime udtDate;

}
