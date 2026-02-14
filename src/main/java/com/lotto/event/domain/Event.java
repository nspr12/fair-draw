package com.lotto.event.domain;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
public class Event {
    private Long id;
    private String title;
    private LocalDate startDate;
    private LocalDate endDate;
    private LocalDate drawDate;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
