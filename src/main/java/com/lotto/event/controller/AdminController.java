package com.lotto.event.controller;

import com.lotto.event.domain.Participant;
import com.lotto.event.dto.ApiResponse;
import com.lotto.event.dto.ParticipantRequest;
import com.lotto.event.enums.MessageType;
import com.lotto.event.mapper.ParticipantMapper;
import com.lotto.event.mapper.SmsLogMapper;
import com.lotto.event.mapper.WinnerResultMapper;
import com.lotto.event.service.DrawService;
import com.lotto.event.service.EventParticipantService;
import com.lotto.event.service.ResultService;
import com.lotto.event.service.SmsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final DrawService drawService;
    private final EventParticipantService participantService;  // 추가
    private final ParticipantMapper participantMapper;
    private final SmsService smsService;
    private final ResultService resultService;
    private final WinnerResultMapper winnerResultMapper;
    private final SmsLogMapper smsLogMapper;

    //추첨 실행
    @PostMapping("/draw")
    public ResponseEntity<ApiResponse<Void>> draw(
            @RequestParam Long eventId,
            @RequestParam String predefinedWinnerPhone) {
        drawService.draw(eventId, predefinedWinnerPhone);
        return ResponseEntity.ok(ApiResponse.ok("추첨이 완료되었습니다.", null));
    }

    ///테스트용 더미 참가자 대량 생성
    @PostMapping("/test/generate-participants")
    public ResponseEntity<ApiResponse<String>> generateTestParticipants(
            @RequestParam Long eventId,
            @RequestParam(defaultValue = "100") int count,
            @RequestParam(defaultValue = "0") int offset) {

        int created = 0;
        for (int i = offset; i < offset + count; i++) {
            String phone = String.format("010%08d", i);
            ParticipantRequest request = new ParticipantRequest();
            request.setEventId(eventId);
            request.setPhoneNumber(phone);
            request.setVerificationCode("123456");
            try {
                participantService.participate(request);
                created++;
            } catch (Exception e) {
                // 중복 등 에러는 무시
            }
        }
        return ResponseEntity.ok(ApiResponse.ok(created + "명 생성 완료", null));
    }

    // 미확인 당첨자 리마인드 문자 발송
    @PostMapping("/remind")
    public ResponseEntity<ApiResponse<String>> sendRemind(@RequestParam Long eventId) {
        int count = resultService.sendRemindToUncheckedWinners(eventId);
        return ResponseEntity.ok(ApiResponse.ok(count + "명에게 리마인드 발송 완료", null));
    }

    // DB 현황 조회
    @GetMapping("/dashboard")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getDashboard(
            @RequestParam Long eventId) {
        Map<String, Object> dashboard = new HashMap<>();
        dashboard.put("totalParticipants", participantMapper.countByEvent(eventId));
        dashboard.put("winnerCounts", winnerResultMapper.countByRank(eventId));
        dashboard.put("smsCount", smsLogMapper.countByEvent(eventId));
        return ResponseEntity.ok(ApiResponse.ok(dashboard));
    }

    //DB 초기화 (테스트용)
    @PostMapping("/reset")
    public ResponseEntity<ApiResponse<Void>> resetData(@RequestParam Long eventId) {
        drawService.resetEvent(eventId);
        return ResponseEntity.ok(ApiResponse.ok("데이터가 초기화되었습니다.", null));
    }
}
