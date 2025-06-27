package test.service;

import test.controller.User;
import test.controller.PasswordResetToken;
import test.dao.UserRepo;
import test.dao.PasswordResetTokenRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;


// 비밀번호 변경 서비스 구현 (토큰검증)
@Service
@Transactional
public class PasswordResetService {
    
    @Autowired
    private UserRepo userRepo;
    
    @Autowired
    private MailService mailService;
    
    @Autowired
    private PasswordResetTokenRepository tokenRepository;
    
    public void requestPasswordReset(String UserId) {
        // 이메일로 사용자 조회 (DB 검증)
        Optional<User> userOpt = userRepo.findByUserId(UserId);        
        
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            System.out.println("User: " + user); // 또는 로그로 확인
            
            // 기존 토큰 삭제
            tokenRepository.deleteByUserNo(user.getUserNo());
            
            // 새 토큰 생성
            String token = UUID.randomUUID().toString();
            System.out.println("생성된 토큰" + token);
            // 토큰 저장
            PasswordResetToken resetToken = new PasswordResetToken();
            resetToken.setTokenId(token);
            resetToken.setUser(user);
            resetToken.setExpireDate(LocalDateTime.now().plusHours(1));
            tokenRepository.save(resetToken);
            
            // 이메일 발송
            mailService.mailsender(UserId, token);
        }
        // 이메일이 없어도 예외를 던지지 않음 (보안상 이유)
    }
    public boolean isTokenValid(String token) {
        Optional<PasswordResetToken> resetToken = tokenRepository.findByTokenId(token);
        System.out.println("토큰확인: " + token);
        System.out.println("토큰은 존재하는가 : " + resetToken);
        if (resetToken.isPresent()) {
        	System.out.println("결과"+resetToken.isPresent());
            return resetToken.get().getExpireDate().isAfter(LocalDateTime.now());
        }
        System.out.println("결과" + false);
        return false;
    }
    
    public User getUserByToken(String token) {
        Optional<PasswordResetToken> resetToken = tokenRepository.findByTokenId(token);
        return resetToken.map(PasswordResetToken::getUser).orElse(null);
    }
}
