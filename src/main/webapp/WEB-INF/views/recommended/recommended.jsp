<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>추천 여행지</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body>
<!-- 헤더와 네비게이션 -->
<header id="top-header">
    <jsp:include page="/WEB-INF/views/layout/nav.jsp" />
</header>

<!-- 상단 탭 메뉴 -->
<ul class="nav nav-tabs justify-content-center" id="travelTab" role="tablist">
    <li class="nav-item" role="presentation">
        <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all" type="button" role="tab" aria-controls="all" aria-selected="true">전체</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="ai-tab" data-bs-toggle="tab" data-bs-target="#ai" type="button" role="tab" aria-controls="ai" aria-selected="false">AI추천여행지</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="popular-tab" data-bs-toggle="tab" data-bs-target="#popular" type="button" role="tab" aria-controls="popular" aria-selected="false">인기 여행지</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="season-tab" data-bs-toggle="tab" data-bs-target="#season" type="button" role="tab" aria-controls="season" aria-selected="false">여행 코스 추천</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="festival-tab" data-bs-toggle="tab" data-bs-target="#festival" type="button" role="tab" aria-controls="festival" aria-selected="false">문화 축제</button>
    </li>
</ul>

<!-- 탭별 콘텐츠 -->
<div class="tab-content" id="travelTabContent" style="margin-top: 1.5rem;">
    <!-- (1) 전체 탭 -->
    <div class="tab-pane fade show active" id="all" role="tabpanel" aria-labelledby="all-tab">
        <jsp:include page="/WEB-INF/views/recommended/ai.jsp">
            <jsp:param name="limit" value="6" />
        </jsp:include>
        <jsp:include page="/WEB-INF/views/recommended/popular.jsp" />
        <jsp:include page="/WEB-INF/views/recommended/season.jsp" />
        <jsp:include page="/WEB-INF/views/recommended/festival.jsp">
            <jsp:param name="limit" value="6" />
        </jsp:include>
    </div>

    <!-- (2) AI추천여행지 탭 -->
    <div class="tab-pane fade" id="ai" role="tabpanel" aria-labelledby="ai-tab">
        <jsp:include page="/WEB-INF/views/recommended/ai.jsp" />
    </div>

    <!-- (3) 인기 여행지 탭 -->
    <div class="tab-pane fade" id="popular" role="tabpanel" aria-labelledby="popular-tab">
        <jsp:include page="/WEB-INF/views/recommended/popular.jsp" />
    </div>

    <!-- (4)(여행코스 추천) -->
    <div class="tab-pane fade" id="season" role="tabpanel" aria-labelledby="season-tab">
        <jsp:include page="/WEB-INF/views/recommended/travelcourse.jsp" />
    </div>

    <!-- (5) 문화 축제 탭 -->
    <div class="tab-pane fade" id="festival" role="tabpanel" aria-labelledby="festival-tab">
        <jsp:include page="/WEB-INF/views/recommended/festival.jsp" />
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
