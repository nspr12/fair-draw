<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>한정판 드로우 응모하기</title>
    <style>
        body { font-family: 'Arial', sans-serif; background-color: #f4f4f5; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .container { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 100%; max-width: 400px; }
        h2 { text-align: center; color: #333; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; }
        input[type="text"] { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background-color: #000; color: #fff; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; margin-top: 5px; }
        button:hover { background-color: #333; }
        .btn-secondary { background-color: #6c757d; }
        .btn-secondary:hover { background-color: #5a6268; }
    </style>
</head>
<body>

<div class="container">
    <h2>🎁 FairDraw 응모하기</h2>

    <div id="eventStatusBadge" style="text-align: center; color: #e74c3c; font-weight: bold; margin-bottom: 20px;"></div>

    <div class="form-group">
        <label for="phoneNumber">휴대폰 번호 (- 없이 입력)</label>
        <input type="text" id="phoneNumber" placeholder="예: 01012345678" maxlength="11">
        <button type="button" class="btn-secondary" onclick="sendVerification()">인증번호 발송</button>
    </div>

    <div class="form-group">
        <label for="verificationCode">인증번호</label>
        <input type="text" id="verificationCode" placeholder="인증번호 6자리 입력" maxlength="6">
    </div>

    <input type="hidden" id="eventId" value="1">

    <button type="button" onclick="participateEvent()">응모 완료하기</button>
</div>

<script>
    const simulatedDate = localStorage.getItem('fairDrawDate');
    if (simulatedDate) {
        document.getElementById('eventStatusBadge').innerText = "⏰ 관리자 테스트 모드: " + simulatedDate + " 기준";
    }

    // 1. 인증번호 발송 API 호출
    function sendVerification() {
        const phone = document.getElementById('phoneNumber').value;
        if (!phone) {
            alert("휴대폰 번호를 입력해주세요.");
            return;
        }

        fetch('/api/event/verify/send?phoneNumber=' + phone, {
            method: 'POST'
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert("인증번호가 발송되었습니다. (테스트용: 123456)");
                } else {
                    alert("오류: " + data.message);
                }
            })
            .catch(error => console.error('Error:', error));
    }

    // 2. 이벤트 응모 API 호출
    function participateEvent() {
        const eventId = document.getElementById('eventId').value;
        const phone = document.getElementById('phoneNumber').value;
        const code = document.getElementById('verificationCode').value;

        if (!phone || !code) {
            alert("휴대폰 번호와 인증번호를 모두 입력해주세요.");
            return;
        }

        const requestData = {
            eventId: parseInt(eventId),
            phoneNumber: phone,
            verificationCode: code
        };

        fetch('/api/event/participate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(requestData)
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert("🎉 " + data.message);
                    window.location.href = "/"; // 메인으로 이동
                } else {
                    alert("응모 실패: " + data.message);
                }
            })
            .catch(error => console.error('Error:', error));
    }
</script>

</body>
</html>