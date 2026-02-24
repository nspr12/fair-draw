package com.fair.draw.domain;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class SmsLog {
    private Long id;
    private Long participantId;
    private String phoneNumber;
    private String messageType;
    private String content;
    private String sendStatus;
    private LocalDateTime sentAt;
}