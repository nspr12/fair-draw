package com.lotto.event.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDate;

@Controller
public class PageController {

    // 메인 페이지 - 이벤트 기간/발표 기간에 따라 분기
    @GetMapping("/")
    //실제 운영 시 날짜 기반으로 자동 리다이렉트
    public String index() {
        LocalDate today = LocalDate.now();
        LocalDate eventStart = LocalDate.of(2025, 2, 1);
        LocalDate eventEnd = LocalDate.of(2025, 3, 31);
        LocalDate announceStart = LocalDate.of(2025, 4, 1);
        LocalDate announceEnd = LocalDate.of(2025, 4, 15);

        if (!today.isBefore(eventStart) && !today.isAfter(eventEnd)) {
            return "redirect:/participate";
        } else if (!today.isBefore(announceStart) && !today.isAfter(announceEnd)) {
            return "redirect:/result";
        }
        return "index";
    }

    // 이벤트 참가 페이지

    @GetMapping("/participate")
    public String participate() {
        return "participate";
    }

    //결과 확인 페이지

    @GetMapping("/result")
    public String result() {
        return "result";
    }
}