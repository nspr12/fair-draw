<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드</title>
    <style>
        body { font-family: 'Arial', sans-serif; background-color: #f4f4f5; display: flex; justify-content: center; padding: 40px 0; margin: 0; }
        .container { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 100%; max-width: 600px; }
        h2 { color: #111; margin-top: 0; border-bottom: 2px solid #000; padding-bottom: 10px; }
        .section { margin-bottom: 30px; padding: 20px; background: #f8f9fa; border-radius: 8px; border: 1px solid #ddd; }
        h3 { margin-top: 0; font-size: 1.1em; color: #333; }

        .stat-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; margin-bottom: 15px; }
        .stat-box { background: #fff; padding: 15px; border-radius: 5px; border: 1px solid #eee; text-align: center; font-weight: bold; }
        .stat-num { font-size: 1.5em; color: #e74c3c; display: block; margin-top: 5px; }

        .winner-list { background: #fff; padding: 15px; border-radius: 5px; border: 1px solid #eee; margin-top: 10px; }
        .winner-row { display: flex; justify-content: space-between; padding: 6px 0; border-bottom: 1px solid #f0f0f0; font-size: 0.95em; }
        .winner-row:last-child { border-bottom: none; }

        input[type="date"] { padding: 10px; border: 1px solid #ccc; border-radius: 5px; }
        button { padding: 10px 15px; background-color: #111; color: #fff; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; transition: 0.2s; }
        button:hover { background-color: #444; }
        .btn-draw { background-color: #e74c3c; width: 100%; margin-top: 10px; padding: 15px; font-size: 1.1em; }
        .btn-draw:hover { background-color: #c0392b; }
        .btn-reset { background-color: #888; width: 100%; margin-top: 10px; padding: 12px; }
        .btn-reset:hover { background-color: #666; }
        .btn-home { background: transparent; color: #000; text-decoration: underline; padding: 0; margin-bottom: 20px; display: block; }

        .progress-bar { display: none; margin-top: 10px; }
        .progress-bar .bar { height: 20px; background: #e0e0e0; border-radius: 10px; overflow: hidden; }
        .progress-bar .fill { height: 100%; background: #2ecc71; width: 0%; transition: width 0.3s; }
        .progress-text { font-size: 0.85em; color: #666; margin-top: 5px; }
    </style>
</head>
<body>

<div class="container">
    <button class="btn-home" onclick="location.href='/'">← 메인으로 돌아가기</button>
    <h2>FairDraw Admin</h2>

    <!-- 타임머신 -->
    <div class="section">
        <h3>테스트용 날짜 설정</h3>
        <p style="font-size:0.8em; color:#666;">이벤트 상태를 특정 날짜 기준으로 확인할 수 있습니다.</p>

        <input type="date" id="simulatedDateInput" style="margin-bottom: 10px;">
        <button onclick="saveSimulatedDate()">적용</button>
        <button onclick="clearSimulatedDate()" style="background:#888;">초기화</button>

        <div style="margin-top: 10px; padding-top: 10px; border-top: 1px dashed #ccc;">
            <button onclick="setQuickDate('2025-02-15')" style="background-color: #2ecc71; font-size: 0.85em; padding: 8px;">이벤트 기간 (2/15)</button>
            <button onclick="setQuickDate('2025-04-02')" style="background-color: #9b59b6; font-size: 0.85em; padding: 8px;">발표 기간 (4/2)</button>
        </div>
    </div>

    <!-- 대시보드 -->
    <div class="section">
        <h3>현황 (Event ID: 1)</h3>
        <button onclick="loadDashboard()" style="margin-bottom: 15px; width: 100%;">현황 조회</button>
        <div class="stat-grid">
            <div class="stat-box">총 응모자 <span class="stat-num" id="statTotal">-</span></div>
            <div class="stat-box">당첨자 <span class="stat-num" id="statWinners">-</span></div>
            <div class="stat-box">SMS 발송 <span class="stat-num" id="statSms">-</span></div>
        </div>
        <div class="winner-list" id="winnerList" style="display:none;">
            <strong>등수별 당첨 현황</strong>
            <div id="winnerRows"></div>
        </div>
    </div>

    <!-- 관리 기능 -->
    <div class="section">
        <h3>관리 기능</h3>
        <button style="width:100%; margin-bottom:10px;" onclick="generateDummy()">더미 참가자 10,000명 생성</button>
        <div class="progress-bar" id="progressBar">
            <div class="bar"><div class="fill" id="progressFill"></div></div>
            <div class="progress-text" id="progressText">0 / 10,000</div>
        </div>
        <button style="width:100%; margin-bottom:10px; background:#2980b9;" onclick="sendRemind()">미확인자 리마인드 발송</button>
        <button style="width:100%; margin-bottom:10px; background:#e74c3c;" onclick="executeDraw()">추첨 실행</button>
        <button style="width:100%; background:#888;" onclick="resetData()">DB 초기화</button>
    </div>

<script>
    window.onload = function() {
        var savedDate = localStorage.getItem('fairDrawDate');
        if(savedDate) document.getElementById('simulatedDateInput').value = savedDate;
        loadDashboard();
    };

    function setQuickDate(dateVal) {
        document.getElementById('simulatedDateInput').value = dateVal;
        saveSimulatedDate();
    }

    function saveSimulatedDate() {
        var dateVal = document.getElementById('simulatedDateInput').value;
        if(dateVal) {
            localStorage.setItem('fairDrawDate', dateVal);
            alert('가상 날짜가 적용되었습니다.');
        }
    }

    function clearSimulatedDate() {
        localStorage.removeItem('fairDrawDate');
        document.getElementById('simulatedDateInput').value = '';
        alert('실제 날짜로 초기화되었습니다.');
    }

    function loadDashboard() {
        fetch('/api/admin/dashboard?eventId=1')
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if(data.success) {
                    var d = data.data;
                    document.getElementById('statTotal').innerText = d.totalParticipants + '명';
                    document.getElementById('statSms').innerText = d.smsCount + '건';

                    if(d.winnerCounts && d.winnerCounts.length > 0) {
                        var total = 0;
                        var html = '';
                        d.winnerCounts.forEach(function(item) {
                            html += '<div class="winner-row"><span>' + item.rankType + '등 (' + item.prizeName + ')</span><span>' + item.cnt + '명</span></div>';
                            total += item.cnt;
                        });
                        document.getElementById('statWinners').innerText = total + '명';
                        document.getElementById('winnerRows').innerHTML = html;
                        document.getElementById('winnerList').style.display = 'block';
                    } else {
                        document.getElementById('statWinners').innerText = '-';
                        document.getElementById('winnerList').style.display = 'none';
                    }
                }
            });
    }

    function generateDummy() {
        var totalTarget = 10000;
        var batchSize = 500;
        var created = 0;

        document.getElementById('progressBar').style.display = 'block';
        document.getElementById('progressFill').style.width = '0%';
        document.getElementById('progressText').innerText = '0 / ' + totalTarget;

        function nextBatch() {
            var remaining = totalTarget - created;
            var currentBatch = Math.min(batchSize, remaining);

            if(currentBatch <= 0) {
                document.getElementById('progressFill').style.width = '100%';
                document.getElementById('progressText').innerText = totalTarget + ' / ' + totalTarget + ' (완료)';
                loadDashboard();
                return;
            }

            fetch('/api/admin/test/generate-participants?eventId=1&count=' + currentBatch + '&offset=' + created, { method: 'POST' })
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    created += currentBatch;
                    var percent = Math.round((created / totalTarget) * 100);
                    document.getElementById('progressFill').style.width = percent + '%';
                    document.getElementById('progressText').innerText = created + ' / ' + totalTarget;
                    nextBatch();
                })
                .catch(function() {
                    document.getElementById('progressText').innerText = '오류 발생 (' + created + '명까지 생성됨)';
                });
        }

        nextBatch();
    }

    function executeDraw() {
        if(!confirm('추첨을 실행하시겠습니까? 실행 후 취소할 수 없습니다.')) return;
        fetch('/api/admin/draw?eventId=1', { method: 'POST' })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                alert(data.success ? '추첨이 완료되었습니다.' : '오류: ' + data.message);
                loadDashboard();
            });
    }

    function sendRemind() {
        fetch('/api/admin/remind?eventId=1', { method: 'POST' })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                alert(data.success ? data.message : '오류: ' + data.message);
            });
    }

    function resetData() {
        if(!confirm('모든 참가자/당첨 데이터가 삭제됩니다. 초기화하시겠습니까?')) return;
        fetch('/api/admin/reset?eventId=1', { method: 'POST' })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                alert(data.success ? '초기화 완료' : '오류: ' + data.message);
                loadDashboard();
            });
    }

</script>

</body>

</html>