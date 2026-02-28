package com.fair.draw.service;

import com.fair.draw.domain.*;
import com.fair.draw.mapper.*;
import com.fair.draw.dto.ResultResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.fair.draw.enums.MessageType;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ResultService {

    //필드주입
    private final ParticipantMapper participantMapper;
    private final LottoTicketMapper lottoTicketMapper;
    private final LottoNumberMapper lottoNumberMapper;
    private final WinningNumberMapper winningNumberMapper;
    private final WinnerMapper winnerResultMapper;
    private final ResultCheckLogMapper resultCheckLogMapper;
    private final SmsService smsService;

    @Transactional
    public ResultResponse checkResult(Long eventId, String phoneNumber) {
        // 1. 참가자 조회
        Participant participant = participantMapper.findByEventAndPhone(eventId, phoneNumber);
        if (participant == null) {
            throw new IllegalArgumentException("참가 이력이 없는 번호입니다.");
        }

        // 2. 내 로또번호 조회
        LottoTicket ticket = lottoTicketMapper.findByParticipant(participant.getId());
        List<Integer> myNumbers = lottoNumberMapper.findByTicket(ticket.getId()).stream()
                .map(LottoNumber::getNumber)
                .collect(Collectors.toList());

        // 3. 당첨번호 조회
        List<Integer> winningNumbers = winningNumberMapper.findByEvent(eventId).stream()
                .map(WinningNumber::getNumber)
                .collect(Collectors.toList());

        // 4. 당첨 결과 조회
        Winner result = winnerResultMapper.findByParticipant(participant.getId());

        // 5. 확인 이력 저장 + 확인 횟수 증가
        resultCheckLogMapper.insert(participant.getId());
        int checkCount = participant.getCheckCount();
        participantMapper.incrementCheckCount(participant.getId());

        // 6. 응답 분기
        if (checkCount == 0) {
            // 최초 확인: 등수까지 공개
            if (result != null) {
                return ResultResponse.builder()
                        .isWinner(true)
                        .rankType(result.getRankType())
                        .matchedCount(result.getMatchedCount())
                        .myNumbers(myNumbers)
                        .winningNumbers(winningNumbers)
                        .message(result.getRankType() + "등에 당첨되었습니다! 축하합니다!")
                        .build();
            } else {
                return ResultResponse.builder()
                        .isWinner(false)
                        .myNumbers(myNumbers)
                        .winningNumbers(winningNumbers)
                        .message("아쉽지만 당첨되지 않았습니다.")
                        .build();
            }
        } else {
            // 두 번째 이후: 당첨/미당첨만
            if (result != null) {
                return ResultResponse.builder()
                        .isWinner(true)
                        .myNumbers(myNumbers)
                        .winningNumbers(winningNumbers)
                        .message("당첨된 이력이 있습니다.")
                        .build();
            } else {
                return ResultResponse.builder()
                        .isWinner(false)
                        .myNumbers(myNumbers)
                        .winningNumbers(winningNumbers)
                        .message("당첨되지 않았습니다.")
                        .build();
            }
        }
    }

    // 미확인 당첨자에게 리마인드 문자 발송
    @Transactional
    public int sendRemindToUncheckedWinners(Long eventId) {
        List<Participant> unchecked = participantMapper.findUncheckedWinners(eventId);

        for (Participant p : unchecked) {
            smsService.send(
                    p.getId(),
                    p.getPhoneNumber(),
                    MessageType.CHECK_REMIND.name(),
                    "[로또 이벤트] 당첨 결과를 아직 확인하지 않으셨습니다. 홈페이지에서 확인해주세요!"
            );
        }

        log.info("미확인 당첨자 리마인드 발송: {}명", unchecked.size());
        return unchecked.size();
    }
}