package com.lotto.event.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WinningNumber {
    private Long id;
    private Long eventId;
    private Integer number;
}
