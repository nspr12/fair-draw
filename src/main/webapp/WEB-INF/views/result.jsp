<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>한정판 드로우 결과 확인</title>
    <style>
        body { font-family: 'Arial', sans-serif; background-color: #111; color: #fff; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .container { background: #222; padding: 40px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.5); width: 100%; max-width: 400px; text-align: center; }
        h2 { color: #f1c40f; margin-bottom: 20px; }
        .form-group { margin-bottom: 20px; text-align: left; }
        label { display: block; margin-bottom: 8px; font-weight: bold; color: #ccc; }
        input[type="text"] { width: 100%; padding: 12px; border: 1px solid #444; background: #333; color: #fff; border-radius: 5px; box-sizing: border-box; }
        button { width: 100%; padding: 14px; background-color: #f1c40f; color: #111; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; margin-top: 10px; transition: 0.3s; }
        button:hover { background-color: #d4ac0d; }

        /* 결과 메시지 박스 스타일 */
        #resultBox { margin-top: 25px; padding: 20px; border-radius: 8px; display: none; font-size: 1.1em; line-height: 1.5; }
        .winner { background-color: #2ecc71; color: #111; font-weight: bold; animation: pop 0.5s ease-out; }
        .loser { background-color: #e74c3c; color: #fff; }

        @keyframes pop {
            0% { transform: scale(0.8); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }
    </style>
</head>
<body>

<div class="container">
    <h2>🏆 당첨 결과 확인</h2>

    <div id="eventStatusBadge" style="text-align: center; color: #e74c3c; font-weight: bold; margin-bottom: 20px;"></div>

    <p style="color: #aaa; font-size: 0.9em; margin-bottom: 30px;">응모하신 휴대폰 번호를 입력해 주세요.</p>

    <div class="form-group">
        <label for="phoneNumber">휴대폰 번호 (- 없이 입력)</label>
        <input type="text" id="phoneNumber" placeholder="예: 01012345678" maxlength="11">
    </div>

    <input type="hidden" id="eventId" value="1">

    <button type="button" onclick="checkResult()">결과 보기</button>

    <div id="resultBox"></div>
</div>

<script>
    const simulatedDate = localStorage.getItem('fairDrawDate');
    if (simulatedDate) {
        document.getElementById('eventStatusBadge').innerText = "⏰ 관리자 테스트 모드: " + simulatedDate + " 기준";
    }

    function checkResult() {
        const eventId = document.getElementById('eventId').value;
        const phone = document.getElementById('phoneNumber').value;
        const resultBox = document.getElementById('resultBox');

        if (!phone) {
            alert("휴대폰 번호를 입력해주세요.");
            return;
        }

        // 결과 박스 초기화
        resultBox.style.display = 'none';
        resultBox.className = '';

        // API 호출 (GET 방식)
        fetch('/api/event/result?eventId=' + eventId + '&phoneNumber=' + phone)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const resultData = data.data;
                    resultBox.style.display = 'block';

                    if (resultData.isWinner) {
                        // 당첨 시 (우리가 추가했던 등수와 상품명이 여기서 빛을 발합니다!)
                        resultBox.className = 'winner';
                        resultBox.innerHTML = resultData.message + "<br><br>🎁 <strong>" + resultData.prizeName + "</strong>";
                    } else {
                        // 미당첨 시
                        resultBox.className = 'loser';
                        resultBox.innerHTML = resultData.message;
                    }
                } else {
                    alert("조회 실패: " + data.message);
                }
            })
            .catch(error => console.error('Error:', error));
    }
</script>

</body>
</html>