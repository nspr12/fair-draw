package com.fair.draw.service;

import com.fair.draw.domain.Event;
import com.fair.draw.domain.Participant;
import com.fair.draw.dto.ParticipantRequest;
import com.fair.draw.dto.ParticipantResponse;
import com.fair.draw.enums.EventStatus;
import com.fair.draw.enums.MessageType;
import com.fair.draw.mapper.EventMapper;
import com.fair.draw.mapper.ParticipantMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class EventParticipantService {

    private static final int MAX_PARTICIPANTS = 100000; // 최대 10만 명으로 확장

    private final EventMapper eventMapper;
    private final ParticipantMapper participantMapper;
    private final VerificationService verificationService;
    private final SmsService smsService;

    // 이벤트 참가 처리 (동시성 방어 로직 적용)
    @Transactional
    public ParticipantResponse participate(ParticipantRequest request) {

        // 1. 이벤트 검증
        Event event = eventMapper.findById(request.getEventId());
        if (event == null) {
            throw new IllegalArgumentException("존재하지 않는 이벤트입니다.");
        }
        if (!EventStatus.ACTIVE.name().equals(event.getStatus())) {
            throw new IllegalStateException("현재 참가 가능한 이벤트가 아닙니다.");
        }

        // 2. 휴대폰 인증 검증
        boolean verified = verificationService.verify(request.getPhoneNumber(), request.getVerificationCode());
        if (!verified) {
            throw new IllegalArgumentException("인증번호가 올바르지 않습니다.");
        }

        // 3. 중복 참여 원천 차단 (1인 1계정 원칙)
        Participant existing = participantMapper.findByEventAndPhone(request.getEventId(), request.getPhoneNumber());
        if (existing != null) {
            throw new IllegalStateException("이미 응모가 완료된 휴대폰 번호입니다.");
        }

        // 4. [핵심] 참가 인원 제한 & 동시성 제어 (비관적 락 - FOR UPDATE)
        // 수천 명이 동시에 클릭해도 DB 단에서 줄을 세워 정확하게 카운트.
        int currentCount = participantMapper.countByEventForUpdate(request.getEventId());
        if (currentCount >= MAX_PARTICIPANTS) {
            throw new IllegalStateException("죄송합니다. 이벤트 참가 인원이 마감되었습니다.");
        }

        // 5. 로또 번호 발급 로직 삭제 -> 깔끔하게 참가자 정보만 DB에 Insert
        Participant participant = new Participant();
        participant.setEventId(request.getEventId());
        participant.setPhoneNumber(request.getPhoneNumber());
        participant.setIsVerified(true);
        participantMapper.insert(participant);

        // 6. 응모 완료 리마인드 문자 발송 (불필요한 중복 클릭 방지)
        String message = "[FairDraw] 한정판 드로우 이벤트 응모가 완료되었습니다. 추첨일을 기대해 주세요!";
        smsService.send(participant.getId(), request.getPhoneNumber(),
                MessageType.PARTICIPATION_COMPLETE.name(), message);

        // 7. 프론트엔드에 깔끔한 응답 반환 (더 이상 발급 번호를 주지 않음)
        return ParticipantResponse.builder()
                .participantId(participant.getId())
                .message("이벤트 참가가 성공적으로 완료되었습니다.")
                .build();
    }
}