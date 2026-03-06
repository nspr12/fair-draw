<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="layout/header.jsp" %>
<title>FairDraw - 응모하기</title>
</head>
<body class="bg-gray-950 text-white min-h-screen flex flex-col">

<%--nav바 iclude--%>
<%@ include file="layout/nav.jsp" %>

<main class="flex-1 flex items-center justify-center px-4 py-10">
    <div class="bg-gray-900/80 backdrop-blur-sm border border-gray-800 rounded-2xl p-10 w-full max-w-md min-h-[520px] shadow-2xl flex flex-col justify-center">

        <h2 class="text-2xl font-bold text-center mb-2">응모하기</h2>
        <p class="text-gray-400 text-sm text-center mb-6">휴대폰 인증 후 응모가 완료됩니다.</p>

        <div id="eventStatusBadge" class="text-center text-xs text-red-400 font-semibold mb-4"></div>

        <div class="mb-4">
            <label class="block text-sm font-semibold text-gray-300 mb-2">휴대폰 번호</label>
            <div class="flex gap-2">
                <input type="text" id="phoneNumber" placeholder="01012345678" maxlength="11"
                       class="flex-1 px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-yellow-400 transition">
                <button onclick="sendVerification()"
                        class="px-5 py-3 bg-gray-700 hover:bg-gray-600 text-white font-semibold rounded-lg transition whitespace-nowrap">
                    인증 발송
                </button>
            </div>
        </div>

        <div class="mb-6">
            <label class="block text-sm font-semibold text-gray-300 mb-2">인증번호</label>
            <input type="text" id="verificationCode" placeholder="인증번호 6자리" maxlength="6"
                   class="w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-yellow-400 transition">
        </div>

        <input type="hidden" id="eventId" value="1">

        <button onclick="participateEvent()"
                class="w-full py-3.5 bg-yellow-400 hover:bg-yellow-300 text-gray-900 font-bold rounded-lg transition text-lg">
            응모 완료하기
        </button>

        <a href="/" class="block text-center text-sm text-gray-500 hover:text-gray-300 mt-4 transition">
            ← 메인으로 돌아가기
        </a>
    </div>
</main>

<%@ include file="layout/footer.jsp" %>

<script>
    //변경: simulatedDate 로직 제거

    function sendVerification() {
        var phone = document.getElementById('phoneNumber').value;
        if (!phone) {
            alert('휴대폰 번호를 입력해주세요.');
            return;
        }

        fetch('/api/event/verify/send?phoneNumber=' + phone, { method: 'POST' })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.success) {
                    alert('인증번호가 발송되었습니다. (테스트용: 123456)');
                } else {
                    alert('오류: ' + data.message);
                }
            })
            .catch(function(e) { console.error(e); });
    }

    function participateEvent() {
        var eventId = document.getElementById('eventId').value;
        var phone = document.getElementById('phoneNumber').value;
        var code = document.getElementById('verificationCode').value;

        if (!phone || !code) {
            alert('휴대폰 번호와 인증번호를 모두 입력해주세요.');
            return;
        }

        fetch('/api/event/participate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                eventId: parseInt(eventId),
                phoneNumber: phone,
                verificationCode: code
            })
        })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.success) {
                    alert(data.message);
                    window.location.href = '/';
                } else {
                    alert('응모 실패: ' + data.message);
                }
            })
            .catch(function(e) { console.error(e); });
    }
</script>