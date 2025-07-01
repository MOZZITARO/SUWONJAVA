package test.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import test.service.CustomOAuth2UserService;
import test.controller.CustomLoginSuccessHandler;
import test.service.CustomService;
import test.service.CustomUserDetailsService;


@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

	@Autowired
    private CustomLoginSuccessHandler customLoginSuccessHandler;
	
	@Autowired
    private CustomUserDetailsService customUserDetailsService;
	
	@Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth
            .userDetailsService(customUserDetailsService)
            .passwordEncoder(passwordEncoder());
    }
	
	@Override
	protected void configure(HttpSecurity http) throws Exception {
	    http
	        .cors().disable()
	        .csrf()
	            .ignoringAntMatchers("/customlogout","/findpw", "/send-verification", "/modifypw", "/changeok",
		                "/joinmain", "/joinprocess", "/changepw", "/newpw", "/Loginaccess", "/mypage/**", "/mypage", "/api/**", "/Reciperesult")
	        .and()
	        .authorizeRequests()
		        .antMatchers("/deletep", "/deleteok").hasRole("USER")
	            .antMatchers("/modifypw").hasRole("USER")
	            .antMatchers("/Reciperesult").hasRole("USER")
	            .antMatchers("/api/preferences", "/api/refrigerator").hasRole("USER")
	            .antMatchers("/mypage", "/mypage/**").hasRole("USER") 
	            .antMatchers(
	                "/", "/loginmain", "/oauth2/**",  "/Main",
	                "/css/**", "/js/**", "/images/**",
	                "/findpw", "/send-verification", "/modifypw", "/changeok",
	                "/joinmain", "/joinprocess", "/changepw", "/newpw"
	            ).permitAll()           
	            .anyRequest().authenticated()
	        .and()
	        .oauth2Login()
	            .loginPage("/loginmain")
	            .defaultSuccessUrl("/home", true)
	        .and()
	        .logout()
            .logoutUrl("/logout")
            .logoutSuccessUrl("/Main")
            .deleteCookies("JSESSIONID") 
            .invalidateHttpSession(true) // 서버 세션 제거
            .clearAuthentication(true)  // 인증정보 제거
            .and()
	        .formLogin()
            .loginPage("/loginmain")
            .loginProcessingUrl("/Loginaccess") // POST 요청    
            .usernameParameter("user_id") // HTML 폼의 실제 필드명
            .passwordParameter("user_pw")
            .successHandler(customLoginSuccessHandler)
            .defaultSuccessUrl("/Main", true)
            .failureUrl("/loginmain?error=true")
            .and()
	        .headers().frameOptions().disable();
	    
	}

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }
    
}
