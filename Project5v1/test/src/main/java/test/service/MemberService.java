package test.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import test.controller.User;
import test.dao.UserRepo;


// 마이페이지 비밀번호 서비스 연결
// dao 연결 및 추가 서비스 구현
@Service
public class MemberService {

    @Autowired
    private UserRepo userRepo;

    public Optional<User> findByUserId(String userId) {
        return userRepo.findByUserId(userId);
    }
    
}