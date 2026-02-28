-- =====================================================
-- 1. 이벤트 정보 (유지)
-- =====================================================
CREATE TABLE event (
                       id BIGINT NOT NULL AUTO_INCREMENT COMMENT '이벤트 ID',
                       title VARCHAR(100) NOT NULL COMMENT '이벤트 제목',
                       start_date DATE NOT NULL COMMENT '이벤트 시작일',
                       end_date DATE NOT NULL COMMENT '이벤트 종료일',
                       draw_date DATE NOT NULL COMMENT '추첨일',
                       status VARCHAR(20) NOT NULL DEFAULT 'READY' COMMENT '이벤트 상태',
                       created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
                       updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
                       PRIMARY KEY (id),
                       INDEX idx_event_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='이벤트 정보';

-- =====================================================
-- 2. 이벤트 경품 정책 (핵심: 기존 prize_policy 대체)
-- =====================================================
CREATE TABLE event_prize (
                             id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '경품 정책 ID',
                             event_id BIGINT NOT NULL COMMENT '이벤트 ID',
                             rank_type INT NOT NULL COMMENT '등수 또는 티어',
                             prize_name VARCHAR(100) NOT NULL COMMENT '경품 이름 (예: 조던 1 시카고)',
                             prize_count INT NOT NULL COMMENT '당첨 제한 수량 (T/O)',
                             CONSTRAINT fk_prize_event FOREIGN KEY (event_id) REFERENCES event(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='이벤트 당첨/경품 정책';

-- =====================================================
-- 3. 이벤트 참가자 (튜닝: participant_no 삭제, phone_number 중심)
-- =====================================================
CREATE TABLE participant (
                             id BIGINT NOT NULL AUTO_INCREMENT COMMENT '참가자 ID',
                             event_id BIGINT NOT NULL COMMENT '이벤트 ID',
                             phone_number VARCHAR(100) NOT NULL COMMENT '휴대폰 번호',
                             is_verified BOOLEAN NOT NULL DEFAULT FALSE COMMENT '인증 여부',
                             created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
                             PRIMARY KEY (id),
                             CONSTRAINT fk_participant_event FOREIGN KEY (event_id) REFERENCES event(id),
                             CONSTRAINT uk_event_phone UNIQUE (event_id, phone_number),
                             INDEX idx_participant_event (event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='이벤트 참가자';

-- =====================================================
-- 4. 최종 당첨자 결과 (튜닝: 기존 winner_result 대체)
-- =====================================================
CREATE TABLE winner (
                        id BIGINT NOT NULL AUTO_INCREMENT COMMENT '당첨 결과 ID',
                        participant_id BIGINT NOT NULL COMMENT '참가자 ID',
                        prize_id BIGINT NOT NULL COMMENT '당첨된 경품 ID (event_prize 참조)',
                        prize_status VARCHAR(20) NOT NULL DEFAULT 'UNCHECKED' COMMENT '상태(UNCHECKED, CHECKED, SENT)',
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
                        PRIMARY KEY (id),
                        CONSTRAINT fk_winner_participant FOREIGN KEY (participant_id) REFERENCES participant(id),
                        CONSTRAINT fk_winner_prize FOREIGN KEY (prize_id) REFERENCES event_prize(id),
                        CONSTRAINT uk_winner_participant UNIQUE (participant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='최종 당첨자 결과';

-- =====================================================
-- 5. 결과 확인 이력 (유지)
-- =====================================================
CREATE TABLE result_check_log (
                                  id BIGINT NOT NULL AUTO_INCREMENT COMMENT '확인 이력 ID',
                                  participant_id BIGINT NOT NULL COMMENT '참가자 ID',
                                  checked_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '확인 일시',
                                  PRIMARY KEY (id),
                                  CONSTRAINT fk_check_participant FOREIGN KEY (participant_id) REFERENCES participant(id),
                                  INDEX idx_check_participant (participant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='결과 확인 이력';

-- =====================================================
-- 6. 문자 발송 이력 (유지)
-- =====================================================
CREATE TABLE sms_log (
                         id BIGINT NOT NULL AUTO_INCREMENT COMMENT '문자 로그 ID',
                         participant_id BIGINT NOT NULL COMMENT '참가자 ID',
                         phone_number VARCHAR(100) NOT NULL COMMENT '수신 번호',
                         message_type VARCHAR(20) NOT NULL COMMENT '메시지 유형',
                         content TEXT NOT NULL COMMENT '메시지 내용',
                         send_status VARCHAR(20) NOT NULL DEFAULT 'SUCCESS' COMMENT '발송 상태',
                         sent_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '발송 일시',
                         PRIMARY KEY (id),
                         CONSTRAINT fk_sms_participant FOREIGN KEY (participant_id) REFERENCES participant(id),
                         INDEX idx_sms_participant (participant_id),
                         INDEX idx_sms_sent_at (sent_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='문자 발송 이력';