package com.fair.draw.service;

import com.fair.draw.domain.Event;
import com.fair.draw.domain.EventPrize;
import com.fair.draw.domain.Winner;
import com.fair.draw.enums.EventStatus;
import com.fair.draw.enums.PrizeStatus;
import com.fair.draw.mapper.EventMapper;
import com.fair.draw.mapper.EventPrizeMapper;
import com.fair.draw.mapper.ParticipantMapper;
import com.fair.draw.mapper.WinnerMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class DrawService {

    private final EventMapper eventMapper;
    private final EventPrizeMapper eventPrizeMapper;
    private final ParticipantMapper participantMapper;
    private final WinnerMapper winnerMapper;

    /**
     * FairDraw 핵심 추첨 로직 (고정 수량 무작위 추출 및 Bulk Insert)
     * 파라미터에서 내정자 제거
     */
    @Transactional
    public void draw(Long eventId) {
        // 1. 이벤트 상태 검증
        Event event = eventMapper.findById(eventId);
        if (event == null) {
            throw new IllegalArgumentException("존재하지 않는 이벤트입니다.");
        }
        if (!EventStatus.ACTIVE.name().equals(event.getStatus())) {
            throw new IllegalStateException("추첨 가능한 상태가 아닙니다.");
        }

        // 2. 경품 정책 조회 (예: 1등 아이패드 1명, 2등 에어팟 5명...) ☆(등수 제거 고민 중)
        List<EventPrize> prizes = eventPrizeMapper.findByEvent(eventId);
        if (prizes.isEmpty()) {
            throw new IllegalStateException("당첨 경품 정책이 설정되지 않았습니다.");
        }

        List<Winner> finalWinners = new ArrayList<>();

        // 3. 각 경품별로 추첨 진행
        for (EventPrize prize : prizes) {
            // [핵심] 자바 메모리로 10만 명을 불러오기 X
            // DB 단에서 ORDER BY RAND()를 통해 필요한 수량(T/O)만큼만 빠르게 ID를 추출
            List<Long> winnerIds = participantMapper.findRandomWinnerIds(eventId, prize.getPrizeCount());

            for (Long participantId : winnerIds) {
                Winner winner = new Winner();
                winner.setParticipantId(participantId);
                winner.setPrizeId(prize.getId());
                winner.setPrizeStatus(PrizeStatus.UNCHECKED.name());
                finalWinners.add(winner);
            }
            log.info("[추첨 완료] {}등 ({}): {}명 당첨", prize.getRankType(), prize.getPrizeName(), winnerIds.size());
        }

        // 4. 당첨자 벌크 인서트 (네트워크 통신 최소화)
        if (!finalWinners.isEmpty()) {
            winnerMapper.insertWinners(finalWinners);
        }

        // 5. 이벤트 상태를 '추첨 완료(DRAWN)'로 변경
        eventMapper.updateStatus(eventId, EventStatus.DRAWN.name());
        log.info("🎉 이벤트 {} 최종 추첨 종료 (총 당첨자: {}명)", eventId, finalWinners.size());
    }
}