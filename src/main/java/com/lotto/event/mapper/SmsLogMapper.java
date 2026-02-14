package com.lotto.event.mapper;

import com.lotto.event.domain.SmsLog;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SmsLogMapper {
    void insert(SmsLog smsLog);
}