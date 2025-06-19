package test.dto;

import java.util.Date;

import lombok.Data;

@Data
public class commentDTO {
	
	// 댓글 테이블
	private int comment_id;
	private int user_no;
	private int post_id;
	private String content;
	private Date reg_date;
	private Date udt_date;
	
}
