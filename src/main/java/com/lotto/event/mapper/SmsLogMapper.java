package com.lotto.event.mapper;

import com.lotto.event.domain.SmsLog;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SmsLogMapper {
    void insert(SmsLog smsLog);

    //추가
    int countByEvent(Long eventId);
    void deleteByEvent(Long eventId);
}