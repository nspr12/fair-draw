<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FairDraw - 공정한 추첨 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/lottie-web/5.12.2/lottie.min.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap');
        body { font-family: 'Noto Sans KR', sans-serif; }
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

<nav class="relative z-10 flex items-start justify-between px-8 pt-3 pb-5 pr-5 bg-gray-950/80 backdrop-blur-sm border-b border-gray-800">
    <a href="/" class="flex items-center gap-2 text-2xl font-bold tracking-tight mt-2">
        <img src="/static/logo.png" alt="FairDraw" class="h-11 w-11">
        <span class="text-yellow-400">Fair</span><span class="text-white">Draw</span>
    </a>
    <div class="flex items-center gap-2">
        <a href="/signup" class="text-xs text-gray-400 hover:text-white transition">회원가입</a>
        <span class="text-gray-700 text-xs">|</span>
        <a href="/login" class="text-xs text-gray-400 hover:text-white transition">로그인</a>
        <span class="text-gray-700 text-xs">|</span>
        <a href="/admin" class="text-xs text-gray-400 hover:text-white transition">관리자</a>
    </div>
</nav>

<main class="relative z-10 flex-1 flex items-center justify-center px-4 py-10">
    <div class="bg-gray-900/80 backdrop-blur-sm border border-gray-800 rounded-2xl p-10 w-full max-w-md h-[520px] text-center shadow-2xl flex flex-col justify-center">

        <h1 class="text-3xl font-bold mb-1">
            <span class="text-yellow-400">Fair</span><span class="text-white">Draw</span>
        </h1>
        <p class="text-gray-400 text-sm mb-6">공정하고 투명한 프로모션 추첨</p>

        <div id="eventStatusBadge"
             class="inline-block px-4 py-1.5 rounded-full text-xs font-semibold bg-gray-800 text-gray-300 mb-8">
            상태 확인 중...
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

<script>
    lottie.loadAnimation({
        container: document.getElementById('lottie-bg'),
        renderer: 'svg',
        loop: true,
        autoplay: true,
        path: '/static/balloons.json'
    });
</script>

<script>
    var simulatedDate = localStorage.getItem('fairDrawDate');
    var url = '/api/event/status?eventId=1';
    if (simulatedDate) {
        url += '&simulatedDate=' + simulatedDate;
    }

    fetch(url)
        .then(function(res) { return res.json(); })
        .then(function(data) {
            var badge = document.getElementById('eventStatusBadge');
            if (data.success) {
                var label = data.data.periodLabel;
                if (simulatedDate) {
                    label += ' (' + simulatedDate + ' 기준)';
                }
                badge.innerText = label;

                if (data.data.period === 'ACTIVE_PERIOD') {
                    badge.className = 'inline-block px-4 py-1.5 rounded-full text-xs font-semibold bg-green-500/20 text-green-400 mb-8';
                } else if (data.data.period === 'ANNOUNCE_PERIOD') {
                    badge.className = 'inline-block px-4 py-1.5 rounded-full text-xs font-semibold bg-red-500/20 text-red-400 mb-8';
                }
            }
        })
        .catch(function(e) { console.error(e); });
</script>

</body>
</html>