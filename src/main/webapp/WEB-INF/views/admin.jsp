<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FairDraw Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap');
        body { font-family: 'Noto Sans KR', sans-serif; }
    </style>
</head>
<body class="bg-gray-950 text-white min-h-screen flex flex-col">

<!-- 네비게이션 바 -->
<nav class="flex items-center justify-between px-8 py-6 bg-gray-950/80 backdrop-blur-sm border-b border-gray-800">
    <a href="/" class="flex items-center gap-2 text-2xl font-bold tracking-tight">
        <img src="/static/logo.png" alt="FairDraw" class="h-12 w-11">
        <span class="text-yellow-400">Fair</span><span class="text-white">Draw</span>
    </a>
    <div class="flex items-center gap-4">
        <span class="text-xs text-gray-500 bg-gray-800 px-3 py-1 rounded-full">Admin</span>
        <a href="/" class="text-sm text-gray-400 hover:text-white transition">메인으로</a>
    </div>
</nav>

<!-- 대시보드 콘텐츠 -->
<main class="flex-1 px-8 py-8 max-w-6xl mx-auto w-full">

    <!-- 페이지 제목 -->
    <h1 class="text-xl font-bold mb-6">관리자 대시보드</h1>

    <!-- 상단 통계 카드 4열 -->
    <div class="grid grid-cols-4 gap-4 mb-6">
        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5">
            <p class="text-xs text-gray-400 mb-1">총 응모자</p>
            <p class="text-2xl font-bold text-white" id="statTotal">-</p>
        </div>
        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5">
            <p class="text-xs text-gray-400 mb-1">당첨자</p>
            <p class="text-2xl font-bold text-yellow-400" id="statWinners">-</p>
        </div>
        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5">
            <p class="text-xs text-gray-400 mb-1">SMS 발송</p>
            <p class="text-2xl font-bold text-blue-400" id="statSms">-</p>
        </div>
        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5">
            <p class="text-xs text-gray-400 mb-1">이벤트 상태</p>
            <p class="text-2xl font-bold text-green-400" id="statStatus">-</p>
        </div>
    </div>

    <!-- 중단 2열 -->
    <div class="grid grid-cols-2 gap-4 mb-6">

        <!-- 등수별 당첨 현황 -->
        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-sm font-semibold text-gray-300">등수별 당첨 현황</h3>
                <button onclick="loadDashboard()" class="text-xs text-gray-500 hover:text-white transition">새로고침</button>
            </div>
            <div id="winnerList">
                <p class="text-sm text-gray-500">추첨 전입니다.</p>
            </div>
        </div>

        <!-- 날짜 설정 -->
        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5">
            <h3 class="text-sm font-semibold text-gray-300 mb-2">테스트용 날짜 설정</h3>
            <p class="text-xs text-gray-500 mb-4">이벤트 상태를 특정 날짜 기준으로 확인할 수 있습니다.</p>

            <div class="flex gap-2 mb-3">
                <input type="date" id="simulatedDateInput"
                       class="flex-1 px-3 py-2 bg-gray-800 border border-gray-700 rounded-lg text-white text-sm focus:outline-none focus:border-yellow-400 transition">
                <button onclick="saveSimulatedDate()"
                        class="px-4 py-2 bg-yellow-400 hover:bg-yellow-300 text-gray-900 font-semibold rounded-lg text-sm transition">
                    적용
                </button>
                <button onclick="clearSimulatedDate()"
                        class="px-4 py-2 bg-gray-700 hover:bg-gray-600 text-white rounded-lg text-sm transition">
                    초기화
                </button>
            </div>

            <div class="flex gap-2">
                <button onclick="setQuickDate('2025-02-15')"
                        class="flex-1 py-2 bg-green-500/20 hover:bg-green-500/30 text-green-400 rounded-lg text-xs font-semibold transition">
                    이벤트 기간 (2/15)
                </button>
                <button onclick="setQuickDate('2025-04-02')"
                        class="flex-1 py-2 bg-purple-500/20 hover:bg-purple-500/30 text-purple-400 rounded-lg text-xs font-semibold transition">
                    발표 기간 (4/2)
                </button>
            </div>
        </div>
    </div>

    <!-- 하단 2열: 관리 기능 + 더미 생성 -->
    <div class="grid grid-cols-2 gap-4">

        <!-- 관리 기능 -->
        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5">
            <h3 class="text-sm font-semibold text-gray-300 mb-4">관리 기능</h3>
            <div class="space-y-3">
                <button onclick="executeDraw()"
                        class="w-full py-3 bg-red-500 hover:bg-red-400 text-white font-bold rounded-lg transition">
                    추첨 실행
                </button>
                <button onclick="sendRemind()"
                        class="w-full py-3 bg-blue-500 hover:bg-blue-400 text-white font-semibold rounded-lg transition">
                    미확인자 리마인드 발송
                </button>
                <button onclick="resetData()"
                        class="w-full py-3 bg-gray-700 hover:bg-gray-600 text-gray-300 font-semibold rounded-lg transition">
                    DB 초기화
                </button>
            </div>
        </div>

        <!-- 더미 데이터 생성 -->
        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5">
            <h3 class="text-sm font-semibold text-gray-300 mb-4">더미 데이터 생성</h3>
            <button onclick="generateDummy()"
                    class="w-full py-3 bg-gray-800 hover:bg-gray-700 text-white font-semibold rounded-lg border border-gray-700 transition mb-4">
                더미 참가자 10,000명 생성
            </button>

            <!-- 진행률 바 -->
            <div id="progressBar" class="hidden">
                <div class="w-full h-3 bg-gray-800 rounded-full overflow-hidden">
                    <div id="progressFill" class="h-full bg-green-500 rounded-full transition-all duration-300" style="width: 0%"></div>
                </div>
                <p id="progressText" class="text-xs text-gray-500 mt-2">0 / 10,000</p>
            </div>
        </div>
    </div>

