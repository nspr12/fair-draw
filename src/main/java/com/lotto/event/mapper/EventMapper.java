package com.lotto.event.mapper;

import com.lotto.event.domain.Event;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface EventMapper {
    Event findById(Long id);
    Event findActiveEvent(@Param("status") String status);
    void updateStatus(@Param("id") Long id, @Param("status") String status);
}
