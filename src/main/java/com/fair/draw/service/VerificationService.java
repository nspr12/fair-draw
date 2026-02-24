//인증서비스
package com.fair.draw.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class VerificationService {

    //인증번호 발송 (Mocking)

    public void sendVerificationCode(String phoneNumber) {
        log.info("[인증번호 발송] 수신: {}, 인증번호: 123456", phoneNumber);
    }

    // 인증번호 검증 (Mocking) - "123456" 입력 시 통과
    public boolean verify(String phoneNumber, String code) {
        log.info("[인증번호 검증] 수신: {}, 입력코드: {}", phoneNumber, code);
        return "123456".equals(code);
    }
}