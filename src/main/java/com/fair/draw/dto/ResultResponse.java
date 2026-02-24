package com.fair.draw.dto;

import lombok.Builder;
import lombok.Getter;
import java.util.List;

@Getter
@Builder
public class ResultResponse {
    private boolean isWinner;
    private Integer rankType;
    private Integer matchedCount;
    private List<Integer> myNumbers;
    private List<Integer> winningNumbers;
    private String message;
}