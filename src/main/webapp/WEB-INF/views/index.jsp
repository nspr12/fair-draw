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

<%--nav바 iclude--%>
<%@ include file="layout/nav.jsp" %>

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

<%@ include file="layout/footer.jsp" %>

<script>
    lottie.loadAnimation({
        container: document.getElementById('lottie-bg'),
        renderer: 'svg',
        loop: true,
        autoplay: true,
        path: '/static/balloons.json'
    });

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