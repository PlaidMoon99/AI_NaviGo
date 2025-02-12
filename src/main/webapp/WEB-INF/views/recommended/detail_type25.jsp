<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<div class="info-box">
    <h3>추가 상세 정보 (여행코스)</h3>
    <%
        String detailStr = (String) request.getAttribute("detail");
        if (detailStr != null && !"Detail 정보 없음".equals(detailStr)) {
            try {
                JSONArray detailArray = new JSONArray(detailStr);
                if (detailArray.length() > 0) {
                    JSONObject detailItem = detailArray.getJSONObject(0);
                    String distance = detailItem.optString("distance", "").trim();
                    String taketime = detailItem.optString("taketime", "").trim();
                    String infocentertourcourse = detailItem.optString("infocentertourcourse", "").trim();
                    String schedule = detailItem.optString("schedule", "").trim();

                    if (!distance.isEmpty()) {
    %>
    <p><strong>총 거리:</strong> <%= distance %></p>
    <%
        }
        if (!taketime.isEmpty()) {
    %>
    <p><strong>소요시간:</strong> <%= taketime %></p>
    <%
        }
        if (!infocentertourcourse.isEmpty()) {
    %>
    <p><strong>문의처:</strong> <%= infocentertourcourse %></p>
    <%
        }
        if (!schedule.isEmpty()) {
    %>
    <p><strong>추천 일정:</strong> <%= schedule %></p>
    <%
        }
        if(distance.isEmpty() && taketime.isEmpty() && infocentertourcourse.isEmpty() && schedule.isEmpty()){
    %>
    <p>추가 상세 정보가 없습니다.</p>
    <%
        }
    } else {
    %>
    <p>추가 상세 정보가 없습니다.</p>
    <%
        }
    } catch (Exception e) {
    %>
    <p>추가 상세 정보 파싱 중 오류 발생.</p>
    <%
        }
    } else {
    %>
    <p>추가 상세 정보가 없습니다.</p>
    <%
        }
    %>
</div>
