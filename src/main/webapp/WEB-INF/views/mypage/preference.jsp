<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nevigo.ai_navigo.dto.PreferenceDTO" %>

<html>
<head>
    <title>선호 여행 취향 수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>

    <style>
        .alert {
            display: none;
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1000;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .container {
            margin: 40px auto;
            padding: 20px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .card {
            cursor: pointer;
            text-align: center;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }
        .card:hover {
            transform: scale(1.05);
        }
        .card-title {
            font-size: 1.2rem;
            font-weight: bold;
        }
        .card-text {
            font-size: 1rem;
            color: #666;
        }
        .card.selected-card {
            background-color: #007bff; /* 진한 파란색 */
            color: #fff; /* 텍스트 색상 흰색으로 변경 */
        }
        .selected-card .card-text {
            background-color: #007bff; /* 진한 파란색 **/
            color: #fff; /* 카드 텍스트 색상 흰색으로 변경 */
        }

    </style>
</head>
<body>
<div class="container">
    <h2>선호 여행 취향 수정</h2>

    <!-- 저장된 카테고리를 확인 -->
    <p>저장된 선호 여행 취향: ${savedCategory}</p>

    <!-- 저장 성공 popup -->
    <div id="saveAlert" class="alert" style="display: none; position: fixed; top: 20px; right: 20px; z-index: 1000;"></div>

    <div class="row">
        <script>
            // 선택된 선호도가 있다면 해당 값을 저장
            var selectedPreference = "${selectedCategory != null ? selectedCategory : ''}";

            // 카테고리 선택 함수
            function selectCategory(category, cardElement) {
                // 선택된 카테고리와 비교하여 선택된 카드에 스타일 적용
                if (selectedPreference === category) {
                    cardElement.classList.add('selected-card');
                } else {
                    cardElement.classList.remove('selected-card');
                }
            }
        </script>

        <!-- 여행 분야 카드 -->
        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('산', this)">
                <div class="card-body">
                    <h5 class="card-title">산</h5>
                    <p class="card-text">자연 속에서의 여행을 원하시면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('해안 절경', this)">
                <div class="card-body">
                    <h5 class="card-title">해안 절경</h5>
                    <p class="card-text">바다와 해안의 아름다움을 경험하고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('온천/욕장/스파', this)">
                <div class="card-body">
                    <h5 class="card-title">온천/욕장/스파</h5>
                    <p class="card-text">몸과 마음을 힐링할 수 있는 온천 및 스파 여행을 원하시면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('카페/전통찻집', this)">
                <div class="card-body">
                    <h5 class="card-title">카페/전통찻집</h5>
                    <p class="card-text">아늑한 분위기에서 커피와 차를 즐기고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('복합 레포츠', this)">
                <div class="card-body">
                    <h5 class="card-title">복합 레포츠</h5>
                    <p class="card-text">다양한 레포츠를 한 번에 즐기고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('야영장,오토캠핑장', this)">
                <div class="card-body">
                    <h5 class="card-title">야영장,오토캠핑장</h5>
                    <p class="card-text">자연 속에서 캠핑과 야영을 즐기고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('문화관광축제', this)">
                <div class="card-body">
                    <h5 class="card-title">문화관광축제</h5>
                    <p class="card-text">다채로운 문화와 축제의 분위기를 경험하고 싶다면 선택하세요.</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-3 mb-4">
            <div class="card" onclick="selectCategory('박물관', this)">
                <div class="card-body">
                    <h5 class="card-title">박물관</h5>
                    <p class="card-text">역사와 문화, 예술을 감상하고 싶다면 이 카드를 선택하세요.</p>
                </div>
            </div>
        </div>

    </div>

    <!-- 저장 버튼 -->
    <div class="d-flex justify-content-between mt-4">
        <button type="button" class="btn btn-secondary" onclick="window.history.back()">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="selectCategory()">Save</button>
    </div>
</div>

<!-- JavaScript -->
<script>
    // 서버에서 전달된 과거 저장된 값
    var savedCategory = "${savedCategory != null ? savedCategory : ''}";
    console.log("Saved Category (from DB):", savedCategory);

    // DOMContentLoaded 이벤트를 사용해 초기 렌더링 시 반영
    document.addEventListener("DOMContentLoaded", () => {
        if (savedCategory) {
            const cards = document.querySelectorAll('.card');
            cards.forEach(card => {
                const cardTitle = card.querySelector('.card-title').textContent.trim();
                if (cardTitle === savedCategory) {
                    card.classList.add('selected-card');
                }
            });
        }
    });

    function selectCategory(category, cardElement) {
        // 이전 선택 해제
        const previousSelected = document.querySelector('.selected-card');
        if (previousSelected) {
            previousSelected.classList.remove('selected-card');
        }

        // 현재 선택 적용
        cardElement.classList.add('selected-card');

        //update db에 저장하는 script
        // 선택한 값을 서버로 전달
        fetch('/mypage/updatePreference', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ selectedCategory: category }),
        })
            .then(response => {
                if (response.ok) {
                    console.log("Preference updated successfully!");

                    // 저장된 카테고리를 업데이트
                    savedCategory = category;

                    // 성공 팝업 표시
                    showPopup("성공적으로 저장되었습니다!", "success");
                } else {
                    console.error("Failed to update preference.");
                }
            })
            .catch(error => {
            console.error("Error during preference update:", error);
        });
    }
    // 팝업 메시지 표시 함수
    function showPopup(message, type) {
        const alertDiv = document.getElementById('saveAlert');
        alertDiv.textContent = message;
        alertDiv.className = `alert alert-${type}`;
        alertDiv.style.display = 'block';

        // 3초 후 자동으로 팝업 숨김
        setTimeout(() => {
            alertDiv.style.display = 'none';
        }, 3000);
    }


</script>


<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
