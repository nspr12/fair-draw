package com.lotto.event.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    /**
     * 메인 페이지 - 이벤트 기간/발표 기간에 따라 분기
     */
    @GetMapping("/")
    public String index() {
        return "index";
    }

    /**
     * 이벤트 참가 페이지
     */
    @GetMapping("/participate")
    public String participate() {
        return "participate";
    }

    /**
     * 결과 확인 페이지
     */
    @GetMapping("/result")
    public String result() {
        return "result";
    }
}