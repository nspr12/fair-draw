package com.fair.draw;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class FairDrawApplication {

    public static void main(String[] args) {
        SpringApplication.run(FairDrawApplication.class, args);
    }

}