</main>

<script>
    window.onload = function() {
        var savedDate = localStorage.getItem('fairDrawDate');
        if (savedDate) document.getElementById('simulatedDateInput').value = savedDate;
        loadDashboard();
    };

    function setQuickDate(dateVal) {
        document.getElementById('simulatedDateInput').value = dateVal;
        saveSimulatedDate();
    }

    function saveSimulatedDate() {
        var dateVal = document.getElementById('simulatedDateInput').value;
        if (dateVal) {
            localStorage.setItem('fairDrawDate', dateVal);
            alert('가상 날짜가 적용되었습니다.');
            loadDashboard();
        }
    }

    function clearSimulatedDate() {
        localStorage.removeItem('fairDrawDate');
        document.getElementById('simulatedDateInput').value = '';
        alert('실제 날짜로 초기화되었습니다.');
        loadDashboard();
    }

    function loadDashboard() {
        fetch('/api/admin/dashboard?eventId=1')
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.success) {
                    var d = data.data;
                    document.getElementById('statTotal').innerText = d.totalParticipants.toLocaleString();
                    document.getElementById('statSms').innerText = d.smsCount.toLocaleString();

                    if (d.winnerCounts && d.winnerCounts.length > 0) {
                        var total = 0;
                        var html = '';
                        d.winnerCounts.forEach(function(item) {
                            html += '<div class="flex justify-between py-2 border-b border-gray-800 last:border-0">'
                                + '<span class="text-sm text-gray-300">' + item.rankType + '등 (' + item.prizeName + ')</span>'
                                + '<span class="text-sm font-semibold text-white">' + item.cnt + '명</span>'
                                + '</div>';
                            total += item.cnt;
                        });
                        document.getElementById('statWinners').innerText = total.toLocaleString();
                        document.getElementById('winnerList').innerHTML = html;
                        document.getElementById('statStatus').innerText = 'DRAWN';
                        document.getElementById('statStatus').className = 'text-2xl font-bold text-yellow-400';
                    } else {
                        document.getElementById('statWinners').innerText = '-';
                        document.getElementById('winnerList').innerHTML = '<p class="text-sm text-gray-500">추첨 전입니다.</p>';
                        document.getElementById('statStatus').innerText = 'ACTIVE';
                        document.getElementById('statStatus').className = 'text-2xl font-bold text-green-400';
                    }
                }
            });
    }

    function generateDummy() {
        var totalTarget = 10000;
        var batchSize = 500;
        var created = 0;

        document.getElementById('progressBar').className = 'block';
        document.getElementById('progressFill').style.width = '0%';
        document.getElementById('progressText').innerText = '0 / ' + totalTarget.toLocaleString();

        function nextBatch() {
            var remaining = totalTarget - created;
            var currentBatch = Math.min(batchSize, remaining);

            if (currentBatch <= 0) {
                document.getElementById('progressFill').style.width = '100%';
                document.getElementById('progressText').innerText = totalTarget.toLocaleString() + ' / ' + totalTarget.toLocaleString() + ' (완료)';
                loadDashboard();
                return;
            }

            fetch('/api/admin/test/generate-participants?eventId=1&count=' + currentBatch + '&offset=' + created, { method: 'POST' })
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    created += currentBatch;
                    var percent = Math.round((created / totalTarget) * 100);
                    document.getElementById('progressFill').style.width = percent + '%';
                    document.getElementById('progressText').innerText = created.toLocaleString() + ' / ' + totalTarget.toLocaleString();
                    nextBatch();
                })
                .catch(function() {
                    document.getElementById('progressText').innerText = '오류 발생 (' + created.toLocaleString() + '명까지 생성됨)';
                });
        }

        nextBatch();
    }

    function executeDraw() {
        if (!confirm('추첨을 실행하시겠습니까? 실행 후 취소할 수 없습니다.')) return;
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
        if (!confirm('모든 참가자/당첨 데이터가 삭제됩니다. 초기화하시겠습니까?')) return;
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