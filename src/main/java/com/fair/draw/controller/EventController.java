package com.fair.draw.controller;

import com.fair.draw.domain.Event;
import com.fair.draw.dto.ParticipantRequest;
import com.fair.draw.dto.ApiResponse;
import com.fair.draw.dto.ParticipantResponse;
import com.fair.draw.dto.ResultResponse;
import com.fair.draw.mapper.EventMapper;
import com.fair.draw.mapper.EventPrizeMapper;
import com.fair.draw.service.EventParticipantService;
import com.fair.draw.service.ResultService;
import com.fair.draw.service.VerificationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Clock;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/event")
@RequiredArgsConstructor
public class EventController {

    private final Clock clock;  // 추가
    private final EventParticipantService participantService;
    private final VerificationService verificationService;
    private final ResultService resultService;
    private final EventMapper eventMapper;       //추가
    private final EventPrizeMapper eventPrizeMapper; //추가: 총 추첨인원 계산용

    //인증번호 발송
    @PostMapping("/verify/send")
    public ResponseEntity<ApiResponse<Void>> sendVerification(@RequestParam String phoneNumber) {
        verificationService.sendVerificationCode(phoneNumber);
        return ResponseEntity.ok(ApiResponse.ok("인증번호가 발송되었습니다.", null));
    }

    //이벤트 참가
    @PostMapping("/participate")
    public ResponseEntity<ApiResponse<ParticipantResponse>> participate(
            @Valid @RequestBody ParticipantRequest request) {
        ParticipantResponse response = participantService.participate(request);
        return ResponseEntity.ok(ApiResponse.ok("이벤트 참가 완료", response));
    }

    //결과 확인
    @GetMapping("/result")
    public ResponseEntity<ApiResponse<ResultResponse>> checkResult(
            @RequestParam Long eventId,
            @RequestParam String phoneNumber) {
        ResultResponse response = resultService.checkResult(eventId, phoneNumber);
        return ResponseEntity.ok(ApiResponse.ok(response));
    }

/*  변경: 메서드 전체 수정 — simulatedDate 제거, clock 사용
    하드코딩 날짜는 DB 조회로 변경 예정, 지금은 clock만 적용) */

    // -> 변경: 하드코딩 날짜 전부 제거, DB 조회로 변경
    @GetMapping("/status")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getEventStatus(
            @RequestParam Long eventId) {

        // 1. DB에서 이벤트 조회
        Event event = eventMapper.findById(eventId);
        if (event == null) {
            throw new IllegalArgumentException("존재하지 않는 이벤트입니다.");
        }

        // 2. Clock에서 현재 날짜 조회
        LocalDate today = LocalDate.now(clock);

        // 3. DB에서 가져온 날짜로 기간 판별 (하드코딩 완전 제거!)
        LocalDate eventStart = event.getStartDate();
        LocalDate eventEnd = event.getEndDate();
        LocalDate announceStart = event.getAnnounceStartDate();
        LocalDate announceEnd = event.getAnnounceEndDate();

        String period;
        if (today.isBefore(eventStart)) {
            period = "BEFORE_EVENT";
        } else if (!today.isAfter(eventEnd)) {
            period = "EVENT_PERIOD";
        } else if (announceStart != null && today.isBefore(announceStart)) {
            period = "BETWEEN";
        } else if (announceEnd != null && !today.isAfter(announceEnd)) {
            period = "ANNOUNCE_PERIOD";
        } else {
            period = "FINISHED";
        }

        // 4. 총 추첨인원 계산 (EventPrize의 prize_count 합산)
        int totalPrizeCount = eventPrizeMapper.findByEvent(eventId)
                .stream()
                .mapToInt(p -> p.getPrizeCount())
                .sum();

        // 5. 응답 구성 — 프론트에서 이벤트 정보를 풍부하게 표시 가능
        Map<String, Object> result = new HashMap<>();
        result.put("currentDate", today.toString());
        result.put("period", period);
        result.put("periodLabel", getPeriodLabel(period));

        // 이벤트 상세 정보 추가
        result.put("title", event.getTitle());
        result.put("description", event.getDescription());
        result.put("thumbnailUrl", event.getThumbnailUrl());
        result.put("startDate", eventStart.toString());
        result.put("endDate", eventEnd.toString());
        result.put("drawDate", event.getDrawDate() != null ? event.getDrawDate().toString() : null);
        result.put("announceStartDate", announceStart != null ? announceStart.toString() : null);
        result.put("announceEndDate", announceEnd != null ? announceEnd.toString() : null);
        result.put("totalPrizeCount", totalPrizeCount);
        result.put("maxParticipants", event.getMaxParticipants());

        return ResponseEntity.ok(ApiResponse.ok(result));
    }

    private String getPeriodLabel(String period) {
        switch (period) {
            case "BEFORE_EVENT":
                return "이벤트 시작 전";
            case "EVENT_PERIOD":
                return "이벤트 진행중";
            case "BETWEEN":
                return "이벤트 종료 (발표 대기)";
            case "ANNOUNCE_PERIOD":
                return "발표 기간";
            case "FINISHED":
                return "이벤트 종료";
            default:
                return "알 수 없음";
        }
    }
}
