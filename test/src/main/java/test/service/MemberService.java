package test.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import test.controller.User;
import test.dao.UserRepo;

@Service
public class MemberService {

    @Autowired
    private UserRepo userRepo;

    public Optional<User> findByUserId(String userId) {
        return userRepo.findByUserId(userId);
    }
}