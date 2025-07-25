package test.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import test.entity.UseIngredient;

public interface IngredientPreferenceRepository extends JpaRepository<UseIngredient, Long> {

	void deleteByUserNo(Long userNo);
}
