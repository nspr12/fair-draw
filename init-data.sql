-- 테스트용 이벤트 등록
INSERT INTO event (title, start_date, end_date, draw_date, status)
VALUES ('2025 로또 이벤트', '2025-02-01', '2025-03-31', '2025-04-01', 'ACTIVE');

-- 이벤트당첨정책
INSERT INTO prize_policy (event_id, rank_type, prize_count, match_count, start_no, end_no, description) VALUES
                                                                                                            (1, 1, 1, 6, NULL, NULL, '1등 - 사전지정'),
                                                                                                            (1, 2, 5, 5, 2000, 7000, '2등 - 참가번호 2000~7000'),
                                                                                                            (1, 3, 44, 4, 1000, 8000, '3등 - 참가번호 1000~8000'),
                                                                                                            (1, 4, 950, 3, NULL, NULL, '4등 - 전체 범위');