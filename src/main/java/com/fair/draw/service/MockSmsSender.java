package com.fair.draw.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

// 개발용 목업 문자 발송
    //실제 문자를 보내지 않고 로그만 찍음
@Slf4j
@Profile("dev")
@Component
public class MockSmsSender implements SmsSender {

    @Override
    public void send(String phoneNumber, String content) {
        log.info("[MOCK SMS] 수신: {}, 내용: {}", phoneNumber, content);
    }
}