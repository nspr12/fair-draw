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
-- 이벤트 참가자
-- =====================================================
CREATE TABLE participant (
                             id BIGINT NOT NULL AUTO_INCREMENT COMMENT '참가자 ID',
                             event_id BIGINT NOT NULL COMMENT '이벤트 ID',
                             participant_no INT NOT NULL COMMENT '참여 순번',
                             phone_number VARCHAR(100) NOT NULL COMMENT '휴대폰 번호',
                             is_verified BOOLEAN NOT NULL DEFAULT FALSE COMMENT '인증 여부',
                             check_count INT NOT NULL DEFAULT 0 COMMENT '결과 확인 횟수',
                             last_checked_at DATETIME NULL COMMENT '최종 확인 일시',
                             created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
                             PRIMARY KEY (id),
                             CONSTRAINT fk_participant_event
                                 FOREIGN KEY (event_id) REFERENCES event(id),
                             CONSTRAINT uk_event_phone UNIQUE (event_id, phone_number),
                             CONSTRAINT uk_event_participant_no UNIQUE (event_id, participant_no),
                             INDEX idx_participant_event (event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='이벤트 참가자';

-- =====================================================
-- 로또 발권 정보
-- =====================================================
CREATE TABLE lotto_ticket (
                              id BIGINT NOT NULL AUTO_INCREMENT COMMENT '티켓 ID',
                              participant_id BIGINT NOT NULL COMMENT '참가자 ID',
                              is_predefined BOOLEAN NOT NULL DEFAULT FALSE COMMENT '사전 지정 당첨 여부',
                              created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
                              PRIMARY KEY (id),
                              CONSTRAINT fk_ticket_participant
                                  FOREIGN KEY (participant_id) REFERENCES participant(id),
                              CONSTRAINT uk_ticket_participant UNIQUE (participant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='로또 발권 정보';

-- =====================================================
-- 로또 발급 번호
-- =====================================================
CREATE TABLE lotto_number (
                              id BIGINT NOT NULL AUTO_INCREMENT COMMENT '번호 ID',
                              ticket_id BIGINT NOT NULL COMMENT '티켓 ID',
                              number TINYINT NOT NULL COMMENT '로또 번호 (1~45)',
                              PRIMARY KEY (id),
                              CONSTRAINT fk_lotto_ticket
                                  FOREIGN KEY (ticket_id) REFERENCES lotto_ticket(id),
                              CONSTRAINT uk_ticket_number UNIQUE (ticket_id, number),
                              INDEX idx_ticket_id (ticket_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='로또 발급 번호';

-- =====================================================
-- 당첨 번호
-- =====================================================
CREATE TABLE winning_number (
                                id BIGINT NOT NULL AUTO_INCREMENT COMMENT '당첨번호 ID',
                                event_id BIGINT NOT NULL COMMENT '이벤트 ID',
                                number TINYINT NOT NULL COMMENT '당첨 번호 (1~45)',
                                PRIMARY KEY (id),
                                CONSTRAINT fk_winning_event
                                    FOREIGN KEY (event_id) REFERENCES event(id),
                                CONSTRAINT uk_event_number UNIQUE (event_id, number),
                                INDEX idx_winning_event (event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='당첨 번호';

-- =====================================================
-- 당첨 결과
-- =====================================================
CREATE TABLE winner_result (
                               id BIGINT NOT NULL AUTO_INCREMENT COMMENT '당첨 결과 ID',
                               participant_id BIGINT NOT NULL COMMENT '참가자 ID',
                               rank_type INT NOT NULL COMMENT '당첨 등수 (1~4)',
                               matched_count INT NOT NULL COMMENT '일치 개수',
                               prize_status VARCHAR(20) NOT NULL DEFAULT 'READY' COMMENT '경품 지급 상태',
                               created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
                               PRIMARY KEY (id),
                               CONSTRAINT fk_winner_participant
                                   FOREIGN KEY (participant_id) REFERENCES participant(id),
                               CONSTRAINT uk_winner_participant UNIQUE (participant_id),
                               INDEX idx_rank_type (rank_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='당첨 결과';

-- =====================================================
-- 결과 확인 이력
-- =====================================================
CREATE TABLE result_check_log (
                                  id BIGINT NOT NULL AUTO_INCREMENT COMMENT '확인 이력 ID',
                                  participant_id BIGINT NOT NULL COMMENT '참가자 ID',
                                  checked_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '확인 일시',
                                  PRIMARY KEY (id),
                                  CONSTRAINT fk_check_participant
                                      FOREIGN KEY (participant_id) REFERENCES participant(id),
                                  INDEX idx_check_participant (participant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='결과 확인 이력';


CREATE TABLE sms_log (
                         id BIGINT NOT NULL AUTO_INCREMENT COMMENT '문자 로그 ID',
                         participant_id BIGINT NOT NULL COMMENT '참가자 ID',
                         phone_number VARCHAR(100) NOT NULL COMMENT '수신 번호',
                         message_type VARCHAR(20) NOT NULL COMMENT '메시지 유형',
                         content TEXT NOT NULL COMMENT '메시지 내용',
                         send_status VARCHAR(20) NOT NULL DEFAULT 'SUCCESS' COMMENT '발송 상태',
                         sent_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '발송 일시',
                         PRIMARY KEY (id),
                         CONSTRAINT fk_sms_participant
                             FOREIGN KEY (participant_id) REFERENCES participant(id),
                         INDEX idx_sms_participant (participant_id),
                         INDEX idx_sms_sent_at (sent_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='문자 발송 이력';

-- =====================================================
-- 이벤트당첨정책
-- =====================================================
CREATE TABLE prize_policy (
                              id BIGINT AUTO_INCREMENT PRIMARY KEY,
                              event_id BIGINT NOT NULL,
                              rank_type INT NOT NULL,
                              prize_count INT NOT NULL,
                              match_count INT NOT NULL,
                              start_no INT DEFAULT NULL,
                              end_no INT DEFAULT NULL,
                              description VARCHAR(100),
                              FOREIGN KEY (event_id) REFERENCES event(id)
);