package com.fair.draw.dto;

import lombok.Builder;
import lombok.Getter;
import java.util.List;

//이벤트 참가 응답 DTO
@Getter
@Builder
public class ParticipantResponse {
    private Long participantId;
    private Integer participantNo;
    private List<Integer> lottoNumbers;
    private String message;
}