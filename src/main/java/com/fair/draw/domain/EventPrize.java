package com.fair.draw.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class EventPrize {
    private Long id;
    private Long eventId;
    private Integer rankType;     // 1등, 2등 (또는 경품 A, 경품 B)
    private String prizeName;     // 추가: "조던 1 시카고", "스타벅스 아메리카노"
    private Integer prizeCount;   // 핵심!: 당첨시켜야 할 정확한 제한 수량 (예: 100명)
}