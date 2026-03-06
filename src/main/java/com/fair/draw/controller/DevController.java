package com.fair.draw.controller;

import com.fair.draw.config.MutableClock;
import com.fair.draw.dto.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Profile;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

// @Profile("dev") → 배포 환경에서는 이 컨트롤러 자체가 존재하지 않음
// admin.jsp에서 날짜 바꿔가며 테스트하던 것을 이 API로 대체
@Profile("dev")
@RestController
@RequestMapping("/api/dev")
@RequiredArgsConstructor
public class DevController {

    private final MutableClock mutableClock;

    @PostMapping("/time")
    public ResponseEntity<ApiResponse<String>> setTime(@RequestParam String date) {
        mutableClock.setFixed(LocalDate.parse(date));
        return ResponseEntity.ok(ApiResponse.ok("서버 시간 변경: " + date, null));
    }

    @PostMapping("/time/reset")
    public ResponseEntity<ApiResponse<String>> resetTime() {
        mutableClock.reset();
        return ResponseEntity.ok(ApiResponse.ok("실제 시간으로 복구", null));
    }

    @GetMapping("/time")
    public ResponseEntity<ApiResponse<String>> getTime() {
        return ResponseEntity.ok(ApiResponse.ok(mutableClock.getCurrentDate().toString(), null));
    }
}