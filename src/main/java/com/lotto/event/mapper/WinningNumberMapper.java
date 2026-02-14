package com.lotto.event.mapper;

import com.lotto.event.domain.WinningNumber;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface WinningNumberMapper {
    void insert(WinningNumber winningNumber);
    List<WinningNumber> findByEvent(Long eventId);
}