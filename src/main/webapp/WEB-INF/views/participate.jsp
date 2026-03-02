<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="ko">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1.0">--%>
<%--    <title>🎟️ 이벤트 참가</title>--%>
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">--%>
<%--    <style>--%>
<%--        body {--%>
<%--            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);--%>
<%--            min-height: 100vh;--%>
<%--            display: flex;--%>
<%--            align-items: center;--%>
<%--            justify-content: center;--%>
<%--        }--%>
<%--        .card-main {--%>
<%--            background: white;--%>
<%--            border-radius: 24px;--%>
<%--            padding: 40px;--%>
<%--            box-shadow: 0 20px 60px rgba(0,0,0,0.2);--%>
<%--            max-width: 480px;--%>
<%--            width: 90%;--%>
<%--        }--%>
<%--        .input-phone {--%>
<%--            border-radius: 12px;--%>
<%--            padding: 14px 16px;--%>
<%--            font-size: 16px;--%>
<%--            border: 2px solid #e0e0e0;--%>
<%--        }--%>
<%--        .input-phone:focus { border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.2); }--%>
<%--        .btn-main {--%>
<%--            border-radius: 50px;--%>
<%--            padding: 14px;--%>
<%--            font-size: 16px;--%>
<%--            font-weight: bold;--%>
<%--            width: 100%;--%>
<%--            transition: transform 0.2s;--%>
<%--        }--%>
<%--        .btn-main:hover { transform: scale(1.02); }--%>
<%--        .btn-verify { background: #a8edea; border: none; color: #333; }--%>
<%--        .btn-verify:hover { background: #8fe0db; color: #333; }--%>
<%--        .btn-submit { background: #667eea; border: none; color: white; }--%>
<%--        .btn-submit:hover { background: #5a6fd6; color: white; }--%>
<%--        .verify-row { display: flex; gap: 10px; }--%>
<%--        .verify-row input { flex: 1; }--%>
<%--        .verify-row button { white-space: nowrap; border-radius: 12px; padding: 14px 20px; }--%>
<%--        .lotto-result { display: none; text-align: center; margin-top: 30px; }--%>
<%--        .lotto-balls { display: flex; justify-content: center; gap: 10px; margin: 20px 0; }--%>
<%--        .ball {--%>
<%--            width: 50px; height: 50px;--%>
<%--            border-radius: 50%;--%>
<%--            display: flex; align-items: center; justify-content: center;--%>
<%--            font-weight: bold; font-size: 18px; color: white;--%>
<%--            animation: popIn 0.3s ease-out;--%>
<%--        }--%>
<%--        @keyframes popIn {--%>
<%--            0% { transform: scale(0); }--%>
<%--            80% { transform: scale(1.2); }--%>
<%--            100% { transform: scale(1); }--%>
<%--        }--%>
<%--        .ball-1 { background: #fbc531; }--%>
<%--        .ball-2 { background: #4cd137; }--%>
<%--        .ball-3 { background: #00a8ff; }--%>
<%--        .ball-4 { background: #9c88ff; }--%>
<%--        .ball-5 { background: #e84393; }--%>
<%--        .ball-6 { background: #fd7979; }--%>
<%--        .alert-custom { border-radius: 12px; padding: 16px; font-size: 14px; }--%>
<%--        .back-link {--%>
<%--            display: inline-block; margin-top: 20px;--%>
<%--            color: #667eea; text-decoration: none; font-weight: bold;--%>
<%--        }--%>
<%--        .back-link:hover { text-decoration: underline; }--%>
<%--        .step { display: none; }--%>
<%--        .step.active { display: block; }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="card-main">--%>
<%--    <div id="step1" class="step active">--%>
<%--        <h3 class="fw-bold text-center mb-1">🎟️ 이벤트 참가</h3>--%>
<%--        <p class="text-muted text-center mb-4">휴대폰 인증 후 로또 번호를 받으세요!</p>--%>

<%--        <div class="mb-3">--%>
<%--            <label class="form-label fw-bold">휴대폰 번호</label>--%>
<%--            <div class="verify-row">--%>
<%--                <input type="text" id="phoneNumber" class="form-control input-phone"--%>
<%--                       placeholder="01012345678" maxlength="11">--%>
<%--                <button class="btn btn-verify fw-bold" onclick="sendVerification()">--%>
<%--                    인증요청--%>
<%--                </button>--%>
<%--            </div>--%>
<%--        </div>--%>

<%--        <div id="verifySection" class="mb-3" style="display:none;">--%>
<%--            <label class="form-label fw-bold">인증번호</label>--%>
<%--            <input type="text" id="verifyCode" class="form-control input-phone"--%>
<%--                   placeholder="인증번호 6자리" maxlength="6">--%>
<%--            <small class="text-muted">💡 테스트용 인증번호: <strong>123456</strong></small>--%>
<%--        </div>--%>

<%--        <div id="alertArea"></div>--%>

<%--        <button id="btnParticipate" class="btn btn-main btn-submit mt-3"--%>
<%--                onclick="participate()" style="display:none;">--%>
<%--            🎰 참가하기--%>
<%--        </button>--%>
<%--    </div>--%>

<%--    <div id="step2" class="step">--%>
<%--        <div class="lotto-result" id="lottoResult">--%>
<%--            <h3 class="fw-bold">🎉 참가 완료!</h3>--%>
<%--            <p class="text-muted">나의 로또 번호</p>--%>
<%--            <div class="lotto-balls" id="lottoBalls"></div>--%>
<%--            <p id="participantInfo" class="text-muted"></p>--%>
<%--            <div class="alert alert-info alert-custom">--%>
<%--                📩 로또 번호가 문자로 발송되었습니다!--%>
<%--            </div>--%>
<%--        </div>--%>
<%--        <a href="/" class="back-link">← 메인으로 돌아가기</a>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<script>--%>
<%--    function sendVerification() {--%>
<%--        var phone = document.getElementById('phoneNumber').value;--%>
<%--        if (!phone || phone.length < 10) {--%>
<%--            showAlert('휴대폰 번호를 올바르게 입력해주세요.', 'warning');--%>
<%--            return;--%>
<%--        }--%>
<%--        fetch('/api/event/verify/send?phoneNumber=' + phone, { method: 'POST' })--%>
<%--            .then(function(res) { return res.json(); })--%>
<%--            .then(function(data) {--%>
<%--                if (data.success) {--%>
<%--                    document.getElementById('verifySection').style.display = 'block';--%>
<%--                    document.getElementById('btnParticipate').style.display = 'block';--%>
<%--                    showAlert('인증번호가 발송되었습니다! (테스트: 123456)', 'success');--%>
<%--                } else {--%>
<%--                    showAlert(data.message, 'danger');--%>
<%--                }--%>
<%--            })--%>
<%--            .catch(function() { showAlert('서버 오류가 발생했습니다.', 'danger'); });--%>
<%--    }--%>

<%--    function participate() {--%>
<%--        var phone = document.getElementById('phoneNumber').value;--%>
<%--        var code = document.getElementById('verifyCode').value;--%>
<%--        if (!code) {--%>
<%--            showAlert('인증번호를 입력해주세요.', 'warning');--%>
<%--            return;--%>
<%--        }--%>
<%--        fetch('/api/event/participate', {--%>
<%--            method: 'POST',--%>
<%--            headers: { 'Content-Type': 'application/json' },--%>
<%--            body: JSON.stringify({--%>
<%--                eventId: 1,--%>
<%--                phoneNumber: phone,--%>
<%--                verificationCode: code--%>
<%--            })--%>
<%--        })--%>
<%--            .then(function(res) { return res.json(); })--%>
<%--            .then(function(data) {--%>
<%--                if (data.success) {--%>
<%--                    showLottoResult(data.data);--%>
<%--                } else {--%>
<%--                    showAlert(data.message, 'danger');--%>
<%--                }--%>
<%--            })--%>
<%--            .catch(function() { showAlert('서버 오류가 발생했습니다.', 'danger'); });--%>
<%--    }--%>

<%--    function showLottoResult(data) {--%>
<%--        document.getElementById('step1').classList.remove('active');--%>
<%--        document.getElementById('step2').classList.add('active');--%>
<%--        var ballColors = ['ball-1', 'ball-2', 'ball-3', 'ball-4', 'ball-5', 'ball-6'];--%>
<%--        var ballsContainer = document.getElementById('lottoBalls');--%>
<%--        ballsContainer.innerHTML = '';--%>
<%--        data.lottoNumbers.forEach(function(num, i) {--%>
<%--            setTimeout(function() {--%>
<%--                var ball = document.createElement('div');--%>
<%--                ball.className = 'ball ' + ballColors[i];--%>
<%--                ball.textContent = num;--%>
<%--                ballsContainer.appendChild(ball);--%>
<%--            }, i * 200);--%>
<%--        });--%>
<%--        document.getElementById('participantInfo').textContent =--%>
<%--            '참가번호: ' + data.participantNo + '번';--%>
<%--        document.getElementById('lottoResult').style.display = 'block';--%>
<%--    }--%>

<%--    function showAlert(msg, type) {--%>
<%--        document.getElementById('alertArea').innerHTML =--%>
<%--            '<div class="alert alert-' + type + ' alert-custom">' + msg + '</div>';--%>
<%--    }--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>