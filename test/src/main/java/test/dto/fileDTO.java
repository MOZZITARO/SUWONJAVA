package test.dto;

import java.util.Date;

import lombok.Data;

@Data
public class fileDTO {
	
	// 파일 테이블
	private Long file_id;
	private Long user_no;
	private Long post_id;
	private String file_name;
	private String file_path;
	private Long file_size;
	private String file_type;
	private Integer width;
	private Integer heigth;
	private String thumnail_path; 
	private Date reg_date;
	private Date udt_date;
	
}
