<%--
  Created by IntelliJ IDEA.
  User: Moon yebin
  Date: 25. 2. 4.
  Time: 오후 2:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>updateForm</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/style.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
  <style>
    .container {
      max-width: 500px;
      margin: 40px auto;
      padding: 20px;
      background: #fff;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .form-label {
      font-weight: bold;
    }
    .form-group {
      margin-bottom: 15px;
    }
  </style>
</head>

<body>

<div class="update-container">
  <h2>회원 정보 수정</h2>
  <form action="❤❤❤❤❤❤❤" method="post">
    <div class="form-group">
      <label for="member_name" class="form-label">이름</label>
      <input type="text" class="form-control" id="member_name" name="memberName" required>
    </div>
    <div class="form-group">
      <label for="member_id" class="form-label">아이디</label>
      <div class="input-group">
        <input type="text" class="form-control" id="member_id" name="memberId" required>
        <input type="hidden" id="hidden_member_id" name="memberId">
        <button type="button" class="btn btn-secondary" id="checkIdBtn">중복 확인</button>
      </div>
    </div>
    <div class="form-group">
      <label for="member_pw" class="form-label">비밀번호</label>
      <input type="password" class="form-control" id="member_pw" name="memberPw" required>
    </div>
    <div class="form-group">
      <label class="form-label">성별</label>
      <select class="form-control" name="memberGender">
        <option value="M">남성</option>
        <option value="F">여성</option>
      </select>
    </div>
    <div class="d-flex justify-content-between mt-4">
      <button type="button" class="btn btn-secondary" onclick="window.history.back()">Cancel</button>
      <button type="submit" class="btn btn-primary">Save</button>
    </div>
  </form>
</div>






<!-- Bootstrap JS (Popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>