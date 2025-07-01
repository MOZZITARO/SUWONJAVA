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
import org.springframework.http.HttpMethod;

import test.service.CustomService;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private CustomService customService;

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth
            .userDetailsService(customService)
            .passwordEncoder(passwordEncoder());
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .cors().disable()
            .csrf()
                .ignoringAntMatchers(
                    "/customlogout", "/findpw", "/send-verification", "/changeok",
                    "/joinmain", "/joinprocess", "/changepw", "/newpw", "/Loginaccess",
                    "/api/refrigerator/**", "/api/preferences/**", "/delete_ingredient/**", "/update_ingredient/**"
                )
            .and()
            .authorizeRequests()
                // 인증 필요, USER 역할
                .antMatchers("/deletep", "/deleteok").hasRole("USER")
                .antMatchers("/Main").hasRole("USER")
                .antMatchers("/modifypw").hasRole("USER")
                .antMatchers("/mypage", "/mypage/**").hasRole("USER")
                // 인증 불필요
                .antMatchers(HttpMethod.POST, "/api/preferences").permitAll()
                .antMatchers(HttpMethod.GET, "/api/preferences").permitAll()
                .antMatchers("/delete_ingredient/**").permitAll()
                .antMatchers("/api/refrigerator/**").permitAll()
                .antMatchers(
                    "/", "/loginmain", "/oauth2/**",
                    "/css/**", "/js/**", "/images/**",
                    "/findpw", "/send-verification", "/changeok",
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
            .headers()
                .frameOptions().disable();
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
