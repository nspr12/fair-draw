package com.fair.draw.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

// 스프링 컨테이너에 MutableClock을 빈으로 등록
// → DrawService, EventController 등에서 주입받아 사용
@Configuration
public class ClockConfig {

    @Bean
    public MutableClock clock() {
        return new MutableClock();
    }
}