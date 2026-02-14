package com.lotto.event.mapper;

import com.lotto.event.domain.Participant;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ParticipantMapper {
    void insert(Participant participant);
    Participant findById(Long id);
    Participant findByEventAndPhone(@Param("eventId") Long eventId, @Param("phoneNumber") String phoneNumber);
    int getMaxParticipantNo(Long eventId);
    int countByEvent(Long eventId);
    List<Participant> findAllByEvent(Long eventId);
    List<Participant> findUncheckedWinners(Long eventId);
    void incrementCheckCount(Long id);
}