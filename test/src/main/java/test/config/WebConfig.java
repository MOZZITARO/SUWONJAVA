package test.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.tiles3.TilesConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesViewResolver;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	
	@Override
	public void addCorsMappings(CorsRegistry registry) {
		registry.addMapping("/api/**")
				.allowedOrigins("http://localhost:5000") // flask port
				.allowedMethods("*")
				.allowedHeaders("*");
	}
	
	@Bean
	public TilesConfigurer tilesConfigurer() {
        TilesConfigurer configurer = new TilesConfigurer();
        configurer.setDefinitions(new String[] {"/WEB-INF/tiles/tiles.xml"});
        configurer.setCheckRefresh(true);
        return configurer;
    }

    @Bean
    public TilesViewResolver tilesViewResolver() {
        TilesViewResolver resolver = new TilesViewResolver();
        resolver.setViewClass(org.springframework.web.servlet.view.tiles3.TilesView.class);
        resolver.setOrder(0); // 타일즈가 가장 높은 우선순위
        return resolver;
    }
    
    @Bean
    public InternalResourceViewResolver defaultViewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        resolver.setOrder(1); // 기본 JSP 리졸버는 낮은 우선순위
        return resolver;
    }
    
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
