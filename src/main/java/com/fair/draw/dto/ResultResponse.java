package com.fair.draw.dto;

import lombok.Builder;
import lombok.Getter;
import java.util.List;

@Getter
@Builder
public class ResultResponse {
    private boolean isWinner;           //당첨여부
    private Integer rankType;           //(선택)1등,2등구분
    private String prizeName;           // (추가) 당첨된 경품 이름 (예: "아이패드 프로", "스타벅스 쿠폰")
    private String message;
}