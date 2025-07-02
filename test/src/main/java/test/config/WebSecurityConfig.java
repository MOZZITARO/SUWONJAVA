package test.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import test.service.CustomUserDetailsService;

import org.springframework.context.annotation.Bean;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.cors.CorsConfigurationSource;

import java.util.List;




@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

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
            .cors() // CORS 활성화
            .and()
            .csrf().disable() // 필요하면 비활성화
            .authorizeRequests()
                .antMatchers(
                    "/", "/loginmain", "/oauth2/**",
                    "/css/**", "/js/**", "/images/**",
                    "/findpw", "/send-verification", "/modifypw", "/changeok",
                    "/joinmain", "/joinprocess", "/changepw", "/newpw",
                    "/api/refrigerator/**", // 인증 없이 허용할 API 경로
                    "/api/preferences"
                ).permitAll()
                .antMatchers("/deletep", "/deleteok").hasRole("USER")
                .antMatchers("/Main").hasRole("USER")
                .antMatchers("/modifypw", "/changeok").hasRole("USER")
                .anyRequest().authenticated()
            .and()
            .exceptionHandling()
                .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED))
            .and()
            .oauth2Login()
                .loginPage("/loginmain")
                .defaultSuccessUrl("/home", true)
            .and()
            .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/loginmain")
                .invalidateHttpSession(true)
                .clearAuthentication(true)
            .and()
            .formLogin()
                .loginPage("/loginmain")
                .loginProcessingUrl("/Loginaccess")
                .usernameParameter("user_id")
                .passwordParameter("user_pw")
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
    
    
    
   //시큐리티가 CORS 차단하지 않게 하기 위한 설정
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of("http://localhost:5000"));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowCredentials(true);
        configuration.setAllowedHeaders(List.of("*"));
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/api/**", configuration);
        return source;
    }
    
    
    
}
