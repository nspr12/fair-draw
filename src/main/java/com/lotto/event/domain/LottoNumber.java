package com.lotto.event.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LottoNumber {
    private Long id;
    private Long ticketId;
    private Integer number;
}
