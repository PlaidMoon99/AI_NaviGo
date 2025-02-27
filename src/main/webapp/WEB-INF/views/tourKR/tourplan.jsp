<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Navigo AI 여행 플래너</title>

    <!-- Fonts and Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.8/dist/web/static/pretendard.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

    <style>
        :root {
            --main-blue: #1e70c9;
            --light-blue: #e8f1fa;
            --dark-blue: #0b4574;
            --white: #ffffff;
            --primary-color: #6278ff;
            --secondary-color: #a777e3;
            --light-gray: #f7f7f7;
            --border-radius: 8px;
            --box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --transition: all 0.3s ease;
        }

        body {
            font-family: 'Pretendard', 'Helvetica Neue', Helvetica, Arial, sans-serif;
            background-color: var(--light-gray);
            color: #333;
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }

        .hero {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            padding: 5rem 2rem;
            color: white;
            text-align: center;
            border-radius: 0 0 24px 24px;
            margin-bottom: 2rem;
            box-shadow: var(--box-shadow);
        }

        .hero h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .hero p {
            font-size: 1.25rem;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }

        .planner-container {
            max-width: 900px;
            margin: 0 auto 4rem auto;
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 2rem;
        }

        .section-title {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 1rem;
            border-bottom: 2px solid #eee;
            padding-bottom: 0.5rem;
        }

        .form-section {
            margin-bottom: 2rem;
        }

        .form-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 0.5rem;
        }

        .form-select, .form-control {
            border: 2px solid #eaeaea;
            border-radius: var(--border-radius);
            padding: 0.75rem;
            transition: var(--transition);
        }

        .form-select:focus, .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(98, 120, 255, 0.2);
        }

        .option-btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            margin: 0.5rem 0.5rem 0.5rem 0;
            background-color: white;
            border: 2px solid #eaeaea;
            border-radius: var(--border-radius);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
        }

        .option-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
        }

        .option-btn.selected {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .option-btn.hidden {
            display: none;
        }

        .cta-button {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            font-size: 1.1rem;
            font-weight: 600;
            padding: 1rem 2rem;
            border: none;
            border-radius: var(--border-radius);
            width: 100%;
            margin-top: 1rem;
            transition: var(--transition);
            box-shadow: 0 4px 12px rgba(98, 120, 255, 0.3);
        }

        .cta-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(98, 120, 255, 0.4);
        }

        .date-container {
            display: flex;
            gap: 1rem;
        }

        .date-container .form-group {
            flex: 1;
        }

        .gradient-divider {
            height: 3px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
            margin: 2rem 0;
            border-radius: 2px;
            border: none;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .hero {
                padding: 3rem 1rem;
            }

            .planner-container {
                padding: 1.5rem;
            }

            .date-container {
                flex-direction: column;
                gap: 0.5rem;
            }
        }
    </style>

    <script>
        let districtData = {};
        let coastalRegions = {};

        // 기본 하드코딩 데이터 (백업용)
        const defaultDistrictData = {
            "서울": ["전역"],
            "인천": ["전역"],
            "대전": ["전역"],
            "대구": ["전역"],
            "광주": ["전역"],
            "부산": ["전역"],
            "울산": ["전역"],
            "세종": ["전역"],
            "경기": ["가평군", "고양시", "과천시", "광명시", "광주시", "구리시", "군포시", "김포시", "남양주시", "동두천시", "부천시", "성남시", "수원시", "시흥시", "안산시", "안성시", "안양시", "양주시", "양평군", "여주시", "연천군", "오산시", "용인시", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시"],
            "강원": ["강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "영월군", "원주시", "인제군", "정선군", "철원군", "춘천시", "태백시", "평창군", "홍천군", "화천군", "횡성군"],
            "충북": ["괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "제천시", "진천군", "청주시", "충주시", "증평군"],
            "충남": ["공주시", "금산군", "논산시", "당진시", "보령시", "부여군", "서산시", "서천군", "아산시", "예산군", "천안시", "청양군", "태안군", "홍성군"],
            "경북": ["경산시", "경주시", "고령군", "구미시", "김천시", "문경시", "봉화군", "상주시", "성주군", "안동시", "영덕군", "영양군", "영주시", "영천시", "예천군", "울릉군", "울진군", "의성군", "청도군", "청송군", "칠곡군", "포항시"],
            "경남": ["거제시", "거창군", "고성군", "김해시", "남해군", "밀양시", "사천시", "산청군", "양산시", "의령군", "진주시", "창녕군", "창원시", "통영시", "하동군", "함안군", "함양군", "합천군"],
            "전북": ["고창군", "군산시", "김제시", "남원시", "무주군", "부안군", "순창군", "완주군", "익산시", "임실군", "장수군", "전주시", "정읍시", "진안군"],
            "전남": ["강진군", "고흥군", "곡성군", "광양시", "구례군", "나주시", "담양군", "목포시", "무안군", "보성군", "순천시", "신안군", "여수시", "영광군", "완도군", "장성군", "장흥군", "진도군", "함평군", "해남군", "화순군"],
            "제주": ["전역"]
        };

        // districtMapJson 파싱
        try {
            const rawDistrictJson = '${districtMapJson}';
            console.log("Raw district JSON from controller:", rawDistrictJson);
            if (rawDistrictJson && rawDistrictJson.trim() !== '' && rawDistrictJson !== '{}' && rawDistrictJson !== 'null') {
                const escapedDistrictJson = rawDistrictJson.replace(/\\"/g, '"').replace(/\\\\/g, '\\');
                districtData = JSON.parse(escapedDistrictJson);
                console.log("Parsed districtData from server:", districtData);
            } else {
                console.warn("No valid district JSON data received from server, falling back to default districtData");
                districtData = defaultDistrictData;
            }
        } catch (e) {
            console.error("🚨 District JSON parse error:", e);
            districtData = defaultDistrictData;
        }

        // coastalRegionsJson 파싱
        try {
            const rawCoastalJson = '${coastalRegionsJson}';
            console.log("Raw coastal JSON from controller:", rawCoastalJson);
            if (rawCoastalJson && rawCoastalJson.trim() !== '' && rawCoastalJson !== '{}' && rawCoastalJson !== 'null') {
                const escapedCoastalJson = rawCoastalJson.replace(/\\"/g, '"').replace(/\\\\/g, '\\');
                coastalRegions = JSON.parse(escapedCoastalJson);
                console.log("Parsed coastalRegions from server:", coastalRegions);
            } else {
                console.warn("No valid coastal JSON data received from server, using empty object");
                coastalRegions = {};
            }
        } catch (e) {
            console.error("🚨 Coastal JSON parse error:", e);
            coastalRegions = {};
        }

        console.log("Final districtData:", districtData);
        console.log("Final coastalRegions:", coastalRegions);
    </script>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/nav.jsp" />

<div class="hero">
    <h1>AI Navigo 여행 플래너</h1>
    <p>당신만을 위한 맞춤 여행을 AI가 추천해드립니다.</p>
</div>

<div class="planner-container">
    <form action="/generate-plan" method="post">
        <div class="form-section">
            <h3 class="section-title">여행 지역 정보</h3>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="region" class="form-label">여행 지역</label>
                    <select id="region" name="region" class="form-select">
                        <option value="">지역 선택</option>
                        <c:forEach var="reg" items="${regions}">
                            <option value="${reg}">${reg}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="district" class="form-label">시군구</label>
                    <select id="district" name="district" class="form-select">
                        <option value="">시군구 선택</option>
                    </select>
                </div>
            </div>
        </div>

        <hr class="gradient-divider">

        <div class="form-section">
            <h3 class="section-title">여행 성향</h3>
            <div class="mb-4">
                <label class="form-label">여행 테마</label>
                <div id="theme-container">
                    <c:forEach var="theme" items="${themes}">
                        <button type="button" class="option-btn theme-btn" data-value="${theme}">${theme}</button>
                    </c:forEach>
                </div>
                <input type="hidden" id="selectedThemes" name="themes" />
            </div>

            <div class="mb-3">
                <label class="form-label">동행자 유형</label>
                <div>
                    <button type="button" class="option-btn companion-btn" data-value="혼자">혼자</button>
                    <button type="button" class="option-btn companion-btn" data-value="연인">연인</button>
                    <button type="button" class="option-btn companion-btn" data-value="친구">친구</button>
                    <button type="button" class="option-btn companion-btn" data-value="가족">가족</button>
                    <button type="button" class="option-btn companion-btn" data-value="반려동물">반려동물</button>
                </div>
                <input type="hidden" id="selectedCompanion" name="companion_type" />
            </div>
        </div>

        <hr class="gradient-divider">

        <div class="form-section">
            <h3 class="section-title">여행 일정</h3>
            <div class="date-container">
                <div class="form-group mb-3">
                    <label for="start_date" class="form-label">여행 시작일</label>
                    <input type="date" id="start_date" name="start_date" class="form-control" required />
                </div>

                <div class="form-group mb-3">
                    <label for="end_date" class="form-label">여행 종료일</label>
                    <input type="date" id="end_date" name="end_date" class="form-control" required />
                </div>
            </div>
        </div>

        <button type="submit" class="cta-button">여행 일정 생성하기</button>
    </form>
</div>

<script>
    $(document).ready(function(){
        // 오늘 날짜를 기본값으로 설정
        const today = new Date();
        const tomorrow = new Date(today);
        tomorrow.setDate(today.getDate() + 1);

        const formatDate = (date) => {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return `${year}-${month}-${day}`;
        };

        $('#start_date').val(formatDate(today));
        $('#end_date').val(formatDate(tomorrow));

        // 지역 변경 시 시군구 및 테마 업데이트
        $("#region").change(function(){
            const selectedRegion = $(this).val().trim();
            console.log("Selected region:", selectedRegion);

            // 시군구 업데이트
            const districtSelect = $("#district");
            districtSelect.empty().append('<option value="">시군구 선택</option>');

            if (districtData[selectedRegion]) {
                districtData[selectedRegion].forEach(district => {
                    districtSelect.append($('<option>', {
                        value: district,
                        text: district
                    }));
                });
            } else {
                console.warn(`🚨 No districts found for region: "${selectedRegion}", using default data`);
                if (defaultDistrictData[selectedRegion]) {
                    defaultDistrictData[selectedRegion].forEach(district => {
                        districtSelect.append($('<option>', {
                            value: district,
                            text: district
                        }));
                    });
                }
            }

            // "바다" 테마 표시/숨김
            const hasSea = coastalRegions[selectedRegion] === true;
            $(".theme-btn").each(function() {
                if ($(this).data("value") === "바다") {
                    $(this).toggleClass("hidden", !hasSea);
                    if (!hasSea) {
                        $(this).removeClass("selected"); // 선택 해제
                        updateSelectedThemes();
                    }
                }
            });
        });

        // 테마 버튼 클릭 처리
        $(".theme-btn").click(function(){
            if (!$(this).hasClass("hidden")) {
                $(this).toggleClass("selected");
                updateSelectedThemes();
            }
        });

        // 선택된 테마 업데이트
        function updateSelectedThemes() {
            const selected = $(".theme-btn.selected").map(function(){
                return $(this).data("value");
            }).get();
            $("#selectedThemes").val(selected.join(","));
        }

        // 동행자 버튼 클릭 처리
        $(".companion-btn").click(function(){
            $(".companion-btn").removeClass("selected");
            $(this).addClass("selected");
            $("#selectedCompanion").val($(this).data("value"));
        });

        // 시작일 변경 시 종료일 최소값 설정
        $("#start_date").change(function(){
            const startDate = $(this).val();
            $("#end_date").attr("min", startDate);

            // 만약 종료일이 시작일보다 앞서 있다면 종료일을 시작일과 같게 설정
            if($("#end_date").val() < startDate) {
                $("#end_date").val(startDate);
            }
        });

        // 초기 지역 설정
        $("#region").trigger("change");

        // 폼 제출 전 유효성 검사
        $("form").submit(function(e){
            if(!$("#selectedCompanion").val()) {
                alert("동행자 유형을 선택해주세요.");
                e.preventDefault();
                return false;
            }

            if(!$("#selectedThemes").val()) {
                alert("최소 하나 이상의 여행 테마를 선택해주세요.");
                e.preventDefault();
                return false;
            }

            return true;
        });
    });
</script>

</body>
</html>