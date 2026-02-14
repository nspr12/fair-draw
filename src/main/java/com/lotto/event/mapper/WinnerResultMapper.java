package com.lotto.event.mapper;

import com.lotto.event.domain.WinnerResult;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface WinnerResultMapper {
    void insert(WinnerResult result);
    WinnerResult findByParticipant(Long participantId);
    List<WinnerResult> findByRank(int rankType);
}