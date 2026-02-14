package com.lotto.event.domain;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class LottoTicket {
    private Long id;
    private Long participantId;
    private Boolean isPredefined;
    private LocalDateTime createdAt;
}