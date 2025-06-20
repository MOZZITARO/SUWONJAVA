package test.dto;

import java.util.Date;

import lombok.Data;

@Data
public class userDTO {

	
	
	private Long user_no;
	private String user_id;
	private String user_pw;
	private String user_name;
	private Date reg_time;
	private Date udt_name;
	private int user_class;
	
	
}
