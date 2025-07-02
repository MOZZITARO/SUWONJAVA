package test.entity;

import javax.persistence.*;
import lombok.Data;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "user_refrigerator")
public class UserRefrigerator {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "index_no")
    private Long indexNo;

    @Column(name = "user_no", nullable = false)
    private Long userNo;

    @Column(name = "ingredient", nullable = false)
    private String ingredient;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    @Column(name = "pur_date")
    private LocalDate purDate;

    @Column(name = "used_code", length = 1)
    private String usedCode;

    @Column(name = "reg_date", updatable = false)
    private LocalDateTime regDate;

    @Column(name = "udt_date")
    private LocalDateTime udtDate;

    @PrePersist
    protected void onCreate() {
        this.regDate = LocalDateTime.now();
        this.udtDate = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.udtDate = LocalDateTime.now();
    }
}
