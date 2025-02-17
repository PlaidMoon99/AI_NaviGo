<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- nav.jsp -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color: #e8f1fa;">
    <div class="container-fluid">
        <!-- 로고 포함 -->
        <jsp:include page="/WEB-INF/views/layout/header.jsp" />

        <!-- 토글 버튼 (햄버거 메뉴) -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar"
                aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- 실제 메뉴 -->
        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="/imageRecommendation">이미지</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/main/recommended">추천 여행지</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">국내 여행지 생성</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/foreign/create">해외 여행지 생성</a>
                </li>


            <%-- session에 memberInfo가 있으면 마이 페이지와 Logout 버튼 표시 --%>
                <% if (session.getAttribute("memberInfo") != null) { %>
                <li class="nav-item">
                    <a class="nav-link" href="/mypage">마이 페이지</a>
                </li>
                <li class="nav-item">
                    <form action="/logout" method="post">
                        <button class="btn btn-primary ms-2" data-bs-toggle="modal" type="submit">Logout</button>
                    </form>
                </li>
                <% } else { %>
                <%-- session에 memberInfo가 없으면 Sign In 버튼만 표시 --%>
                <li class="nav-item">
                    <button class="btn btn-primary ms-2" data-bs-toggle="modal" data-bs-target="#signInModal">Sign In</button>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
    <!-- Sign In 모달 -->
    <div class="modal fade" id="signInModal" tabindex="-1" aria-labelledby="signInModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="signInModalLabel">Sign In</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="/auth/sign_in" method="post" id="login-form">
                        <div class="mb-3">
                            <label for="id" class="form-label">ID</label>
                            <input type="text" class="form-control" id="id" name="memberId" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="memberPw" required>
                        </div>
                        <button type="button" id="login-btn" class="btn btn-primary w-100">Login</button>
                    </form>

                    <!-- 구분선 -->
                    <div class="text-center custom-divider">or</div>

                    <!-- 구글 로그인 버튼 -->
                    <button class="btn google-btn w-100">
                        <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google Logo" style="width: 20px; margin-right: 10px;"> Google Login
                    </button>

                    <!-- 구분선 -->
                    <hr class="sign-up-divider">

                    <!-- 회원가입 버튼 -->
                    <form action="/signUp" method="get">
                        <button class="btn btn-secondary w-100" type="submit">Sign Up</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</nav>

<!-- javascript -->
<script>
    $(document).ready(function() {
        $("#login-btn").click(function() { // "Login" 버튼 클릭 시 실행
            let userId = $("#id"); // 입력된 ID 값 가져오기
            let userPw = $("#password"); // 입력된 PW 값 가져오기

            if (userId.val().trim() === "") {
                alert("아이디를 입력해주세요.");
                return;
            } else if(userPw.val().trim() === ""){
                alert("비밀번호를 입력해주세요.");
                return;
            }
            $.ajax({
                type: "POST",
                url: "/isLogin",
                data: {
                    [userId.attr("name")]: userId.val(),
                    [userPw.attr("name")]: userPw.val()
                },
                success: function(response) {
                    if (response === 'ok') {
                        const form = $('#login-form');
                        form.submit();
                    } else if(response === '존재하지 않는 계정입니다.'){
                        userId.val('');
                        alert(response);
                    } else{
                        userPw.val('');
                        alert(response);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("AJAX 오류:", error);
                }
            });
        });
    });
</script>