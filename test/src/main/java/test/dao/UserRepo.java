// UserRepo.java
package test.dao;

import test.controller.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.Optional;


// 유저 레포지토리
// 쿼리문 
@Repository
public interface UserRepo extends JpaRepository<User, Long> {
	
    Optional<User> findByUserId(String userId);
    // 존재 확인
    boolean existsByUserId(String userId);
    
}