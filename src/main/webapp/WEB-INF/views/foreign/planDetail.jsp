<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>여행 일정 상세</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=${apikey}"></script>
    <style>
        .plan-container {
            display: flex;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .schedule-list {
            flex: 1;
            padding-right: 20px;
        }

        .map-container {
            flex: 1;
            position: sticky;
            top: 20px;
            height: calc(100vh - 40px);
        }

        .day-schedule {
            margin-bottom: 30px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
        }

        .day-header {
            background: #f5f5f5;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
            padding: 10px;
            border-left: 3px solid #007bff;
        }

        .activity-time {
            min-width: 80px;
            font-weight: bold;
        }

        .activity-details {
            flex: 1;
        }

        .activity-type {
            font-size: 0.9em;
            color: #666;
            margin-bottom: 5px;
        }

        .activity-notes {
            font-size: 0.9em;
            color: #666;
            margin-top: 5px;
        }

        #map {
            width: 100%;
            height: 100%;
            border-radius: 8px;
        }

        .summary-section {
            margin-bottom: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .main-attractions {
            margin-top: 10px;
        }

        .main-attractions ul {
            list-style-type: none;
            padding: 0;
        }

        .main-attractions li {
            display: inline-block;
            margin-right: 15px;
            background: #e9ecef;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
<div class="plan-container">
    <div class="schedule-list">
        <!-- 여행 요약 정보 -->
        <div class="summary-section">
            <h2>${destination} 여행 일정</h2>
            <p>여행 기간: ${startDate} ~ ${endDate}</p>
            <div class="main-attractions">
                <h3>주요 관광지</h3>
                <ul>
                    <c:forEach items="${summary.mainAttractions}" var="attraction">
                        <li>${attraction}</li>
                    </c:forEach>
                </ul>
            </div>
            <p>${summary.routeOverview}</p>
        </div>

        <!-- 일자별 일정 -->
        <c:forEach items="${dailySchedule}" var="day">
            <div class="day-schedule" data-day="${day.day}">
                <div class="day-header">
                    <h3>Day ${day.day} - <fmt:formatDate value="${day.date}" pattern="yyyy-MM-dd"/></h3>
                </div>

                <c:forEach items="${day.activities}" var="activity">
                    <div class="activity-item"
                         data-lat="${activity.location.lat}"
                         data-lng="${activity.location.lng}"
                         data-type="${activity.type}">
                        <div class="activity-time">${activity.time}</div>
                        <div class="activity-details">
                            <div class="activity-type">${activity.type}</div>
                            <h4>${activity.place}</h4>
                            <div>소요시간: ${activity.duration}분</div>
                            <div class="activity-notes">${activity.notes}</div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:forEach>
    </div>

    <div class="map-container">
        <div id="map"></div>
    </div>
</div>

<script>
    // 구글 지도 초기화 및 마커 표시 로직
    let map;
    let markers = [];
    let currentInfoWindow = null;

    function initMap() {
        // 첫 번째 장소의 위치로 지도 초기화
        const firstActivity = $('.activity-item').first();
        const lat = parseFloat(firstActivity.data('lat'));
        const lng = parseFloat(firstActivity.data('lng'));

        map = new google.maps.Map(document.getElementById('map'), {
            zoom: 13,
            center: { lat, lng }
        });

        // 각 일정별 마커 생성
        $('.activity-item').each(function() {
            const $activity = $(this);
            const position = {
                lat: parseFloat($activity.data('lat')),
                lng: parseFloat($activity.data('lng'))
            };

            const marker = new google.maps.Marker({
                position: position,
                map: map,
                title: $activity.find('h4').text()
            });

            const infoWindow = new google.maps.InfoWindow({
                content: `
                        <div>
                            <h3>${$activity.find('h4').text()}</h3>
                            <p>시간: ${$activity.find('.activity-time').text()}</p>
                            <p>유형: ${$activity.find('.activity-type').text()}</p>
                            <p>${$activity.find('.activity-notes').text()}</p>
                        </div>
                    `
            });

            marker.addListener('click', () => {
                if (currentInfoWindow) {
                    currentInfoWindow.close();
                }
                infoWindow.open(map, marker);
                currentInfoWindow = infoWindow;
            });

            markers.push(marker);
        });

        // 모든 마커가 보이도록 지도 범위 조정
        const bounds = new google.maps.LatLngBounds();
        markers.forEach(marker => bounds.extend(marker.getPosition()));
        map.fitBounds(bounds);
    }

    // 페이지 로드 시 지도 초기화
    $(document).ready(function() {
        initMap();

        // 일정 항목 호버 시 해당 마커 강조
        $('.activity-item').hover(
            function() {
                const index = $('.activity-item').index(this);
                markers[index].setAnimation(google.maps.Animation.BOUNCE);
            },
            function() {
                const index = $('.activity-item').index(this);
                markers[index].setAnimation(null);
            }
        );
    });
</script>
</body>
</html>