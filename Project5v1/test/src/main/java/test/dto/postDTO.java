package test.dto;

import java.util.Date;

import lombok.Data;

@Data
public class postDTO {
	
	// 게시판 테이블
	private Long post_id;
	private Long user_no;
	private String category;
	private String title;
	private String content;
	private String author;
	private int views;
	private Date reg_date;
	private Date udt_date;
}
