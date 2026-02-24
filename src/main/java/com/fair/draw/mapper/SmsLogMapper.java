package com.fair.draw.mapper;

import com.fair.draw.domain.SmsLog;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SmsLogMapper {
    void insert(SmsLog smsLog);

    //추가
    int countByEvent(Long eventId);
    void deleteByEvent(Long eventId);
}