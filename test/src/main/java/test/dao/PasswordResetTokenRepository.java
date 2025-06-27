package test.dao;

import test.controller.PasswordResetToken;
import org.springframework.data.repository.query.Param;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.Optional;

import javax.transaction.Transactional;

// 토큰 레포지토리
@Repository
public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, Integer> {
		   
        
	    @Query("SELECT p FROM PasswordResetToken p WHERE p.tokenId = :tokenId")
	    Optional<PasswordResetToken> findByTokenId(@Param("tokenId") String tokenId);
	    
	    @Modifying
	    @Transactional
	    @Query("DELETE FROM PasswordResetToken p WHERE p.tokenId = :tokenId")
	    void deleteByTokenId(@Param("tokenId") String tokenId);

	    @Modifying
	    @Transactional
	    @Query("DELETE FROM PasswordResetToken p WHERE p.user.userNo = :userNo")
	    void deleteByUserNo(@Param("userNo") Long userNo); 
	    
	    
    
}
