package test.dto;

import java.util.Date;

import lombok.Data;

@Data
public class fileDTO {
	
	// 파일 테이블
	private int file_id;
	private int user_no;
	private int post_id;
	private String file_name;
	private String file_path;
	private int file_size;
	private String file_type;
	private int width;
	private int heigth;
	private String thumnail_path; 
	private Date reg_date;
	private Date udt_date;
	
}
