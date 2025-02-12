<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<html>
<head>
    <title>여행지 상세 정보</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body { font-family: Arial, sans-serif; }
        .container { width: 80%; margin: 30px auto 50px auto; }
        .title { font-size: 24px; font-weight: bold; margin-top: 20px; }
        .image-container img { width: 100%; max-height: 400px; object-fit: cover; }
        .details { margin-top: 20px; }
        .info-box { padding: 10px; border: 1px solid #ddd; margin-top: 10px; }
        .info-box h3 { margin-bottom: 10px; }
        /* 지도 표시 영역 */
        #map { width: 100%; height: 400px; margin-top: 20px; }
    </style>
</head>
<body>
<!-- 공통 네비게이션 -->
<jsp:include page="/WEB-INF/views/layout/nav.jsp" />

<div class="container">
    <h1 class="title">여행지 상세 정보</h1>
        <%
            // 좌표를 포함한 기본 정보를 사용하기 위해 변수들을 미리 선언
            String mapX = "";
            String mapY = "";
            String mlevel = "";

            // 컨트롤러에서 전달받은 items 배열을 이용
            JSONArray items = (JSONArray) request.getAttribute("items");
            if (items != null && items.length() > 0) {
                JSONObject item = items.getJSONObject(0);

                // 좌표 관련 값은 나중에 지도 초기화 시 사용
                mapX = item.optString("mapx", "").trim();
                mapY = item.optString("mapy", "").trim();
                mlevel = item.optString("mlevel", "").trim();
        %>
    <!-- 제목 -->
        <%
            String title = item.optString("title", "").trim();
            if (!title.isEmpty()) {
        %>
    <h2><%= title %></h2>
        <%
            }
        %>

    <!-- 이미지 -->
    <div class="image-container">
        <%
            String firstImage = item.optString("firstimage", "").trim();
            if (!firstImage.isEmpty()) {
        %>
        <img src="<%= firstImage %>" alt="여행지 이미지" />
        <%
        } else {
        %>
        <img src="default.jpg" alt="기본 이미지" />
        <%
            }
        %>
    </div>

    <!-- 기본 정보 -->
    <div class="details">
        <%
            String address = item.optString("addr1", "").trim();
            if (!address.isEmpty()) {
        %>
        <div class="info-box">
            <h3>주소</h3>
            <p><%= address %></p>
        </div>
        <%
            }
            String overview = item.optString("overview", "").trim();
            if (!overview.isEmpty()) {
        %>
        <div class="info-box">
            <h3>상세 설명</h3>
            <p><%= overview %></p>
        </div>
        <%
            }
            String homepage = item.optString("homepage", "").trim();
            if (!homepage.isEmpty()) {
        %>
        <div class="info-box">
            <h3>홈페이지</h3>
            <p>
                <a href="<%= homepage %>" target="_blank">
                    <%= homepage %>
                </a>
            </p>
        </div>
        <%
            }
            String tel = item.optString("tel", "").trim();
            if (!tel.isEmpty()) {
        %>
        <div class="info-box">
            <h3>전화번호</h3>
            <p><%= tel %></p>
        </div>
        <%
            }
            // 지도 좌표 info-box는 제거합니다.
        } else {
        %>
        <p>데이터를 불러오지 못했습니다.</p>
        <%
            }
        %>

        <!-- 지도 영역 제목 -->
        <div class="info-box">
            <h3>지도</h3>
            <!-- 지도 영역 -->
            <div id="map"></div>
            <!-- Kakao Map API 스크립트 및 지도 초기화 -->
            <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1566bd1d6f68d1023bc9a09a03089078"></script>
            <script>
                <%
                   // 좌표 값이 존재할 경우에만 지도 초기화
                   if (!mapX.isEmpty() && !mapY.isEmpty() && !mlevel.isEmpty()) {
                %>
                // Kakao Map API는 위도(mapY), 경도(mapX) 순서입니다.
                var container = document.getElementById('map');
                var options = {
                    center: new kakao.maps.LatLng(<%= mapY %>, <%= mapX %>),
                    level: parseInt('<%= mlevel %>')
                };
                var map = new kakao.maps.Map(container, options);

                // 마커 생성
                var markerPosition = new kakao.maps.LatLng(<%= mapY %>, <%= mapX %>);
                var marker = new kakao.maps.Marker({
                    position: markerPosition
                });
                marker.setMap(map);
                <% } %>
            </script>
        </div>

        <hr style="margin-top:40px; margin-bottom:40px;">

        <!-- 타입별 추가 상세정보 include -->
        <c:choose>
            <c:when test="${contenttypeid == '12'}">
                <jsp:include page="/WEB-INF/views/recommended/detail_type12.jsp" />
            </c:when>
            <c:when test="${contenttypeid == '14'}">
                <jsp:include page="/WEB-INF/views/recommended/detail_type14.jsp" />
            </c:when>
            <c:when test="${contenttypeid == '15'}">
                <jsp:include page="/WEB-INF/views/recommended/detail_type15.jsp" />
            </c:when>
            <c:when test="${contenttypeid == '25'}">
                <jsp:include page="/WEB-INF/views/recommended/detail_type25.jsp" />
            </c:when>
            <c:when test="${contenttypeid == '28'}">
                <jsp:include page="/WEB-INF/views/recommended/detail_type28.jsp" />
            </c:when>
            <c:when test="${contenttypeid == '39'}">
                <jsp:include page="/WEB-INF/views/recommended/detail_type39.jsp" />
            </c:when>
            <c:otherwise>
                <div class="info-box">
                    <p>추가 상세 정보가 없습니다.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 공통 푸터 -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
