//이벤트 참가 서비스
package com.lotto.event.service;

import com.lotto.event.domain.*;
import com.lotto.event.dto.ParticipantRequest;
import com.lotto.event.dto.ParticipantResponse;
import com.lotto.event.enums.EventStatus;
import com.lotto.event.enums.MessageType;
import com.lotto.event.mapper.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class EventParticipantService {

    private static final int MAX_PARTICIPANTS = 10000;
    private static final int LOTTO_NUMBER_COUNT = 6;
    private static final int LOTTO_MIN = 1;
    private static final int LOTTO_MAX = 45;

    private final EventMapper eventMapper;
    private final ParticipantMapper participantMapper;
    private final LottoTicketMapper lottoTicketMapper;
    private final LottoNumberMapper lottoNumberMapper;
    private final VerificationService verificationService;
    private final SmsService smsService;

    // 이벤트 참가 처리
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

        // 2. 휴대폰 인증
        boolean verified = verificationService.verify(request.getPhoneNumber(), request.getVerificationCode());
        if (!verified) {
            throw new IllegalArgumentException("인증번호가 올바르지 않습니다.");
        }

        // 3. 중복 참여 체크
        Participant existing = participantMapper.findByEventAndPhone(
                request.getEventId(), request.getPhoneNumber());
        if (existing != null) {
            throw new IllegalStateException("이미 참가한 휴대폰 번호입니다.");
        }

        // 4. 참가 인원 제한
        int currentCount = participantMapper.countByEventForUpdate(request.getEventId());
        if (currentCount >= MAX_PARTICIPANTS) {
            throw new IllegalStateException("참가 인원이 마감되었습니다.");
        }

        // 5. 참가자 등록
        int nextNo = participantMapper.getMaxParticipantNo(request.getEventId()) + 1;

        Participant participant = new Participant();
        participant.setEventId(request.getEventId());
        participant.setParticipantNo(nextNo);
        participant.setPhoneNumber(request.getPhoneNumber());
        participant.setIsVerified(true);
        participant.setCheckCount(0);
        participantMapper.insert(participant);

        // 6. 로또 번호 생성 및 저장
        List<Integer> numbers = generateLottoNumbers();

        LottoTicket ticket = new LottoTicket();
        ticket.setParticipantId(participant.getId());
        ticket.setIsPredefined(false);
        lottoTicketMapper.insert(ticket);

        for (Integer number : numbers) {
            LottoNumber lottoNumber = new LottoNumber();
            lottoNumber.setTicketId(ticket.getId());
            lottoNumber.setNumber(number);
            lottoNumberMapper.insert(lottoNumber);
        }

        // 7. 문자 발송
        String numberStr = numbers.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(", "));
        String message = String.format("[로또 이벤트] 참가번호 %d번, 발급번호: [%s]", nextNo, numberStr);
        smsService.send(participant.getId(), request.getPhoneNumber(),
                MessageType.LOTTO_NUMBER.name(), message);

        return ParticipantResponse.builder()
                .participantId(participant.getId())
                .participantNo(nextNo)
                .lottoNumbers(numbers)
                .message("이벤트 참가가 완료되었습니다.")
                .build();
    }

    // 로또 번호 6개 생성 (1~45, 중복 없이, 오름차순)
    private List<Integer> generateLottoNumbers() {
        Set<Integer> numberSet = new TreeSet<>();
        Random random = new Random();

        while (numberSet.size() < LOTTO_NUMBER_COUNT) {
            numberSet.add(random.nextInt(LOTTO_MAX) + LOTTO_MIN);
        }

        return new ArrayList<>(numberSet);
    }
}
