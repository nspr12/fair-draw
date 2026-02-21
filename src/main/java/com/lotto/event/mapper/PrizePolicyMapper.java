package com.lotto.event.mapper;

import com.lotto.event.domain.PrizePolicy;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface PrizePolicyMapper {
    List<PrizePolicy> findByEvent(Long eventId);
}