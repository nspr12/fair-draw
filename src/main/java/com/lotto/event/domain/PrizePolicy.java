package com.lotto.event.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PrizePolicy {
    private Long id;
    private Long eventId;
    private int rankType;
    private int prizeCount;
    private int matchCount;
    private Integer startNo;
    private Integer endNo;
    private String description;
}