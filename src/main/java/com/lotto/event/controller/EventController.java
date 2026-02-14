package com.lotto.event.controller;

import com.lotto.event.dto.ParticipantRequest;
import com.lotto.event.dto.ApiResponse;
import com.lotto.event.dto.ParticipantResponse;
import com.lotto.event.dto.ResultResponse;
import com.lotto.event.service.EventParticipantService;
import com.lotto.event.service.ResultService;
import com.lotto.event.service.VerificationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/event")
@RequiredArgsConstructor
public class EventController {

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
}