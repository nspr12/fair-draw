package com.fair.draw.service;

import com.fair.draw.domain.Participant;
import com.fair.draw.domain.Winner;
import com.fair.draw.dto.ResultResponse;
import com.fair.draw.enums.MessageType;
import com.fair.draw.enums.PrizeStatus;
import com.fair.draw.mapper.ParticipantMapper;
import com.fair.draw.mapper.ResultCheckLogMapper;
import com.fair.draw.mapper.WinnerMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ResultService {

    private final ParticipantMapper participantMapper;
    private final WinnerMapper winnerMapper;
    private final ResultCheckLogMapper resultCheckLogMapper;
    private final SmsService smsService;

    @Transactional
    public ResultResponse checkResult(Long eventId, String phoneNumber) {

        // 1. 참가자 조회 (응모 내역 확인)
        Participant participant = participantMapper.findByEventAndPhone(eventId, phoneNumber);
        if (participant == null) {
            throw new IllegalArgumentException("해당 이벤트에 응모한 내역이 없습니다.");
        }

        // 2. 결과 확인 이력(로그) 저장
        resultCheckLogMapper.insert(participant.getId());

        // 3. 당첨 여부 확인 (핵심: 로또 번호 비교 폐기, 상태값 조회로 단순화)
        Winner winner = winnerMapper.findByParticipant(participant.getId());

        if (winner != null) {
            // 미확인(UNCHECKED) 상태라면 확인 완료(CHECKED)로 업데이트
            if (PrizeStatus.UNCHECKED.name().equals(winner.getPrizeStatus())) {
                winnerMapper.updatePrizeStatus(winner.getId(), PrizeStatus.CHECKED.name());
            }
            return ResultResponse.builder()
                    .isWinner(true)
                    .message("🎉 축하합니다! 한정판 드로우에 당첨되셨습니다!")
                    .build();
        } else {
            return ResultResponse.builder()
                    .isWinner(false)
                    .message("아쉽지만 이번 드로우에는 당첨되지 않았습니다. 다음 기회를 노려주세요!")
                    .build();
        }
    }

    // 미확인 당첨자에게 리마인드 문자 발송
    @Transactional
    public int sendRemindToUncheckedWinners(Long eventId) {
        // XML에서 만들어둔 '미확인자 ID 목록 조회' 쿼리 사용
        List<Long> uncheckedIds = winnerMapper.findUncheckedParticipantIds(eventId);

        for (Long pId : uncheckedIds) {
            Participant p = participantMapper.findById(pId);
            smsService.send(
                    p.getId(),
                    p.getPhoneNumber(),
                    MessageType.CHECK_REMIND.name(),
                    "[FairDraw] 당첨 결과를 아직 확인하지 않으셨습니다. 홈페이지에서 확인해주세요!"
            );
        }

        log.info("미확인 당첨자 리마인드 발송: {}명", uncheckedIds.size());
        return uncheckedIds.size();
    }
}