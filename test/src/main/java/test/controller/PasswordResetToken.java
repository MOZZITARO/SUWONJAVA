package test.controller;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import lombok.Data;

@Entity
@Table(name = "password_reset_tokens")
@Data
public class PasswordResetToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "token_no")
    private int tokenNo;  // 자바 필드는 camelCase

    @Column(name = "token_id")
    private String tokenId;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false)  // DB 컬럼명
    private User user;

    private LocalDateTime expireDate;
}


