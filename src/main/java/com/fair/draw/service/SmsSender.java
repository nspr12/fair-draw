package com.fair.draw.service;

// 문자 발송 인터페이스
// 구현체가 바뀌어도 (Mock → CoolSMS → Twilio 등) 이 인터페이스를 쓰는 쪽은 수정 불필요
public interface SmsSender {
    void send(String phoneNumber, String content);
}