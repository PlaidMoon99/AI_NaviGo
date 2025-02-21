<%--
  Created by IntelliJ IDEA.
  User: yebin
  Date: 25. 2. 7.
  Time: 오전 11:25
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>

    <style>
        .container {
            margin: 10px auto;
            padding: 20px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2{
            font-weight: bold;
        }
        .my-plans-container {
            margin-top: 30px;
        }

        .my-plan-card {
            margin-bottom: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            border-radius: 10px;
        }

        .my-plan-card .card-title {
            font-size: 1.5rem;
            font-weight: bold;
            color: #007bff;
        }

        .my-plan-card .btn-primary {
            background-color: #007bff;
            border: none;
            transition: background-color 0.3s;
        }

        .my-plan-card .btn-primary:hover {
            background-color: #0056b3;
        }
    </style>
    <title>나의 여행</title>
</head>

<body>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<div class="container">
    <h2>나의 여행 일정</h2>
    </br>
<%--    <!-- 여행일정 확인 -->--%>
<%--    <form action="${pageContext.request.contextPath}/mypage/history" method="post">--%>
<%--    </form>--%>
    <div class="container my-plans-container">
        <p>왜 안나와</p>
        <%-- planList가 null 이거나 비어있으면 "비어있다" 출력 --%>
        <c:if test="${empty planList}">
            <p>여행 계획을 찾을 수 없습니다. 올바르게 로그인되어 있는지 확인하세요.</p>
            <p>디버그: memberInfo 존재? ${not empty sessionScope.memberInfo}</p>
        </c:if>

<%--        <div class="plan-list">--%>
            <c:forEach var="plan" items="${planList}">
                <div class="plan-item">
                    <p>test</p>
                    <h3>${plan.destination}</h3>
                    <p>${plan.memberId}</p>
                    <a href="/foreign/plan/${plan.planId}">상세 보기</a>
                </div>
            </c:forEach>
<%--        </div>--%>
    </div>
</div>


<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
