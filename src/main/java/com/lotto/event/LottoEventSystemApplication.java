package com.lotto.event;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class LottoEventSystemApplication {

    public static void main(String[] args) {
        SpringApplication.run(LottoEventSystemApplication.class, args);
    }

}
