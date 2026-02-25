package com.fair.draw.dto;

import lombok.Builder;
import lombok.Getter;
import java.util.List;

//이벤트 참가 성공 시 응답 DTO
@Getter
@Builder
public class ParticipantResponse {
    private Long participantId;
    private Integer participantNo;  //(선택) "고객님의 응모 대기 번호는 1500번입니다" 용도
    private String message;
}