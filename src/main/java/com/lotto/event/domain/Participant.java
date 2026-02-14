package com.lotto.event.domain;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class Participant {
    private Long id;
    private Long eventId;
    private Integer participantNo;
    private String phoneNumber;
    private Boolean isVerified;
    private Integer checkCount;
    private LocalDateTime lastCheckedAt;
    private LocalDateTime createdAt;
}