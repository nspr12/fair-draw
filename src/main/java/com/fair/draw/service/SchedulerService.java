package com.fair.draw.service;

import com.fair.draw.domain.Event;
import com.fair.draw.mapper.EventMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.Clock;
import java.time.LocalDate;

@Slf4j
@Service
@RequiredArgsConstructor
public class SchedulerService {

    private final Clock clock;  //Clock 주입 추가
    private final EventMapper eventMapper;
    private final ResultService resultService;

    /*
     * 매일 자정에 실행
     * 발표일 + 10일 경과 시 미확인 당첨자에게 리마인드 문자 발송
     */
    @Scheduled(cron = "0 0 0 * * *")
    public void sendRemindToUncheckedWinners() {
        log.info("[스케줄러] 미확인 당첨자 리마인드 체크 시작");

        Event event = eventMapper.findById(1L);
        if (event == null || event.getDrawDate() == null) {
            log.info("[스케줄러] 추첨된 이벤트가 없습니다.");
            return;
        }

        // 변경: Clock 사용 + announceStartDate 기반으로 리마인드 날짜 계산
        LocalDate remindDate = event.getAnnounceStartDate() != null
                ? event.getAnnounceStartDate().plusDays(10)
                : event.getDrawDate().plusDays(10);

        LocalDate today = LocalDate.now(clock);  // 변경: clock 사용
        if (today.isBefore(remindDate)) {
            log.info("[스케줄러] 리마인드 발송일({})이 아직 도래하지 않았습니다.", remindDate);
            return;
        }

        int count = resultService.sendRemindToUncheckedWinners(event.getId());
        log.info("[스케줄러] 미확인 당첨자 {}명에게 리마인드 발송 완료", count);
    }
}