package com.fair.draw.mapper;

import com.fair.draw.domain.Winner;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface WinnerMapper {
    void insert(Winner winner);

    // 여러 명의 당첨 결과를 한 번의 쿼리로 DB에 넣음
    void insertWinners(@Param("winners") List<Winner> winners);

    // 특정 참가자의 당첨 결과 조회
    Winner findByParticipant(Long participantId);

    // 상태 업데이트 (예: UNCHECKED -> CHECKED)
    void updatePrizeStatus(@Param("id") Long id, @Param("status") String status);

    // 이벤트별/경품별 당첨자 통계 (관리자 대시보드용)
    List<Map<String, Object>> countByPrize(Long eventId);

    // 미확인 당첨자(UNCHECKED)의 참가자 ID 목록 조회 (리마인드 문자 발송용)
    List<Long> findUncheckedParticipantIds(Long eventId);

    void deleteByEvent(Long eventId);
}