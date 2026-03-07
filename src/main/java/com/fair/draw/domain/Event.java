package com.fair.draw.domain;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
public class Event {
    private Long id;
    private String title;
    private String description;          // 이벤트 설명
    private String thumbnailUrl;         // 대표 이미지
    private LocalDate startDate;
    private LocalDate endDate;
    private LocalDate drawDate;
    private LocalDate announceStartDate; // 발표 시작일
    private LocalDate announceEndDate;   // 발표 종료일
    private Integer maxParticipants;     // 최대 참가 인원
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
