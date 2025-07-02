package test.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import test.entity.UserRefrigerator;
import java.time.LocalDate;
import java.util.List;

public interface UserRefrigeratorRepository extends JpaRepository<UserRefrigerator, Long> {

    List<UserRefrigerator> findByUserNo(long userNo);
	
	List<UserRefrigerator> findByUserNoAndIngredientAndPurDateAndUsedCode(long userNo, String ingredient, LocalDate purDate, String usedCode);

    List<UserRefrigerator> findByUserNoAndIngredientAndPurDate(long userNo, String ingredient, LocalDate purDate);

    List<UserRefrigerator> findByUserNoAndIngredientAndUsedCode(long userNo, String ingredient, String usedCode);

    List<UserRefrigerator> findByUserNoAndPurDateAndUsedCode(long userNo, LocalDate purDate, String usedCode);

    List<UserRefrigerator> findByUserNoAndIngredient(long userNo, String ingredient);

    List<UserRefrigerator> findByUserNoAndPurDate(long userNo, LocalDate purDate);

    List<UserRefrigerator> findByUserNoAndUsedCode(long userNo, String usedCode);

  
}
