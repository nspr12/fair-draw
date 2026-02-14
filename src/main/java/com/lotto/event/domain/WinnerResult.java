package com.lotto.event.domain;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class WinnerResult {
    private Long id;
    private Long participantId;
    private Integer rankType;
    private Integer matchedCount;
    private String prizeStatus;
    private LocalDateTime createdAt;
}