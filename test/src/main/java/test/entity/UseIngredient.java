package test.entity;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;

@Data
@Entity
@Table(name="user_ld1")
public class UseIngredient {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="index_no")
	private Long indexNo;
	
	@Column(name="user_no", nullable=false)
	private Long userNo;
	
	
	@Column(name="ingredient", nullable=false)
	private String ingredient; 
	
	
	@Column(name="preference", nullable=false)
	private String preference;
	
	
	
	@Column(name="reg_date", nullable=false)
	private LocalDateTime regDate;

	
	
	@Column(name="udt_date", nullable=false)
	private LocalDateTime udtDate;
		
}



