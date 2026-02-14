package com.lotto.event.mapper;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ResultCheckLogMapper {
    void insert(Long participantId);
}