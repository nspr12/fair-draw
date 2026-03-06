<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="layout/header.jsp" %>
<title>FairDraw - 결과 확인</title>
<style>
    @keyframes pop {
        0% { transform: scale(0.8); opacity: 0; }
        100% { transform: scale(1); opacity: 1; }
    }
    .animate-pop { animation: pop 0.5s ease-out; }
</style>
</head>
<body class="bg-gray-950 text-white min-h-screen flex flex-col">

<%--nav바 iclude--%>
<%@ include file="layout/nav.jsp" %>

<main class="flex-1 flex items-center justify-center px-4 py-10">
    <div class="bg-gray-900/80 backdrop-blur-sm border border-gray-800 rounded-2xl p-10 w-full max-w-md min-h-[520px] shadow-2xl flex flex-col justify-center">

        <h2 class="text-2xl font-bold text-center mb-2">당첨 결과 확인</h2>
        <p class="text-gray-400 text-sm text-center mb-6">응모하신 휴대폰 번호를 입력해주세요.</p>

        <div id="eventStatusBadge" class="text-center text-xs text-red-400 font-semibold mb-4"></div>

        <div class="mb-6">
            <label class="block text-sm font-semibold text-gray-300 mb-2">휴대폰 번호</label>
            <input type="text" id="phoneNumber" placeholder="01012345678" maxlength="11"
                   class="w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-yellow-400 transition">
        </div>

        <input type="hidden" id="eventId" value="1">

        <button onclick="checkResult()"
                class="w-full py-3.5 bg-yellow-400 hover:bg-yellow-300 text-gray-900 font-bold rounded-lg transition text-lg mb-4">
            결과 확인
        </button>

        <div id="resultBox" class="hidden rounded-lg p-5 text-center animate-pop"></div>

        <a href="/" class="block text-center text-sm text-gray-500 hover:text-gray-300 mt-4 transition">
            ← 메인으로 돌아가기
        </a>
    </div>
</main>

<%@ include file="layout/footer.jsp" %>

<script>
    // 변경: simulatedDate 로직 제거 (아래 3줄 삭제)

    function checkResult() {
        var eventId = document.getElementById('eventId').value;
        var phone = document.getElementById('phoneNumber').value;
        var resultBox = document.getElementById('resultBox');

        if (!phone) {
            alert('휴대폰 번호를 입력해주세요.');
            return;
        }

        resultBox.className = 'hidden';

        var url = '/api/event/result?eventId=' + eventId + '&phoneNumber=' + phone;

        fetch(url)
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.success) {
                    var r = data.data;
                    resultBox.className = 'rounded-lg p-5 text-center animate-pop mt-4';

                    if (r.isWinner) {
                        resultBox.className += ' bg-green-500/20 border border-green-500/30';
                        resultBox.innerHTML = '<p class="text-green-400 font-bold text-lg">' + r.message + '</p><p class="text-white mt-2 font-semibold">' + r.prizeName + '</p>';
                    } else {
                        resultBox.className += ' bg-red-500/20 border border-red-500/30';
                        resultBox.innerHTML = '<p class="text-red-400 font-bold">' + r.message + '</p>';
                    }
                } else {
                    alert('조회 실패: ' + data.message);
                }
            })
            .catch(function(e) { console.error(e); });
    }
</script>