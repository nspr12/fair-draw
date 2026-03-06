package com.fair.draw.controller;

import com.fair.draw.dto.ParticipantRequest;
import com.fair.draw.dto.ApiResponse;
import com.fair.draw.dto.ParticipantResponse;
import com.fair.draw.dto.ResultResponse;
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
    @GetMapping("/status")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getEventStatus(
            @RequestParam(required = false) Long eventId) { // 변경: simulatedDate → eventId

        LocalDate today = LocalDate.now(clock); //변경 : clock 사용

//         ☆ TODO DB에서 조회하도록 변경 예정
        LocalDate eventStart = LocalDate.of(2026, 2, 1);            //
        LocalDate eventEnd = LocalDate.of(2026, 3, 31);             //
        LocalDate announceStart = LocalDate.of(2026, 4, 1);         //
        LocalDate announceEnd = LocalDate.of(2026, 4, 15);          //
        LocalDate remindDate = announceStart.plusDays(10);          //

        String period;
        if (today.isBefore(eventStart)) {
            period = "BEFORE_EVENT";
        } else if (!today.isAfter(eventEnd)) {
            period = "EVENT_PERIOD";
        } else if (today.isBefore(announceStart)) {
            period = "BETWEEN";
        } else if (!today.isAfter(announceEnd)) {
            period = "ANNOUNCE_PERIOD";
        } else {
            period = "FINISHED";
        }

        boolean isRemindDay = !today.isBefore(remindDate);

        Map<String, Object> result = new HashMap<>();
        result.put("currentDate", today.toString());
        result.put("period", period);
        result.put("isRemindDay", isRemindDay);
        result.put("periodLabel", getPeriodLabel(period));

        return ResponseEntity.ok(ApiResponse.ok(result));
    }

    private String getPeriodLabel(String period) {
        switch (period) {
            case "BEFORE_EVENT": return "이벤트 시작 전";
            case "EVENT_PERIOD": return "이벤트 진행중";
            case "BETWEEN": return "이벤트 종료 (발표 대기)";
            case "ANNOUNCE_PERIOD": return "발표 기간";
            case "FINISHED": return "이벤트 종료";
            default: return "알 수 없음";
        }
    }

}