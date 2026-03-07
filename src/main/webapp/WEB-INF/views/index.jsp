<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="layout/header.jsp" %>
<title>FairDraw - 공정한 추첨 시스템</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lottie-web/5.12.2/lottie.min.js"></script>
<style>
    #lottie-bg {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        min-width: 100vw;
        min-height: 100vh;
        z-index: 0;
        pointer-events: none;
        opacity: 0.4;
        mix-blend-mode: screen;
    }
</style>
</head>
<body class="bg-gray-950 text-white min-h-screen flex flex-col">

<div id="lottie-bg"></div>

<%@ include file="layout/nav.jsp" %>

<main class="relative z-10 flex-1 flex items-center justify-center px-4 py-10">
    <div class="bg-gray-900/80 backdrop-blur-sm border border-gray-800 rounded-2xl p-10 w-full max-w-md text-center shadow-2xl flex flex-col justify-center">

        <h1 class="text-3xl font-bold mb-1">
            <span class="text-yellow-400">Fair</span><span class="text-white">Draw</span>
        </h1>
        <p class="text-gray-400 text-sm mb-4">공정하고 투명한 프로모션 추첨</p>

        <!-- 테스트 기준 날짜 표시 (dev 모드에서만 의미있음) -->
        <div id="devDateBadge" class="hidden text-xs text-yellow-400 bg-yellow-400/10 px-3 py-1 rounded-full mb-3">
        </div>

        <div id="eventStatusBadge"
             class="inline-block px-4 py-1.5 rounded-full text-xs font-semibold bg-gray-800 text-gray-300 mb-6">
            상태 확인 중...
        </div>

        <!-- 이벤트 정보 영역 -->
        <div id="eventInfo" class="hidden bg-gray-800/50 rounded-xl p-4 mb-6 text-left text-sm">
            <p id="eventTitle" class="font-bold text-white mb-2"></p>
            <div class="space-y-1.5 text-gray-400 text-xs">
                <div class="flex justify-between">
                    <span>응모기간</span>
                    <span id="eventDates" class="text-gray-300"></span>
                </div>
                <div class="flex justify-between">
                    <span>추첨인원</span>
                    <span id="eventPrizeCount" class="text-gray-300"></span>
                </div>
                <div class="flex justify-between">
                    <span>발표일</span>
                    <span id="eventAnnounceDate" class="text-gray-300"></span>
                </div>
            </div>
        </div>

        <div class="space-y-3">
            <a href="/participate"
               class="block w-full py-3.5 bg-yellow-400 hover:bg-yellow-300 text-gray-900 font-bold rounded-lg transition text-center">
                응모하기
            </a>
            <a href="/result"
               class="block w-full py-3.5 bg-gray-800 hover:bg-gray-700 text-white font-semibold rounded-lg border border-gray-700 transition text-center">
                당첨 결과 확인
            </a>
        </div>
    </div>
</main>

<%@ include file="layout/footer.jsp" %>

<script>
    lottie.loadAnimation({
        container: document.getElementById('lottie-bg'),
        renderer: 'svg',
        loop: true,
        autoplay: true,
        path: '/static/balloons.json'
    });

    fetch('/api/event/status?eventId=1')
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (!data.success) return;

            var d = data.data;

            // 상태 뱃지
            var badge = document.getElementById('eventStatusBadge');
            badge.innerText = d.periodLabel;

            if (d.period === 'EVENT_PERIOD') {
                badge.className = 'inline-block px-4 py-1.5 rounded-full text-xs font-semibold bg-green-500/20 text-green-400 mb-6';
            } else if (d.period === 'ANNOUNCE_PERIOD') {
                badge.className = 'inline-block px-4 py-1.5 rounded-full text-xs font-semibold bg-purple-500/20 text-purple-400 mb-6';
            } else if (d.period === 'FINISHED') {
                badge.className = 'inline-block px-4 py-1.5 rounded-full text-xs font-semibold bg-red-500/20 text-red-400 mb-6';
            }

            // 테스트 기준 날짜 표시
            var devBadge = document.getElementById('devDateBadge');
            devBadge.innerText = '테스트 기준일: ' + d.currentDate;
            devBadge.className = 'text-xs text-yellow-400 bg-yellow-400/10 px-3 py-1 rounded-full mb-3 inline-block';

            // 이벤트 정보 표시
            var infoBox = document.getElementById('eventInfo');
            infoBox.className = 'bg-gray-800/50 rounded-xl p-4 mb-6 text-left text-sm';

            document.getElementById('eventTitle').innerText = d.title || '이벤트';
            document.getElementById('eventDates').innerText = d.startDate + ' ~ ' + d.endDate;
            document.getElementById('eventPrizeCount').innerText = (d.totalPrizeCount || 0) + '명';
            document.getElementById('eventAnnounceDate').innerText = d.announceStartDate || '-';
        })
        .catch(function(e) { console.error(e); });
</script>