package test.repository;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import test.entity.UserRefrigerator;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface UserRefrigeratorRepository {

    List<UserRefrigerator> findByUserNoAndUsedCode(
            @Param("userNo") long userNo,
            @Param("usedCode") String usedCode);

    List<UserRefrigerator> findByUserNoAndIngredientAndPurDateAndUsedCode(
            @Param("userNo") long userNo,
            @Param("ingredient") String ingredient,
            @Param("purDate") LocalDate purDate,
            @Param("usedCode") String usedCode);

    List<UserRefrigerator> findByUserNoAndIngredientAndUsedCode(
            @Param("userNo") long userNo,
            @Param("ingredient") String ingredient,
            @Param("usedCode") String usedCode);

    List<UserRefrigerator> findByUserNoAndPurDateAndUsedCode(
            @Param("userNo") long userNo,
            @Param("purDate") LocalDate purDate,
            @Param("usedCode") String usedCode);

    // 단일 조회
    UserRefrigerator selectByIndexNo(@Param("indexNo") long indexNo);

    // 삽입
    int insertUserRefrigerator(UserRefrigerator entity);

    // 수정
    int updateUserRefrigerator(UserRefrigerator entity);

    // 삭제
    int deleteByIndexNo(@Param("indexNo") long indexNo);
}
