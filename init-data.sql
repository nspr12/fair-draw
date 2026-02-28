-- 테스트용 이벤트 등록
INSERT INTO event (title, start_date, end_date, draw_date, status)
VALUES ('2026 FairDraw 한정판 추첨 이벤트', '2026-02-01', '2026-03-31', '2026-04-01', 'ACTIVE');

-- 이벤트 경품 정책 등록 (로또식 번호 맞추기가 아닌, 수량 할당)
INSERT INTO event_prize (event_id, rank_type, prize_name, prize_count) VALUES
                                                                           (1, 1, '애플 아이패드 프로 11인치', 1),
                                                                           (1, 2, '에어팟 프로 2세대', 5),
                                                                           (1, 3, '신세계 상품권 5만원권', 44),
                                                                           (1, 4, '스타벅스 아이스 아메리카노 T', 950);