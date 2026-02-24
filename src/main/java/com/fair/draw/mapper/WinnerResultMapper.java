package com.fair.draw.mapper;

import com.fair.draw.domain.WinnerResult;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface WinnerResultMapper {
    void insert(WinnerResult result);
    WinnerResult findByParticipant(Long participantId);
    List<WinnerResult> findByRank(int rankType);

    //추가(관리자모드용)
    List<Map<String, Object>> countByRank(Long eventId);
    void deleteByEvent(Long eventId);
}