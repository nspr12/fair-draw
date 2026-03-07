package com.fair.draw.service;

import com.fair.draw.domain.SmsLog;
import com.fair.draw.mapper.SmsLogMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class SmsService {

    private final SmsLogMapper smsLogMapper;
    private final SmsSender smsSender;  // 추가: SmsSender 인터페이스 주입
    // 문자 발송 (Mocking) - 실제 발송 대신 로그 + DB 기록
    public void send(Long participantId, String phoneNumber, String messageType, String content) {

        // 변경: 직접 로그 찍던 것 → SmsSender에 위임
        smsSender.send(phoneNumber, content);

        // DB 로그 기록은 그대로 유지
        SmsLog smsLog = new SmsLog();
        smsLog.setParticipantId(participantId);
        smsLog.setPhoneNumber(phoneNumber);
        smsLog.setMessageType(messageType);
        smsLog.setContent(content);
        smsLog.setSendStatus("SUCCESS");

        smsLogMapper.insert(smsLog);
    }
}