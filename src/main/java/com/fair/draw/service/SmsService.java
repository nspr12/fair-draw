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

    // 문자 발송 (Mocking) - 실제 발송 대신 로그 + DB 기록
    public void send(Long participantId, String phoneNumber, String messageType, String content) {
        log.info("[SMS 발송] 수신: {}, 유형: {}, 내용: {}", phoneNumber, messageType, content);

        SmsLog smsLog = new SmsLog();
        smsLog.setParticipantId(participantId);
        smsLog.setPhoneNumber(phoneNumber);
        smsLog.setMessageType(messageType);
        smsLog.setContent(content);
        smsLog.setSendStatus("SUCCESS");

        smsLogMapper.insert(smsLog);
    }
}