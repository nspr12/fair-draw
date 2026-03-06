package com.fair.draw.config;

import java.time.*;

// Clock을 상속해서 개발 중에는 날짜를 자유롭게 바꿀 수 있고,
// 프로덕션에서는 실제 시간으로 동작하는 래퍼 클래스
public class MutableClock extends Clock {

    private Clock delegate;

    public MutableClock() {
        this.delegate = Clock.systemDefaultZone();
    }

    public void setFixed(LocalDate date) {
        this.delegate = Clock.fixed(
                date.atStartOfDay(ZoneId.systemDefault()).toInstant(),
                ZoneId.systemDefault()
        );
    }

    public void reset() {
        this.delegate = Clock.systemDefaultZone();
    }

    public LocalDate getCurrentDate() {
        return LocalDate.now(this.delegate);
    }

    @Override
    public ZoneId getZone() { return delegate.getZone(); }

    @Override
    public Clock withZone(ZoneId zone) { return delegate.withZone(zone); }

    @Override
    public Instant instant() { return delegate.instant(); }
}