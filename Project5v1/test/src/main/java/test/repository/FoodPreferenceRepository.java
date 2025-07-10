package test.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import test.entity.UserFood;

public interface FoodPreferenceRepository extends JpaRepository<UserFood, Long> {

	void deleteByUserNo(Long userNo);
	
}
