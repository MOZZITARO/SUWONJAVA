package test.service;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import test.dao.UserRepo;

@Service
@Transactional
public class deleteService {
    
    @Autowired
    private UserRepo userRepo;
    
    public void deleteUser(Long userNo) {
    	  
        userRepo.deleteById(userNo); 
    }
}