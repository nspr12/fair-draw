package com.fair.draw.mapper;

import com.fair.draw.domain.LottoTicket;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LottoTicketMapper {
    void insert(LottoTicket ticket);
    LottoTicket findByParticipant(Long participantId);

    void deleteByEvent(Long eventId);
}