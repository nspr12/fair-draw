<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FairDraw - 한정판 추첨 시스템</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/lottie-web/5.12.2/lottie.min.js"></script>
    <style>
        body { font-family: 'Arial', sans-serif; background-color: #111; color: #fff; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .container { background: #222; padding: 40px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.5); width: 100%; max-width: 400px; text-align: center; }
        h1 { color: #f1c40f; margin-bottom: 5px; }
        .status-badge { display: inline-block; padding: 5px 10px; border-radius: 20px; font-size: 0.8em; font-weight: bold; margin-bottom: 30px; background: #444; color: #fff; }
        button { width: 100%; padding: 14px; margin-bottom: 10px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; transition: 0.3s; }
        .btn-primary { background-color: #f1c40f; color: #111; }
        .btn-primary:hover { background-color: #d4ac0d; }
        .btn-secondary { background-color: #333; color: #fff; border: 1px solid #555; }
        .btn-secondary:hover { background-color: #444; }
        .btn-admin { background-color: transparent; color: #888; text-decoration: underline; margin-top: 20px; font-size: 0.9em; }
        #lottie-bg {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            min-width: 100vw;
            min-height: 100vh;
            z-index: 0;
            pointer-events: none;
            opacity: 0.5;
            mix-blend-mode: screen;
        }
        .container {
            position: relative;
            z-index: 1;
        }
    </style>
</head>
<body>

<div id="lottie-bg"></div>
<script>
    lottie.loadAnimation({
        container: document.getElementById('lottie-bg'),
        renderer: 'svg',
        loop: true,
        autoplay: true,
        path: '/static/balloons.json'
    });
</script>

<div class="container">
    <h1>🎁 FairDraw</h1>
    <p>공정하고 투명한 한정판 드로우</p>

    <div id="eventStatusBadge" class="status-badge">상태 확인 중...</div>

    <button class="btn-primary" onclick="location.href='/participate'">응모하기</button>
    <button class="btn-secondary" onclick="location.href='/result'">당첨 결과 확인</button>

    <button class="btn-admin" onclick="location.href='/admin'">관리자 대시보드 (Admin)</button>
</div>

<script>
    // 로컬 스토리지에서 테스트용 날짜 가져오기
    const simulatedDate = localStorage.getItem('fairDrawDate');
    let url = '/api/event/status?eventId=1'; // 이벤트 상태 API
    if (simulatedDate) {
        url += '&simulatedDate=' + simulatedDate;
    }

    // 이벤트 상태 API 호출해서 화면에 표시
    fetch(url)
        .then(res => res.json())
        .then(data => {
            const badge = document.getElementById('eventStatusBadge');
            if(data.success) {
                badge.innerText = "현재 상태: " + data.data.periodLabel + (simulatedDate ? " (⏰ " + simulatedDate + " 기준)" : "");
                if(data.data.period === 'ACTIVE_PERIOD') badge.style.background = '#2ecc71'; // 진행중 초록색
                if(data.data.period === 'ANNOUNCE_PERIOD') badge.style.background = '#e74c3c'; // 발표기간 빨간색
            }
        }).catch(e => console.error(e));
</script>

</body>
</html>