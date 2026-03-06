package com.fair.draw.service;

import com.fair.draw.domain.Event;
import com.fair.draw.domain.EventPrize;
import com.fair.draw.domain.Winner;
import com.fair.draw.enums.EventStatus;
import com.fair.draw.enums.PrizeStatus;
import com.fair.draw.mapper.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class DrawService {

    private final Clock clock;  //Clock 필드 추가 (ClockConfig에서 자동 주입)
    private final EventMapper eventMapper;
    private final EventPrizeMapper eventPrizeMapper;
    private final ParticipantMapper participantMapper;
    private final WinnerMapper winnerMapper;
    private final ResultCheckLogMapper resultCheckLogMapper;
    private final SmsLogMapper smsLogMapper;

    /**
     * FairDraw 핵심 추첨 로직 (고정 수량 무작위 추출 및 Bulk Insert)
     * 파라미터에서 내정자 제거
     */
    @Transactional
    public void draw(Long eventId) {  //String simulatedDate 파라미터 제거
        // 1. 이벤트 존재 여부 확인
        Event event = eventMapper.findById(eventId);
        if (event == null) {
            throw new IllegalArgumentException("존재하지 않는 이벤트입니다.");
        }

        // 2. 이벤트 상태 검증 (ACTIVE 상태에서만 추첨 가능)
        if (!EventStatus.ACTIVE.name().equals(event.getStatus())) {
            throw new IllegalStateException("추첨 가능한 상태가 아닙니다. (현재: " + event.getStatus() + ")");
        }
            // 변경: simulatedDate 분기 로직 전체 삭제 → clock 한 줄로 대체
        LocalDate today = LocalDate.now(clock);

        if (!today.isAfter(event.getEndDate())) {
            throw new IllegalStateException("이벤트 종료 후 추첨이 가능합니다. (종료일: " + event.getEndDate() + ")");
        }

        // 3. 경품 정책 조회
        List<EventPrize> prizes = eventPrizeMapper.findByEvent(eventId);
        if (prizes.isEmpty()) {
            throw new IllegalStateException("당첨 경품 정책이 설정되지 않았습니다.");
        }

        //  [최적화 & 중복 방지]
            // 1등부터 4등까지 필요한 총 경품 개수를 먼저 구합니다.
        int totalPrizeCount = prizes.stream().mapToInt(EventPrize::getPrizeCount).sum();

        // 전체 수량만큼 DB에서 한 번의 쿼리로 무작위 추출 (DB 난수 추출은 중복이 발생하지 않음)
        List<Long> randomWinnerIds = participantMapper.findRandomWinnerIds(eventId, totalPrizeCount);

        List<Winner> finalWinners = new ArrayList<>();
        int currentIndex = 0;

        // 4. 뽑혀온 당첨자들을 1등부터 순서대로 할당
        for (EventPrize prize : prizes) {
            int allocatedCount = 0; // 실제 할당된 인원 수

            for (int i = 0; i < prize.getPrizeCount(); i++) {
                // 경품 수보다 참가자가 적을 경우를 대비한 안전 장치
                if (currentIndex >= randomWinnerIds.size()) {
                    break;
                }

                Long participantId = randomWinnerIds.get(currentIndex++);
                Winner winner = new Winner();
                winner.setParticipantId(participantId);
                winner.setPrizeId(prize.getId());
                winner.setPrizeStatus(PrizeStatus.UNCHECKED.name());
                finalWinners.add(winner);
                allocatedCount++;
            }
            log.info("[추첨 완료] {}등 ({}): {}명 당첨", prize.getRankType(), prize.getPrizeName(), allocatedCount);
        }

        // 5. 벌크 인서트
        if (!finalWinners.isEmpty()) {
            winnerMapper.insertWinners(finalWinners);
        }

        // 5. 이벤트 상태 변경
        eventMapper.updateStatus(eventId, EventStatus.DRAWN.name());
        log.info("🎉 이벤트 {} 최종 추첨 종료 (총 당첨자: {}명)", eventId, finalWinners.size());
    }

    // DB초기화
    @Transactional
    public void resetEvent(Long eventId) {
        resultCheckLogMapper.deleteByEvent(eventId);  // 추가
        smsLogMapper.deleteByEvent(eventId);           // 추가
        winnerMapper.deleteByEvent(eventId);
        participantMapper.deleteByEvent(eventId);
        eventMapper.updateStatus(eventId, EventStatus.ACTIVE.name());
        log.info("이벤트 {} 데이터 초기화 완료", eventId);
    }
}