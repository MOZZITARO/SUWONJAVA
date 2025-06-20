package test.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.List;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import test.dto.commentDTO;
import test.dto.fileDTO;
import test.dto.postDTO;
import test.service.commentService;
import test.service.fileService;
import test.service.postService;



@Controller
public class boardController {
	
	@Autowired
	postService postService;
	
	@Autowired
	fileService fileService;
	
	@Autowired
	commentService commentService;
	
	// 게시판
	@RequestMapping("/board")
	public String board(
			@RequestParam(defaultValue = "1") int page,
			@RequestParam(required = false) String search,
			Model model
			) {
		int pageSize = 10;
		List posts = postService.selectPostSvc(page, pageSize, search);
		int totalCount = postService.selectTotalCountSvc(search);
		int totalPages = postService.selectTotalPages(totalCount, pageSize);
		
		model.addAttribute("post", posts);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("totalCount", totalCount);
		
		return "board";
	}
	
	
	// 글쓰기 페이지
	@GetMapping("/board/write")
	public String showWriteForm(Model model, HttpSession session) {
		
		Long user_no = (Long) session.getAttribute("user_no");
		if(user_no == null) {
			return "redirect:/login";
		}
		model.addAttribute("post", new postDTO());
		return "write";
	}
	
	// 글쓰기
	@PostMapping("/board/write")
	public String submitPost(
			@ModelAttribute postDTO postDto,
			@RequestParam("file") MultipartFile[] files,
			@RequestParam("image") MultipartFile[] images,
			HttpSession session,
			Model model
			) throws IOException {
		Long user_no = (Long) session.getAttribute("user_no");
		String author = (String) session.getAttribute("user_name");
		Integer user_class = (Integer) session.getAttribute("user_class");
		
		if (user_no == null) {
			return "redirect:/login";
		}
		
		if(user_class != 1 && "공지".equals(postDto.getCategory())) {
			System.out.println("일반 사용자가 공지 작성할 수 없음!");
			return "redirect:/post/write?error=onlyAdminCanPostNotice";
		}
		
		postDto.setUser_no(user_no);
		postDto.setAuthor(author); // 세션에서 사용자 이름 가져오기
		postDto.setViews(0);
		postDto.setReg_date(new Date());
		postDto.setUdt_date(new Date());
		
		postService.insertPostSvc(postDto);
		
		String uploadDir = ""; // 파일 경로

		// 파일 업로드 처리
		if (files != null && files.length > 0) {
			
			for (MultipartFile file : files) {
				if (!file.isEmpty()) {
					String fileName = file.getOriginalFilename();
					Path filePath = Paths.get(uploadDir + File.separator + "files" + File.separator + fileName);
					Files.createDirectories(filePath.getParent());
					file.transferTo(filePath.toFile());
					
					fileDTO fileDto = new fileDTO();
					fileDto.setUser_no(user_no);
					fileDto.setPost_id(postDto.getPost_id());
					fileDto.setFile_name(fileName);
					fileDto.setFile_path(filePath.toString());
					fileDto.setFile_size(file.getSize());
					fileDto.setFile_type("document");
					fileService.insertFile(fileDto);
				}
			}
		}
		
		// 이미지 업로드 처리
		if (images != null && images.length > 0) {
			for (MultipartFile image : images) {
                if (!image.isEmpty()) {
                    String imageName = image.getOriginalFilename();
                    Path imagePath = Paths.get(uploadDir + File.separator + "images" + File.separator + imageName);
                    Files.createDirectories(imagePath.getParent());
                    image.transferTo(imagePath.toFile());
                  
                    // 이미지 크기 및 썸네일 생성
                    BufferedImage bimg = ImageIO.read(image.getInputStream());
                    int width = bimg.getWidth();
                    int height = bimg.getHeight();
                    //String thumbnailPath = imagePath.toString().replace(".jpg", "_thumb.jpg");
                    
                    fileDTO fileDto = new fileDTO();
					fileDto.setUser_no(user_no);
					fileDto.setPost_id(postDto.getPost_id());
					fileDto.setFile_name(imageName);
					fileDto.setFile_path(imagePath.toString());
					fileDto.setFile_size(image.getSize());
					fileDto.setFile_type("image");
					fileDto.setWidth(width);
					fileDto.setHeigth(height);
					fileService.insertFile(fileDto);
                }
            }
		}
		
		return "redirect:/board";
	}
	
	// 글 보기 페이지
	@GetMapping("/post/{posd_id}")
	public String viewPost(@PathVariable Long post_id, Model model, HttpSession session) {
		
		postDTO postDto = postService.selectPostById(post_id);
		
		if(postDto == null) {
			System.out.println("해당 게시글 번호의 게시글 없음!");
			return "redirect:/board";
		}
		postService.updateViews(post_id);
		model.addAttribute("post", postDto);
		model.addAttribute("comments", commentService.selectCommentByPostIdSvc(post_id));
		model.addAttribute("files", fileService.selectFileByPostId(post_id));
		model.addAttribute("newComment", new commentDTO());
		
		return "post_view";
	}
	
	// 글 수정 페이지
	@GetMapping("/post/update/{post_id}")
	public String showUpdateForm(@PathVariable Long post_id, Model model, HttpSession session) {
		Long user_no = (Long) session.getAttribute("user_no");
		if(user_no == null) {
			return "redirect:/login";
		}
		
		postDTO postDto = postService.selectPostById(post_id);
		if(postDto == null || !postDto.getUser_no().equals(user_no)) {
			return "redirect:/post/" + post_id;
		}
		
		model.addAttribute("post", postDto);
		return "write";
	}
	
