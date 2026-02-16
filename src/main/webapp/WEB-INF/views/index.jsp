<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🎰 로또 이벤트</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .main-card {
            background: white;
            border-radius: 24px;
            padding: 50px 40px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            max-width: 500px;
            width: 90%;
        }
        .emoji-title { font-size: 64px; margin-bottom: 10px; }
        .btn-event {
            padding: 16px 40px;
            font-size: 18px;
            border-radius: 50px;
            font-weight: bold;
            margin: 8px;
            transition: transform 0.2s;
        }
        .btn-event:hover { transform: scale(1.05); }
        .btn-participate { background: #667eea; border: none; color: white; }
        .btn-participate:hover { background: #5a6fd6; color: white; }
        .btn-result { background: #f093fb; border: none; color: white; }
        .btn-result:hover { background: #e07eec; color: white; }
        .period-info {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 15px;
            margin: 20px 0;
            font-size: 14px;
            color: #666;
        }
    </style>
</head>
<body>
<div class="main-card">
    <div class="emoji-title">🎰</div>
    <h1 class="fw-bold mb-2">2025 로또 이벤트</h1>
    <p class="text-muted mb-3">무료 로또 번호를 받고 경품에 도전하세요!</p>

    <div class="period-info">
        📅 이벤트 기간: 2025.02.01 ~ 2025.03.31<br>
        📢 발표 기간: 2025.04.01 ~ 2025.04.15
    </div>

    <div class="mt-4">
        <a href="/participate" class="btn btn-event btn-participate">
            🎟️ 이벤트 참가하기
        </a>
        <br>
        <a href="/result" class="btn btn-event btn-result mt-2">
            🔍 결과 확인하기
        </a>
    </div>
</div>
</body>
</html>