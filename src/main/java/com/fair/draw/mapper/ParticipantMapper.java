package com.fair.draw.mapper;

import com.fair.draw.domain.Participant;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ParticipantMapper {
    void insert(Participant participant);
    Participant findById(Long id);

    // 특정 이벤트에 해당 휴대폰 번호로 참여한 내역 조회 (중복 방지용)
    Participant findByEventAndPhone(@Param("eventId") Long eventId, @Param("phoneNumber") String phoneNumber);

    // 이벤트 총 참가자 수 조회
    int countByEvent(Long eventId);

    // 비관적 락(Pessimistic Lock)을 활용한 참가자 수 조회 (선착순 마감 등 동시성 제어용)
    int countByEventForUpdate(Long eventId);

    // DB 단에서 지정된 수량(limit)만큼 무작위 참가자 ID 추출 (OOM 방지)
    List<Long> findRandomWinnerIds(@Param("eventId") Long eventId, @Param("limit") int limit);

    void deleteByEvent(Long eventId);
}