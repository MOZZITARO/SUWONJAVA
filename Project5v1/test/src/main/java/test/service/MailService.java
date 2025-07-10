package test.service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;

@Service
public class MailService {

	
	// 메일전송 서비스 계층
	// MimeMessage (멀티파일)
	@Autowired
    private JavaMailSender mailSender;
	
	public boolean mailsender(String toEmail, String token) {
		
		try {
			
			MimeMessage massage = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(massage, true, "UTF-8");
			
			helper.setFrom("alsqud45w@naver.com");
			helper.setTo(toEmail);
			helper.setSubject("이메일인증");
			
			System.out.println("Generated token: " + token);
			System.out.println("Final URL: " + "http://localhost:8080/changepw?token=" + token);
			String verificationLink = "http://localhost:8080/changepw?token=" + token;
			String htmlContent = "<h3>이메일 인증</h3>" +
                    "<p>아래 링크를 클릭하여 이메일을 인증해주세요:</p>" +
                    "<a href='" + verificationLink + "'>인증하기</a>";
			
			helper.setText(htmlContent, true);
			
			mailSender.send(massage);
			System.out.println("이메일이 전송되었습니다!");
			
		 } catch (MessagingException e) {
	            throw new RuntimeException("메일 전송 실패", e);
	        }
	    	
		return true;
	}

}
