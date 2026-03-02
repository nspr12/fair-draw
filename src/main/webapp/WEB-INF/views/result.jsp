<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="ko">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1.0">--%>
<%--    <title>🔍 결과 확인</title>--%>
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">--%>
<%--    <style>--%>
<%--        body {--%>
<%--            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);--%>
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
<%--            max-width: 520px;--%>
<%--            width: 90%;--%>
<%--        }--%>
<%--        .input-phone {--%>
<%--            border-radius: 12px;--%>
<%--            padding: 14px 16px;--%>
<%--            font-size: 16px;--%>
<%--            border: 2px solid #e0e0e0;--%>
<%--        }--%>
<%--        .input-phone:focus { border-color: #f093fb; box-shadow: 0 0 0 3px rgba(240,147,251,0.2); }--%>
<%--        .btn-main {--%>
<%--            border-radius: 50px;--%>
<%--            padding: 14px;--%>
<%--            font-size: 16px;--%>
<%--            font-weight: bold;--%>
<%--            width: 100%;--%>
<%--            background: #f093fb;--%>
<%--            border: none;--%>
<%--            color: white;--%>
<%--            transition: transform 0.2s;--%>
<%--        }--%>
<%--        .btn-main:hover { transform: scale(1.02); background: #e07eec; color: white; }--%>
<%--        .lotto-balls { display: flex; justify-content: center; gap: 8px; margin: 15px 0; }--%>
<%--        .ball {--%>
<%--            width: 46px; height: 46px;--%>
<%--            border-radius: 50%;--%>
<%--            display: flex; align-items: center; justify-content: center;--%>
<%--            font-weight: bold; font-size: 16px; color: white;--%>
<%--            animation: popIn 0.3s ease-out;--%>
<%--        }--%>
<%--        @keyframes popIn {--%>
<%--            0% { transform: scale(0); }--%>
<%--            80% { transform: scale(1.2); }--%>
<%--            100% { transform: scale(1); }--%>
<%--        }--%>
<%--        .ball-match { background: #e84393; box-shadow: 0 0 15px rgba(232,67,147,0.5); }--%>
<%--        .ball-miss { background: #b2bec3; }--%>
<%--        .ball-winning { background: #fdcb6e; }--%>
<%--        .result-box {--%>
<%--            border-radius: 16px;--%>
<%--            padding: 24px;--%>
<%--            text-align: center;--%>
<%--            margin-top: 20px;--%>
<%--        }--%>
<%--        .result-winner {--%>
<%--            background: linear-gradient(135deg, #fff9c4, #fff176);--%>
<%--            border: 2px solid #fdd835;--%>
<%--        }--%>
<%--        .result-loser {--%>
<%--            background: #f8f9fa;--%>
<%--            border: 2px solid #e0e0e0;--%>
<%--        }--%>
<%--        .rank-badge {--%>
<%--            display: inline-block;--%>
<%--            background: #e84393;--%>
<%--            color: white;--%>
<%--            padding: 8px 24px;--%>
<%--            border-radius: 50px;--%>
<%--            font-size: 20px;--%>
<%--            font-weight: bold;--%>
<%--            margin: 10px 0;--%>
<%--        }--%>
<%--        .section-label {--%>
<%--            font-size: 13px;--%>
<%--            color: #999;--%>
<%--            font-weight: bold;--%>
<%--            margin-bottom: 5px;--%>
<%--        }--%>
<%--        .alert-custom { border-radius: 12px; padding: 16px; font-size: 14px; }--%>
<%--        .back-link {--%>
<%--            display: inline-block; margin-top: 20px;--%>
<%--            color: #f093fb; text-decoration: none; font-weight: bold;--%>
<%--        }--%>
<%--        .back-link:hover { text-decoration: underline; }--%>
<%--        #resultArea { display: none; }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="card-main">--%>
<%--    <div id="inputArea">--%>
<%--        <h3 class="fw-bold text-center mb-1">🔍 결과 확인</h3>--%>
<%--        <p class="text-muted text-center mb-4">참가한 휴대폰 번호를 입력하세요</p>--%>

<%--        <div class="mb-3">--%>
<%--            <label class="form-label fw-bold">휴대폰 번호</label>--%>
<%--            <input type="text" id="phoneNumber" class="form-control input-phone"--%>
<%--                   placeholder="01012345678" maxlength="11">--%>
<%--        </div>--%>

<%--        <div id="alertArea"></div>--%>

<%--        <button class="btn btn-main mt-2" onclick="checkResult()">--%>
<%--            🔍 결과 확인하기--%>
<%--        </button>--%>
<%--    </div>--%>

<%--    <div id="resultArea">--%>
<%--        <div id="resultBox" class="result-box">--%>
<%--            <div id="resultEmoji" style="font-size: 48px;"></div>--%>
<%--            <div id="resultMessage" class="fw-bold fs-5 mt-2"></div>--%>
<%--            <div id="rankBadge"></div>--%>
<%--        </div>--%>

<%--        <div class="mt-4">--%>
<%--            <div class="section-label">🎟️ 나의 번호</div>--%>
<%--            <div class="lotto-balls" id="myBalls"></div>--%>
<%--        </div>--%>

<%--        <div class="mt-3">--%>
<%--            <div class="section-label">🏆 당첨 번호</div>--%>
<%--            <div class="lotto-balls" id="winningBalls"></div>--%>
<%--        </div>--%>

<%--        <button class="btn btn-main mt-4" onclick="resetForm()">--%>
<%--            다시 확인하기--%>
<%--        </button>--%>
<%--        <br>--%>
<%--        <a href="/" class="back-link">← 메인으로 돌아가기</a>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<script>--%>
<%--    function checkResult() {--%>
<%--        var phone = document.getElementById('phoneNumber').value;--%>
<%--        if (!phone || phone.length < 10) {--%>
<%--            showAlert('휴대폰 번호를 올바르게 입력해주세요.', 'warning');--%>
<%--            return;--%>
<%--        }--%>
<%--        fetch('/api/event/result?eventId=1&phoneNumber=' + phone)--%>
<%--            .then(function(res) { return res.json(); })--%>
<%--            .then(function(data) {--%>
<%--                if (data.success) {--%>
<%--                    showResult(data.data);--%>
<%--                } else {--%>
<%--                    showAlert(data.message, 'danger');--%>
<%--                }--%>
<%--            })--%>
<%--            .catch(function() { showAlert('서버 오류가 발생했습니다.', 'danger'); });--%>
<%--    }--%>

<%--    function showResult(data) {--%>
<%--        document.getElementById('inputArea').style.display = 'none';--%>
<%--        document.getElementById('resultArea').style.display = 'block';--%>

<%--        var resultBox = document.getElementById('resultBox');--%>
<%--        var resultEmoji = document.getElementById('resultEmoji');--%>
<%--        var resultMessage = document.getElementById('resultMessage');--%>
<%--        var rankBadge = document.getElementById('rankBadge');--%>

<%--        if (data.winner) {--%>
<%--            resultBox.className = 'result-box result-winner';--%>
<%--            resultEmoji.textContent = '🎊';--%>
<%--            resultMessage.textContent = data.message;--%>
<%--            if (data.rankType) {--%>
<%--                rankBadge.innerHTML = '<span class="rank-badge">' + data.rankType + '등 당첨!</span>';--%>
<%--            } else {--%>
<%--                rankBadge.innerHTML = '';--%>
<%--            }--%>
<%--        } else {--%>
<%--            resultBox.className = 'result-box result-loser';--%>
<%--            resultEmoji.textContent = '😢';--%>
<%--            resultMessage.textContent = data.message;--%>
<%--            rankBadge.innerHTML = '';--%>
<%--        }--%>

<%--        renderBalls('myBalls', data.myNumbers, data.winningNumbers, true);--%>
<%--        renderBalls('winningBalls', data.winningNumbers, null, false);--%>
<%--    }--%>

<%--    function renderBalls(containerId, numbers, winningNumbers, checkMatch) {--%>
<%--        var container = document.getElementById(containerId);--%>
<%--        container.innerHTML = '';--%>
<%--        numbers.forEach(function(num, i) {--%>
<%--            setTimeout(function() {--%>
<%--                var ball = document.createElement('div');--%>
<%--                ball.className = 'ball ';--%>
<%--                if (checkMatch && winningNumbers) {--%>
<%--                    ball.className += winningNumbers.indexOf(num) >= 0 ? 'ball-match' : 'ball-miss';--%>
<%--                } else {--%>
<%--                    ball.className += 'ball-winning';--%>
<%--                }--%>
<%--                ball.textContent = num;--%>
<%--                container.appendChild(ball);--%>
<%--            }, i * 150);--%>
<%--        });--%>
<%--    }--%>

<%--    function resetForm() {--%>
<%--        document.getElementById('inputArea').style.display = 'block';--%>
<%--        document.getElementById('resultArea').style.display = 'none';--%>
<%--        document.getElementById('phoneNumber').value = '';--%>
<%--        document.getElementById('alertArea').innerHTML = '';--%>
<%--    }--%>

<%--    function showAlert(msg, type) {--%>
<%--        document.getElementById('alertArea').innerHTML =--%>
<%--            '<div class="alert alert-' + type + ' alert-custom">' + msg + '</div>';--%>
<%--    }--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>