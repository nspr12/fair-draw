package com.fair.draw.mapper;

import com.fair.draw.domain.LottoNumber;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface LottoNumberMapper {
    void insert(LottoNumber lottoNumber);
    List<LottoNumber> findByTicket(Long ticketId);
    void deleteByTicket(Long ticketId); //당첨번호로교체
    void deleteByEvent(Long eventId); //
}