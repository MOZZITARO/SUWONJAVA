package test.dto;

import java.util.Date;

import lombok.Data;

@Data
public class commentDTO {
	
	// 댓글 테이블
	private Long comment_id;
	private Long user_no;
	private String author;
	private int post_id;
	private String content;
	private Date reg_date;
	private Date udt_date;
	private Long parent_id;
	
}
