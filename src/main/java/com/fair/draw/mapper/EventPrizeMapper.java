package com.fair.draw.mapper;

import com.fair.draw.domain.EventPrize;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface EventPrizeMapper {
    // 이벤트의 경품 정책 목록 조회
    List<EventPrize> findByEvent(Long eventId);

    //추가
    EventPrize findById(Long id);
}