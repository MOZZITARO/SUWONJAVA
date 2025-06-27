package test.entity;

import javax.persistence.*;
import java.time.LocalDateTime;
import lombok.Data;


@Data
@Entity
@Table(name="user_ld2")
public class UserFood {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="index_no")
	private Long indexNo;
	
	@Column(name="user_no", nullable=false)
	private Long userNo;
	
	
	@Column(name="food", nullable=false)
	private String food;
	
	
	@Column(name="preference", nullable=false)
	private String preference;
	
	
	
	@Column(name="reg_date", nullable=false)
	private LocalDateTime regDate;
	
	
	
	@Column(name="udt_date", nullable=false)
	private LocalDateTime udtDate;
		
}
