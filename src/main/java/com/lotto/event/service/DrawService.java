package com.lotto.event.service;

import com.lotto.event.domain.*;
import com.lotto.event.enums.EventStatus;
import com.lotto.event.enums.PrizeStatus;
import com.lotto.event.mapper.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

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

    //추첨 실행()
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

        // 2. 당첨번호 6개 생성 및 저장
        List<Integer> winningNumbers = generateWinningNumbers();
        for (Integer number : winningNumbers) {
            WinningNumber wn = new WinningNumber();
            wn.setEventId(eventId);
            wn.setNumber(number);
            winningNumberMapper.insert(wn);
        }
        log.info("당첨번호: {}", winningNumbers);

        // 3. 1등 처리 (사전 지정)
        Participant firstWinner = participantMapper.findByEventAndPhone(eventId, predefinedWinnerPhone);
        if (firstWinner == null) {
            throw new IllegalArgumentException("사전 지정된 1등 참가자를 찾을 수 없습니다.");
        }
        replaceNumbers(firstWinner.getId(), winningNumbers, 6);
        saveWinnerResult(firstWinner.getId(), 1, 6);
        log.info("1등 당첨: 참가번호 {}", firstWinner.getParticipantNo());

        // 4. 2등 처리 (5명, 참가번호 2000~7000)
        List<Participant> allParticipants = participantMapper.findAllByEvent(eventId);
        Set<Long> alreadyWon = new HashSet<>();
        alreadyWon.add(firstWinner.getId());

        List<Participant> range2 = allParticipants.stream()
                .filter(p -> p.getParticipantNo() >= 2000 && p.getParticipantNo() <= 7000)
                .filter(p -> !alreadyWon.contains(p.getId()))
                .collect(java.util.stream.Collectors.toList());
        Collections.shuffle(range2);

        for (int i = 0; i < 5 && i < range2.size(); i++) {
            Participant winner = range2.get(i);
            replaceNumbers(winner.getId(), winningNumbers, 5); //번호 교체/할당
            saveWinnerResult(winner.getId(), 2, 5);            //당첨 결과 저장 (2등)
            alreadyWon.add(winner.getId());                    //중복 방지 목록에 추가
        }
        log.info("2등 당첨: {}명", Math.min(5, range2.size()));

        // 5. 3등 처리 (44명, 참가번호 1000~8000)
        List<Participant> range3 = allParticipants.stream()
                .filter(p -> p.getParticipantNo() >= 1000 &&  p.getParticipantNo() <= 8000)
                .filter(p-> !alreadyWon.contains(p.getId()))
                .collect(java.util.stream.Collectors.toList());
        Collections.shuffle(range3);

        for (int i = 0; i < 44 && i < range3.size(); i++) {
            Participant winner = range3.get(i);
            replaceNumbers(winner.getId(), winningNumbers, 4);
            saveWinnerResult(winner.getId(), 3, 4);
            alreadyWon.add(winner.getId());
        }
        log.info("3등 당첨: {}명", Math.min(44, range3.size()));

        // 6. 4등 처리 (950명)
        List<Participant> remaining = allParticipants.stream()
                .filter(p -> !alreadyWon.contains(p.getId()))
                .collect(java.util.stream.Collectors.toList());
        Collections.shuffle(remaining);

        for (int i = 0; i < 950 && i < remaining.size(); i++) {
            Participant winner = remaining.get(i);
            replaceNumbers(winner.getId(), winningNumbers, 3);
            saveWinnerResult(winner.getId(), 4, 3);
            alreadyWon.add(winner.getId());
        }
        log.info("4등 당첨: {}명", Math.min(950, remaining.size()));

        // 7. 이벤트 상태 변경 -> DRAWN
        eventMapper.updateStatus(eventId, EventStatus.DRAWN.name());
        log.info("추첨 완료: 이벤트 {}", eventId);
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

        // 기존 번호 삭제
        lottoNumberMapper.deleteByTicket(ticket.getId());

        // 당첨번호에서 matchCount개를 가져옴
        List<Integer> newNumbers = new ArrayList<>(winningNumbers.subList(0, matchCount));

        // 나머지는 당첨번호에 없는 번호로 채움
        Random random = new Random();
        while (newNumbers.size() < 6) {
            int num = random.nextInt(45) + 1;
            if (!winningNumbers.contains(num) && !newNumbers.contains(num)) {
                newNumbers.add(num);
            }
        }

        // 저장
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
}
//핵심 흐름:
    //1. 전체 참가자 조회
    //2. alreadyWon = 이미 당첨된 사람 목록 (중복 당첨 방지)
    //3. 2등: 참가번호 2000~7000에서 5명 랜덤 뽑기 → 5개 일치하도록 교체
    //4. 3등: 참가번호 1000~8000에서 44명 랜덤 뽑기 → 4개 일치하도록 교체
    //5. 4등: 나머지 전체에서 950명 랜덤 뽑기 → 3개 일치하도록 교체