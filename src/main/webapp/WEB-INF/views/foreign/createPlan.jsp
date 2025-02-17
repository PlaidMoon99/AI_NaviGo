<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>해외 여행 일정 만들기</title>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Google Places API -->
    <script src="https://maps.googleapis.com/maps/api/js?key=${apikey}&libraries=places"></script>
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <!-- Select2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <style>
        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form-row {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .form-row > div {
            flex: 1;
        }
        .btn-submit {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }
        .btn-submit:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }
        .select2-container {
            width: 100% !important;
        }
    </style>
</head>
<body>
<div class="container">
    <h2 style="text-align: center; margin-bottom: 30px;">해외 여행 일정 만들기</h2>

    <form id="travelPlanForm">
        <!-- 여행지 검색 -->
        <div class="form-group">
            <label for="locationSearch">여행지 선택</label>
            <input type="text" id="locationSearch" class="form-control" placeholder="도시를 검색하세요 (예: 도쿄, 파리)">
            <div id="locationError" class="error-message">여행지를 선택해주세요.</div>
            <input type="hidden" id="destinationName">
            <input type="hidden" id="destinationLat">
            <input type="hidden" id="destinationLng">
        </div>

        <!-- 여행 날짜 선택 -->
        <div class="form-row">
            <div class="form-group">
                <label for="startDate">여행 시작일</label>
                <input type="date" id="startDate" class="form-control" required>
                <div id="dateError" class="error-message">시작일을 선택해주세요.</div>
            </div>
            <div class="form-group">
                <label for="duration">여행 기간</label>
                <select id="duration" class="form-control" required>
                    <c:forEach begin="1" end="14" var="day">
                        <option value="${day}">${day}일</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <!-- 여행 테마 -->
        <div class="form-group">
            <label>여행 테마 (최대 3개 선택)</label>
            <select id="themes" multiple="multiple" class="form-control">
                <option value="박물관">박물관</option>
                <option value="미술관">미술관</option>
                <option value="문화/역사">문화/역사</option>
                <option value="관광명소">관광명소</option>
                <option value="자연/아웃도어">자연/아웃도어</option>
                <option value="음식/맛집">음식/맛집</option>
                <option value="쇼핑">쇼핑</option>
                <option value="휴양/힐링">휴양/힐링</option>
            </select>
            <div id="themeError" class="error-message">최소 1개의 테마를 선택해주세요.</div>
        </div>

        <!-- 여행자 정보 -->
        <div class="form-row">
            <div class="form-group">
                <label for="travellerType">여행 타입</label>
                <select id="travellerType" class="form-control">
                    <option value="solo">혼자</option>
                    <option value="couple">커플</option>
                    <option value="family">가족</option>
                    <option value="friend">친구</option>
                </select>
            </div>
            <div class="form-group">
                <label for="travellerCount">인원</label>
                <select id="travellerCount" class="form-control">
                    <c:forEach begin="1" end="10" var="count">
                        <option value="${count}">${count}명</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <button type="submit" class="btn-submit">일정 생성하기</button>
    </form>
</div>

<script>
    // Google Places Autocomplete 초기화
    function initPlacesAutocomplete() {
        const input = document.getElementById('locationSearch');
        const autocomplete = new google.maps.places.Autocomplete(input, {
            types: ['(cities)']
        });

        autocomplete.addListener('place_changed', function() {
            const place = autocomplete.getPlace();
            if (place.geometry) {
                document.getElementById('destinationName').value = place.name;
                document.getElementById('destinationLat').value = place.geometry.location.lat();
                document.getElementById('destinationLng').value = place.geometry.location.lng();
                $('#locationError').hide();
            }
        });
    }

    $(document).ready(function() {
        // Select2 초기화
        $('#themes').select2({
            placeholder: "여행 테마를 선택하세요",
            maximumSelectionLength: 3
        });

        // Google Places Autocomplete 초기화
        initPlacesAutocomplete();

        // 시작일 최소값을 오늘로 설정
        const today = new Date().toISOString().split('T')[0];
        $('#startDate').attr('min', today);

        // 여행자 타입에 따른 인원 수 제한
        $('#travellerType').change(function() {
            const type = $(this).val();
            const countSelect = $('#travellerCount');
            countSelect.empty();

            let maxCount = 10;
            let startCount = 1;

            switch(type) {
                case 'solo':
                    maxCount = 1;
                    break;
                case 'couple':
                    startCount = 2;
                    maxCount = 2;
                    break;
                case 'family':
                case 'friend':
                    startCount = 2;
                    break;
            }

            for(let i = startCount; i <= maxCount; i++) {
                countSelect.append($('<option></option>').val(i).text(i + '명'));
            }
        }).trigger('change');

        // 폼 제출
        $('#travelPlanForm').on('submit', function(e) {
            e.preventDefault();
            let isValid = true;

            // 여행지 검증
            if (!$('#destinationLat').val() || !$('#destinationLng').val()) {
                $('#locationError').show();
                isValid = false;
            }

            // 날짜 검증
            if (!$('#startDate').val()) {
                $('#dateError').show();
                isValid = false;
            }

            // 테마 검증
            if ($('#themes').val().length === 0) {
                $('#themeError').show();
                isValid = false;
            }

            if (isValid) {
                // 시작일과 종료일 계산
                const startDate = new Date($('#startDate').val());
                const duration = parseInt($('#duration').val());
                const endDate = new Date(startDate);
                endDate.setDate(endDate.getDate() + duration - 1);

                const formData = {
                    destination: {
                        name: $('#destinationName').val(),
                        lat: parseFloat($('#destinationLat').val()),
                        lng: parseFloat($('#destinationLng').val())
                    },
                    startDate: $('#startDate').val(),
                    endDate: endDate.toISOString().split('T')[0],
                    themes: $('#themes').val(),
                    travelers: {
                        count: parseInt($('#travellerCount').val()),
                        type: $('#travellerType').val()
                    }
                };

                // AJAX 요청
                $.ajax({
                    url: '/foreign/create',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(formData),
                    success: function(response) {
                        if (response.success) {
                            window.location.href = '/foreign/plan/' + response.planId;
                        } else {
                            alert('일정 생성에 실패했습니다: ' + response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('일정 생성 중 오류가 발생했습니다.');
                    }
                });
            }
        });
    });
</script>
</body>
</html>