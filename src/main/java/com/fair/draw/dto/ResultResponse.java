package com.fair.draw.dto;

import lombok.Builder;
import lombok.Getter;
import java.util.List;

//결과 확인 응답
@Getter
@Builder
public class ResultResponse {
    private boolean isWinner;           //당첨여부
    private Integer rankType;   // (다시추가)몇 등인지
    private String prizeName;   // (다시추가)무슨 상품인지
    private String message;
}