package com.fair.draw.mapper;

import com.fair.draw.domain.EventPrize;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface PrizePolicyMapper {
    List<EventPrize> findByEvent(Long eventId);
}