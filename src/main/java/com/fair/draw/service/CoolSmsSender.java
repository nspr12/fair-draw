package com.fair.draw.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

// 프로덕션용 CoolSMS 연동 (구현 예정)
// TODO: CoolSMS API Key 설정 및 SDK 연동
@Slf4j
@Profile("prod")
@Component
public class CoolSmsSender implements SmsSender {

    @Override
    public void send(String phoneNumber, String content) {
        // TODO: CoolSMS API 호출 로직 구현
        log.info("[CoolSMS] 발송 예정 - 수신: {}, 내용: {}", phoneNumber, content);
    }
}