	// 글 수정
	@GetMapping("/post/update/{post_id}")
	public String updatePost(@PathVariable Long post_id, postDTO postDto,
			@RequestParam("file") MultipartFile[] files, @RequestParam("image") MultipartFile[] images,
			HttpSession session) throws IOException {
		Long user_no = (Long) session.getAttribute("user_no");
		String author = (String) session.getAttribute("user_name");
		
		if(user_no == null) {
			return "redirect:/login";
		}
		
		postDTO ex_postDto = postService.selectPostById(post_id);
		if(ex_postDto == null || !ex_postDto.getUser_no().equals(user_no)) {
			return "redirect:/post/" + post_id;
		}
		
		postDto.setPost_id(post_id);
		postDto.setUser_no(user_no);
		postDto.setAuthor(author);
		postDto.setViews(ex_postDto.getViews());
		postDto.setReg_date(ex_postDto.getReg_date());
		postDto.setUdt_date(new Date());
		
		postService.updatePostSvc(postDto);
		
		String uploadDir = ""; // 파일 경로

		// 파일 업로드 처리
		if (files != null && files.length > 0) {
			
			for (MultipartFile file : files) {
				if (!file.isEmpty()) {
					String fileName = file.getOriginalFilename();
					Path filePath = Paths.get(uploadDir + File.separator + "files" + File.separator + fileName);
					Files.createDirectories(filePath.getParent());
					file.transferTo(filePath.toFile());
					
					fileDTO fileDto = new fileDTO();
					fileDto.setUser_no(user_no);
					fileDto.setPost_id(postDto.getPost_id());
					fileDto.setFile_name(fileName);
					fileDto.setFile_path(filePath.toString());
					fileDto.setFile_size(file.getSize());
					fileDto.setFile_type("document");
					fileService.insertFile(fileDto);
				}
			}
		}
		
		// 이미지 업로드 처리
		if (images != null && images.length > 0) {
			for (MultipartFile image : images) {
                if (!image.isEmpty()) {
                    String imageName = image.getOriginalFilename();
                    Path imagePath = Paths.get(uploadDir + File.separator + "images" + File.separator + imageName);
                    Files.createDirectories(imagePath.getParent());
                    image.transferTo(imagePath.toFile());
                  
                    // 이미지 크기 및 썸네일 생성
                    BufferedImage bimg = ImageIO.read(image.getInputStream());
                    int width = bimg.getWidth();
                    int height = bimg.getHeight();
                    //String thumbnailPath = imagePath.toString().replace(".jpg", "_thumb.jpg");
                    
                    fileDTO fileDto = new fileDTO();
					fileDto.setUser_no(user_no);
					fileDto.setPost_id(postDto.getPost_id());
					fileDto.setFile_name(imageName);
					fileDto.setFile_path(imagePath.toString());
					fileDto.setFile_size(image.getSize());
					fileDto.setFile_type("image");
					fileDto.setWidth(width);
					fileDto.setHeigth(height);
					fileService.insertFile(fileDto);
                }
            }
		}
		
		return "redirect:/post/" + post_id;
	}
	
	// 글 삭제
	@DeleteMapping("/post/delete/{post_id")
	public String deletePost(@PathVariable Long post_id, HttpSession session) {
		Long user_no = (Long) session.getAttribute("user_no");
		if(user_no == null) {
			return "redirect:/login";
		}
		
		postDTO postDto = postService.selectPostById(post_id);
		if(postDto != null && postDto.getUser_no().equals(user_no)) {
			postService.deletePostSvc(post_id);
		}
		
		return "redirect:/board";
	}
	
	// 댓글 
	@PostMapping("/post/{post_id}/comment")
	public String addOrUpdateComment(@PathVariable int post_id, @ModelAttribute commentDTO commentDto,
							@RequestParam(required = false) Long parent_id, HttpSession session) {
								
		Long user_no = (Long) session.getAttribute("user_no");
		String author = (String) session.getAttribute("user_name");
		if (user_no == null || author == null) {
			return "redirect:/login";
		}
		
		commentDto.setPost_id(post_id);
		commentDto.setUser_no(user_no);
		commentDto.setAuthor(author);
		
		// 댓글 수정
		if (commentDto.getComment_id() != null) {
			commentService.updateCommentSvc(commentDto);
		} 
		
		// 댓글 추가
		else {
			commentDto.setParent_id(parent_id);
			commentService.insertCommentSvc(commentDto);
		}
		
		return "redirect:/post/" + post_id;
		
	}
	
	@DeleteMapping("/post/deleteComment/{comment_id}")
	public String delectComment(@PathVariable Long comment_id, @PathVariable Long post_id, HttpSession session) {
		
		Long user_no = (Long) session.getAttribute("user_no");
		String author = (String) session.getAttribute("user_name");
		if (user_no == null || author == null) {
			return "redirect:/login";
		}
		
		commentDTO commentDto = commentService.selectCommentById(comment_id);
		if (commentDto == null && commentDto.getAuthor().equals(author)) {
			commentService.deleteCommentSvc(comment_id);
		}
		return null;
	}

	@GetMapping("/download")
	public ResponseEntity<byte[]> downloadFile(@RequestParam Long file_id, HttpSession session) throws IOException {
		
		Long user_no = (Long) session.getAttribute("user_no");
		if (user_no == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
		}
		
		fileDTO fileDto = fileService.selectFileById(file_id);
		if (fileDto == null) {
			return ResponseEntity.notFound().build();
		}
		
		Path path = Paths.get(fileDto.getFile_path());
		byte[] data = Files.readAllBytes(path);
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.parseMediaType(fileDto.getFile_type().equals("image") ? "image/jpeg" : "application/octet-stream"));
		headers.setContentDispositionFormData("attachment", fileDto.getFile_name());
		headers.setContentLength(fileDto.getFile_size());
		
		return new ResponseEntity<>(data, headers, HttpStatus.OK);
	}
}
