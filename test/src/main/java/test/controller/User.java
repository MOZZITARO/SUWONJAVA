// User.java
package test.controller;

import java.time.LocalDateTime;
import lombok.Data;
import javax.persistence.*;


// 유저용 엔티티
@Entity
@Table(name = "users")
@Data
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_no") 
    private Long userNo;      

    @Column(name = "user_id", unique = true)
    private String userId;

    @Column(name = "user_pw")
    private String userPw;

    @Column(name = "user_name")
    private String userName;
}


