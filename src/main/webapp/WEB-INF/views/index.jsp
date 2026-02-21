<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🎰 로또 이벤트</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .main-card {
            background: white;
            border-radius: 24px;
            padding: 50px 40px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            max-width: 560px;
            width: 90%;
        }
        .emoji-title { font-size: 64px; margin-bottom: 10px; }
        .btn-event {
            padding: 16px 40px;
            font-size: 18px;
            border-radius: 50px;
            font-weight: bold;
            margin: 8px;
            transition: transform 0.2s;
        }
        .btn-event:hover { transform: scale(1.05); }
        .btn-participate { background: #667eea; border: none; color: white; }
        .btn-participate:hover { background: #5a6fd6; color: white; }
        .btn-result { background: #f093fb; border: none; color: white; }
        .btn-result:hover { background: #e07eec; color: white; }
        .period-info {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 15px;
            margin: 20px 0;
            font-size: 14px;
            color: #666;
        }
        .admin-toggle {
            position: fixed;
            top: 15px;
            right: 15px;
            z-index: 1000;
            background: rgba(0,0,0,0.6);
            padding: 8px 16px;
            border-radius: 50px;
            display: flex;
            align-items: center;
            gap: 8px;
            color: white;
            font-size: 13px;
        }
        .form-check-input:checked { background-color: #f093fb; border-color: #f093fb; }
        .admin-panel {
            display: none;
            background: #2d2d2d;
            border-radius: 16px;
            padding: 24px;
            margin-top: 24px;
            text-align: left;
            color: white;
        }
        .admin-panel.active { display: block; }
        .admin-panel h5 { color: #f093fb; margin-bottom: 16px; }
        .admin-panel label { color: #ccc; font-size: 13px; }
        .admin-btn {
            border-radius: 8px;
            padding: 8px 16px;
            font-size: 13px;
            font-weight: bold;
            border: none;
            transition: transform 0.2s;
            width: 100%;
            margin-bottom: 8px;
        }
        .admin-btn:hover { transform: scale(1.02); }
        .btn-generate { background: #00b894; color: white; }
        .btn-draw { background: #e17055; color: white; }
        .btn-remind { background: #fdcb6e; color: #333; }
        .btn-dashboard { background: #74b9ff; color: white; }
        .btn-reset { background: #d63031; color: white; }
        .admin-result {
            background: #1a1a1a;
            border-radius: 8px;
            padding: 12px;
            margin-top: 12px;
            font-size: 13px;
            color: #a8edea;
            max-height: 200px;
            overflow-y: auto;
            white-space: pre-wrap;
        }
        .status-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 13px;
            font-weight: bold;
            margin: 8px 0;
        }
        .status-event { background: #00b894; color: white; }
        .status-announce { background: #f093fb; color: white; }
        .status-before { background: #636e72; color: white; }
        .status-between { background: #fdcb6e; color: #333; }
        .status-finished { background: #b2bec3; color: #333; }
        .date-buttons { display: flex; flex-wrap: wrap; gap: 6px; margin: 10px 0; }
        .date-btn {
            padding: 4px 10px;
            border-radius: 20px;
            border: 1px solid #555;
            background: transparent;
            color: #ccc;
            font-size: 12px;
            cursor: pointer;
        }
        .date-btn:hover, .date-btn.active { background: #f093fb; color: white; border-color: #f093fb; }
    </style>
</head>
<body>
<div class="admin-toggle">
    <span>🔧 관리자</span>
    <div class="form-check form-switch mb-0">
        <input class="form-check-input" type="checkbox" id="adminSwitch" onchange="toggleAdmin()">
    </div>
</div>

<div class="main-card">
    <div class="emoji-title">🎰</div>
    <h1 class="fw-bold mb-2">2025 로또 이벤트</h1>
    <p class="text-muted mb-3">무료 로또 번호를 받고 경품에 도전하세요!</p>

    <div class="period-info">
        📅 이벤트 기간: 2025.02.01 ~ 2025.03.31<br>
        📢 발표 기간: 2025.04.01 ~ 2025.04.15
    </div>

    <div id="statusArea"></div>
    <div id="userButtons" class="mt-4"></div>

    <div id="adminPanel" class="admin-panel">
        <h5>🔧 관리자 모드</h5>

        <label>📅 가상 날짜 설정</label>
        <input type="date" id="simulatedDate" class="form-control form-control-sm mb-2"
               onchange="updateStatus()" style="background:#444;color:white;border:1px solid #555;">

        <label>빠른 날짜 선택</label>
        <div class="date-buttons">
            <button class="date-btn" onclick="setDate('2025-01-15')">이벤트 전</button>
            <button class="date-btn" onclick="setDate('2025-02-15')">이벤트 중</button>
            <button class="date-btn" onclick="setDate('2025-03-31')">이벤트 마지막날</button>
            <button class="date-btn" onclick="setDate('2025-04-01')">발표 시작</button>
            <button class="date-btn" onclick="setDate('2025-04-11')">발표+10일</button>
            <button class="date-btn" onclick="setDate('2025-04-15')">발표 마지막</button>
            <button class="date-btn" onclick="setDate('2025-04-20')">종료 후</button>
        </div>

        <hr style="border-color:#555;">
        <label>⚙️ 관리 기능</label>

        <button class="admin-btn btn-generate" onclick="generateParticipants()">
            더미 참가자 10,000명 생성 (1~2분 소요)
        </button>

        <button class="admin-btn btn-reset" onclick="resetData()">
            DB 초기화
        </button>

        <div class="mb-2">
            <label style="font-size:12px;">1등 지정 번호</label>
            <input type="text" id="predefinedPhone" class="form-control form-control-sm"
                   value="01012345678" style="background:#444;color:white;border:1px solid #555;">
        </div>
        <button class="admin-btn btn-draw" onclick="executeDraw()">
            추첨 실행
        </button>

        <button class="admin-btn btn-remind" onclick="sendRemind()">
            미확인자 리마인드 발송
        </button>

        <button class="admin-btn btn-dashboard" onclick="loadDashboard()">
            DB 현황 조회
        </button>

        <div id="adminResult" class="admin-result" style="display:none;"></div>
    </div>
</div>

<script>
    window.onload = function() { updateStatus(); };

    function toggleAdmin() {
        var panel = document.getElementById('adminPanel');
        panel.classList.toggle('active', document.getElementById('adminSwitch').checked);
    }

    function setDate(dateStr) {
        document.getElementById('simulatedDate').value = dateStr;
        document.querySelectorAll('.date-btn').forEach(function(btn) { btn.classList.remove('active'); });
        event.target.classList.add('active');
        updateStatus();
    }

    function updateStatus() {
        var dateVal = document.getElementById('simulatedDate').value;
        var url = '/api/event/status';
        if (dateVal) url += '?simulatedDate=' + dateVal;
        fetch(url)
            .then(function(res) { return res.json(); })
            .then(function(data) { if (data.success) renderStatus(data.data); });
    }

    function renderStatus(data) {
        var statusArea = document.getElementById('statusArea');
        var userButtons = document.getElementById('userButtons');
        var badgeClass = 'status-before';
        if (data.period === 'EVENT_PERIOD') badgeClass = 'status-event';
        else if (data.period === 'ANNOUNCE_PERIOD') badgeClass = 'status-announce';
        else if (data.period === 'BETWEEN') badgeClass = 'status-between';
        else if (data.period === 'FINISHED') badgeClass = 'status-finished';

        statusArea.innerHTML = '<span class="status-badge ' + badgeClass + '">📌 ' + data.currentDate + ' — ' + data.periodLabel + '</span>';

        if (data.period === 'EVENT_PERIOD') {
            userButtons.innerHTML = '<a href="/participate" class="btn btn-event btn-participate">🎟️ 이벤트 참가하기</a>';
        } else if (data.period === 'ANNOUNCE_PERIOD') {
            userButtons.innerHTML = '<a href="/result" class="btn btn-event btn-result">🔍 결과 확인하기</a>';
            if (data.isRemindDay) {
                userButtons.innerHTML += '<br><small class="text-muted mt-2 d-block">📩 발표 10일 경과 — 미확인자 리마인드 발송 대상</small>';
            }
        } else if (data.period === 'BEFORE_EVENT') {
            userButtons.innerHTML = '<p class="text-muted">이벤트가 아직 시작되지 않았습니다.</p>';
        } else if (data.period === 'BETWEEN') {
            userButtons.innerHTML = '<p class="text-muted">이벤트가 종료되었습니다. 발표를 기다려주세요!</p>';
        } else {
            userButtons.innerHTML = '<p class="text-muted">이벤트가 종료되었습니다. 감사합니다!</p>';
        }
    }

    function showAdminResult(msg) {
        var el = document.getElementById('adminResult');
        el.style.display = 'block';
        el.textContent = msg;
    }

    function generateParticipants() {
        showAdminResult('⏳ 사전 지정 1등 번호 참가 중...');

        fetch('/api/event/participate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                eventId: 1,
                phoneNumber: '01012345678',
                verificationCode: '123456'
            })
        })
            .then(function() { startDummyGeneration(); })
            .catch(function() { startDummyGeneration(); });

        function startDummyGeneration() {
            var totalTarget = 9999;
            var batchSize = 500;
            var created = 0;

            showAdminResult('⏳ 참가자 생성 중... 1 / 10000');

            function nextBatch() {
                var remaining = totalTarget - created;
                var currentBatch = Math.min(batchSize, remaining);

                if (currentBatch <= 0) {
                    showAdminResult('✅ 참가자 생성 완료! (10000명)');
                    return;
                }

                fetch('/api/admin/test/generate-participants?eventId=1&count=' + currentBatch + '&offset=' + created, { method: 'POST' })
                    .then(function(res) { return res.json(); })
                    .then(function(data) {
                        created += currentBatch;
                        showAdminResult('⏳ 참가자 생성 중... ' + (created + 1) + ' / 10000');
                        nextBatch();
                    })
                    .catch(function() {
                        showAdminResult('❌ 오류 발생 (' + created + '명까지 생성됨)');
                    });
            }

            nextBatch();
        }
    }

    function executeDraw() {
        var phone = document.getElementById('predefinedPhone').value;
        showAdminResult('⏳ 추첨 실행 중...');
        fetch('/api/admin/draw?eventId=1&predefinedWinnerPhone=' + phone, { method: 'POST' })
            .then(function(res) { return res.json(); })
            .then(function(data) { showAdminResult(data.success ? '✅ ' + data.message : '❌ ' + data.message); })
            .catch(function() { showAdminResult('❌ 오류 발생'); });
    }

    function sendRemind() {
        showAdminResult('⏳ 리마인드 발송 중...');
        fetch('/api/admin/remind?eventId=1', { method: 'POST' })
            .then(function(res) { return res.json(); })
            .then(function(data) { showAdminResult(data.success ? '✅ ' + data.message : '❌ ' + data.message); })
            .catch(function() { showAdminResult('❌ 오류 발생'); });
    }

    function loadDashboard() {
        showAdminResult('⏳ 조회 중...');
        fetch('/api/admin/dashboard?eventId=1')
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.success) {
                    var d = data.data;
                    var msg = '📊 DB 현황\n━━━━━━━━━━━━━━━━━━\n';
                    msg += '👥 총 참가자: ' + d.totalParticipants + '명\n';
                    msg += '📩 SMS 발송: ' + d.smsCount + '건\n';
                    msg += '━━━━━━━━━━━━━━━━━━\n🏆 당첨자 현황:\n';
                    if (d.winnerCounts && d.winnerCounts.length > 0) {
                        d.winnerCounts.forEach(function(item) {
                            msg += '  ' + item.rankType + '등: ' + item.cnt + '명\n';
                        });
                    } else {
                        msg += '  아직 추첨 전입니다.\n';
                    }
                    showAdminResult(msg);
                }
            })
            .catch(function() { showAdminResult('❌ 오류 발생'); });
    }

    function resetData() {
        if (!confirm('정말 초기화하시겠습니까? 모든 참가자/당첨 데이터가 삭제됩니다.')) return;
        showAdminResult('⏳ 초기화 중...');
        fetch('/api/admin/reset?eventId=1', { method: 'POST' })
            .then(function(res) { return res.json(); })
            .then(function(data) { showAdminResult(data.success ? '✅ ' + data.message : '❌ ' + data.message); })
            .catch(function() { showAdminResult('❌ 오류 발생'); });
    }
</script>
</body>
</html>