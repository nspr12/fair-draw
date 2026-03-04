<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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