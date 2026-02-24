package com.fair.draw.service;

import com.fair.draw.domain.*;
import com.fair.draw.mapper.*;;
import com.fair.draw.enums.EventStatus;
import com.fair.draw.enums.PrizeStatus;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class DrawService {

    private final EventMapper eventMapper;
    private final ParticipantMapper participantMapper;
    private final LottoTicketMapper lottoTicketMapper;
    private final LottoNumberMapper lottoNumberMapper;
    private final WinningNumberMapper winningNumberMapper;
    private final WinnerResultMapper winnerResultMapper;
    private final SmsLogMapper smsLogMapper;
    private final ResultCheckLogMapper resultCheckLogMapper;
    private final PrizePolicyMapper prizePolicyMapper;

    /*
     * 추첨 실행
     * 등수별 당첨 조건은 prize_policy 테이블에서 조회 (하드코딩 제거)
     */
    @Transactional
    public void draw(Long eventId, String predefinedWinnerPhone) {
        // 1. 이벤트 검증
        Event event = eventMapper.findById(eventId);
        if (event == null) {
            throw new IllegalArgumentException("존재하지 않는 이벤트입니다.");
        }
        if (!EventStatus.ACTIVE.name().equals(event.getStatus())) {
            throw new IllegalStateException("추첨 가능한 상태가 아닙니다.");
        }

        // 2. 당첨 정책 조회 (DB 기반)
        List<PrizePolicy> policies = prizePolicyMapper.findByEvent(eventId);
        if (policies.isEmpty()) {
            throw new IllegalStateException("당첨 정책이 설정되지 않았습니다.");
        }

        // 3. 당첨번호 6개 생성 및 저장
        List<Integer> winningNumbers = generateWinningNumbers();
        for (Integer number : winningNumbers) {
            WinningNumber wn = new WinningNumber();
            wn.setEventId(eventId);
            wn.setNumber(number);
            winningNumberMapper.insert(wn);
        }
        log.info("당첨번호: {}", winningNumbers);

        // 4. 전체 참가자 조회
        List<Participant> allParticipants = participantMapper.findAllByEvent(eventId);
        Set<Long> alreadyWon = new HashSet<>();

        // 5. 1등 처리 (사전 지정)
        PrizePolicy firstPolicy = policies.stream()
                .filter(p -> p.getRankType() == 1)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("1등 정책이 없습니다."));

        Participant firstWinner = participantMapper.findByEventAndPhone(eventId, predefinedWinnerPhone);
        if (firstWinner == null) {
            throw new IllegalArgumentException("사전 지정된 1등 참가자를 찾을 수 없습니다.");
        }
        replaceNumbers(firstWinner.getId(), winningNumbers, firstPolicy.getMatchCount());
        saveWinnerResult(firstWinner.getId(), firstPolicy.getRankType(), firstPolicy.getMatchCount());
        alreadyWon.add(firstWinner.getId());
        log.info("1등 당첨: 참가번호 {}", firstWinner.getParticipantNo());

        // 6. 2등 이상 처리 (정책 기반 반복)
        for (PrizePolicy policy : policies) {
            if (policy.getRankType() == 1) continue; // 1등은 이미 처리

            List<Participant> candidates;

            if (policy.getStartNo() != null && policy.getEndNo() != null) {
                // 참가번호 범위 제한이 있는 경우
                candidates = allParticipants.stream()
                        .filter(p -> p.getParticipantNo() >= policy.getStartNo()
                                && p.getParticipantNo() <= policy.getEndNo())
                        .filter(p -> !alreadyWon.contains(p.getId()))
                        .collect(Collectors.toList());
            } else {
                // 범위 제한 없는 경우 (4등)
                candidates = allParticipants.stream()
                        .filter(p -> !alreadyWon.contains(p.getId()))
                        .collect(Collectors.toList());
            }

            Collections.shuffle(candidates);

            int count = Math.min(policy.getPrizeCount(), candidates.size());
            for (int i = 0; i < count; i++) {
                Participant winner = candidates.get(i);
                replaceNumbers(winner.getId(), winningNumbers, policy.getMatchCount());
                saveWinnerResult(winner.getId(), policy.getRankType(), policy.getMatchCount());
                alreadyWon.add(winner.getId());
            }
            log.info("{}등 당첨: {}명 (정책: {})", policy.getRankType(), count, policy.getDescription());
        }

        // 7. 이벤트 상태 변경 -> DRAWN
        eventMapper.updateStatus(eventId, EventStatus.DRAWN.name());
        log.info("추첨 완료: 이벤트 {} (총 당첨자: {}명)", eventId, alreadyWon.size());
    }

    // 당첨번호 6개 생성 (1~45, 중복 없이, 오름차순)
    private List<Integer> generateWinningNumbers() {
        Set<Integer> numberSet = new TreeSet<>();
        Random random = new Random();
        while (numberSet.size() < 6) {
            numberSet.add(random.nextInt(45) + 1);
        }
        return new ArrayList<>(numberSet);
    }

    /*
     * 참가자의 로또번호를 당첨되도록 교체
     * matchCount: 당첨번호와 일치시킬 개수 (6=1등, 5=2등, 4=3등, 3=4등)
     */
    private void replaceNumbers(Long participantId, List<Integer> winningNumbers, int matchCount) {
        LottoTicket ticket = lottoTicketMapper.findByParticipant(participantId);

        lottoNumberMapper.deleteByTicket(ticket.getId());

        List<Integer> newNumbers = new ArrayList<>(winningNumbers.subList(0, matchCount));

        Random random = new Random();
        while (newNumbers.size() < 6) {
            int num = random.nextInt(45) + 1;
            if (!winningNumbers.contains(num) && !newNumbers.contains(num)) {
                newNumbers.add(num);
            }
        }

        Collections.sort(newNumbers);
        for (Integer num : newNumbers) {
            LottoNumber ln = new LottoNumber();
            ln.setTicketId(ticket.getId());
            ln.setNumber(num);
            lottoNumberMapper.insert(ln);
        }
    }

    // 당첨 결과 저장
    private void saveWinnerResult(Long participantId, int rankType, int matchedCount) {
        WinnerResult result = new WinnerResult();
        result.setParticipantId(participantId);
        result.setRankType(rankType);
        result.setMatchedCount(matchedCount);
        result.setPrizeStatus(PrizeStatus.READY.name());
        winnerResultMapper.insert(result);
    }

    // 이벤트 데이터 초기화 (테스트용)
    @Transactional
    public void resetEvent(Long eventId) {
        winnerResultMapper.deleteByEvent(eventId);
        lottoNumberMapper.deleteByEvent(eventId);
        lottoTicketMapper.deleteByEvent(eventId);
        winningNumberMapper.deleteByEvent(eventId);
        smsLogMapper.deleteByEvent(eventId);
        resultCheckLogMapper.deleteByEvent(eventId);
        participantMapper.deleteByEvent(eventId);
        eventMapper.updateStatus(eventId, EventStatus.ACTIVE.name());
        log.info("이벤트 {} 데이터 초기화 완료", eventId);
    }
}