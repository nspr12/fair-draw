package com.fair.draw.domain;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class Participant {
    private Long id;
    private Long eventId;
    private String phoneNumber;   // 추후 Spring Security의 User ID로 교체 가능
    private Boolean isVerified;
    private LocalDateTime createdAt; // 응모한 시간 (매우 중요!)
    // participantNo, checkCount 등 불필요한 필드 제거
}


