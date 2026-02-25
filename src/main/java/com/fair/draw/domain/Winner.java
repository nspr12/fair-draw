package com.fair.draw.domain;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
//public class WinnerResult {
//    private Long id;
//    private Long participantId;
//    private Integer rankType;
//    private Integer matchedCount;
//    private String prizeStatus;
//    private LocalDateTime createdAt;
//}

public class Winner {
    private Long id;
    private Long eventId;
    private Long participantId; // 당첨된 사람
    private Long prizeId;       // 당첨된 경품 (EventPrize의 ID)
    private String prizeStatus; // 알림톡 발송 여부 등
    private LocalDateTime createdAt;
}