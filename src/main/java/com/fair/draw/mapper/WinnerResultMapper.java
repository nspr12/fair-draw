package com.fair.draw.mapper;

import com.fair.draw.domain.Winner;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface WinnerResultMapper {
    void insert(Winner result);
    Winner findByParticipant(Long participantId);
    List<Winner> findByRank(int rankType);

    //추가(관리자모드용)
    List<Map<String, Object>> countByRank(Long eventId);
    void deleteByEvent(Long eventId);
}