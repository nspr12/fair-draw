package com.fair.draw.enums;

//경품지급상태
public enum PrizeStatus {
    UNCHECKED,  // 당첨됨 (사용자가 아직 결과창 안 봄) -> 리마인드 문자 발송 대상!
    CHECKED,    // 사용자가 결과창 확인 완료 (지급 대기중)
    SENT,       // 관리자가 경품 지급 완료
    FAILED      // 지급 실패 (연락처 오류 등)
}
