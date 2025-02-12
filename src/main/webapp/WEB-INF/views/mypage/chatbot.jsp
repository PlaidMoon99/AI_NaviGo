<%--
  Created by IntelliJ IDEA.
  User: yebin
  Date: 25. 2. 6.
  Time: 오후 12:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // 세션에서 로그인된 사용자 아이디 가져오기
  String userId = (String) session.getAttribute("userId");

  // 로그인된 사용자가 없으면 기본값 설정
  if (userId == null) {
    userId = "Guest";  // 기본값 (예: 'Guest' 또는 '사용자')
  }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <title>Chatbot</title>
  <style>
    .chatbot-btn {
      position: fixed;
      bottom: 20px;
      right: 20px;
      background-color: #007bff;
      color: white;
      border: none;
      width: 60px;
      height: 60px;
      border-radius: 50%;
      display: flex;
      justify-content: center;
      align-items: center;
      font-size: 24px;
      cursor: pointer;
      z-index: 1000;
    }

    .chatbot-modal {
      display: none;
      position: fixed;
      bottom: 90px;
      right: 20px;
      width: 350px;
      height: 500px;
      background-color: white;
      border: 1px solid #ccc;
      border-radius: 10px;
      box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
      z-index: 999;
      flex-direction: column;
      overflow: hidden;
    }

    .chatbot-modal.show {
      display: flex;
    }

    .modal-content {
      flex: 1.2;
      overflow-y: auto;
      padding: 15px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    /* 메시지 컨테이너 스타일 수정 */
    .message {
      display: flex;
      flex-direction: column;
      gap: 16px;
      flex-grow: 1; /* 부모 컨테이너 내에서 가변 크기 */
    }

    /* 메시지 공통 스타일 */
    .message-bubble {
      max-width: 70%;
      padding: 12px 16px;
      border-radius: 20px;
      word-wrap: break-word;
      line-height: 1.4;  /* 줄간격 추가 */
      margin: 4px 4px;  /* 상하 여백 추가 */
    }

    /* 사용자 메시지 스타일 */
    .user-message {
      align-self: flex-end;
      background-color: #007bff;
      color: white;
      border-radius: 10px;
      padding: 5px 6px;
      font-size: 14px;
    }

    /* AI 메시지 스타일 */
    .ai-message {
      align-self: flex-start;
      background-color: #f1f1f1;
      color: black;
      border-radius: 10px;
      padding: 5px 6px;
      font-size: 14px;
    }

    .modal-input {
      position: sticky;
      bottom: 0;
      width: 100%;
      background-color: #f8f9fa;
      padding: 15px;
      border-top: 1px solid #dee2e6;
      box-sizing: border-box;
      display: flex;
      gap: 10px;
    }

    .modal-input input {
      flex: 1;
      padding: 10px;
      border: 1px solid #ced4da;
      border-radius: 20px;
      font-size: 14px;
      outline: none;
    }

    .modal-input input:focus {
      border-color: #007bff;
    }

    .modal-input button {
      background-color: #007bff;
      color: white;
      border: none;
      padding: 8px 20px;
      border-radius: 20px;
      cursor: pointer;
      font-size: 14px;
      transition: background-color 0.2s;
    }

    .modal-input button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
</html>
<body>



<button class="chatbot-btn" onclick="toggleModal()">💬</button>

<div class="chatbot-modal" id="chatbotModal">
  <div class="modal-content">
    <div class="message" id="chatbotMessages"></div>
  </div>
  <div class="modal-input">
    <input type="text" id="chatInput" placeholder="메시지를 입력하세요"/>
    <button id="sendButton">전송</button>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
<script>
  // 모달 토글 함수
  function toggleModal() {
    const modal = document.getElementById('chatbotModal');
    modal.classList.toggle('show');
    // 모달을 열 때 첫 번째 메시지를 자동으로 전송
    if (modal.classList.contains('show')) {
      sendAutoMessage();
    }
  }

  // 엔터 키 이벤트 처리
  function handleKeyPress(event) {
    if (event.key === 'Enter') {
      sendMessage();
    }
  }
  // JSP에서 받은 userId 값을 JavaScript 변수에 저장
  var userId = "<%= userId %>";

  // AI 첫 번째 자동 메시지 출력
  function sendAutoMessage() {
    const chatbotMessages = document.getElementById("chatbotMessages");

    // AI 첫 번째 자동 메시지 추가
    const aiMessage = document.createElement("div");
    aiMessage.className = "ai-message";
    aiMessage.innerHTML = "안녕하세요! <strong>" + userId + "</strong>님! 😊<br>" +
            "저는 여행을 더 편리하게 즐길 수 있도록 도와주는 AI 챗봇입니다.<br> " +
            "일정 관리부터 장소 추천까지 여행의 작은 고민들을 해결해 드릴게요. 궁금한 점이 있으면 언제든지 편하게 물어봐 주세요!";
    chatbotMessages.appendChild(aiMessage);

    // 스크롤 최하단으로 이동
    chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
  }

  // ✅ 초기화 함수
  function initializeChatbot() {
    console.log("✅ 초기화 시작");

    const input = document.getElementById("chatInput");
    const sendButton = document.getElementById("sendButton");

    if (!input || !sendButton) {
      console.error("❌ 필수 요소를 찾을 수 없습니다.");
      return;
    }

    // ✅ 이벤트 리스너 등록
    input.addEventListener('keypress', handleKeyPress);
    sendButton.addEventListener('click', sendMessage);

    console.log("✅ 이벤트 리스너 등록 완료");
  }

  // 💬 메시지 전송 함수
  function sendMessage() {
    console.log("sendMessage() 함수 실행됨");

    const input = document.getElementById("chatInput");
    const message = input.value.trim();

    console.log("입력된 메시지:", message);

    if (!message) {
      console.log("❌ 빈 메시지");
      return;
    }

    const chatbotMessages = document.getElementById("chatbotMessages");

    // 👩 사용자 메시지 추가
    const userMessage = document.createElement("div");
    userMessage.className = "user-message";
    userMessage.textContent = message;
    chatbotMessages.appendChild(userMessage);

    // 입력창 초기화
    input.value = "";

    // API 호출
    fetch("http://127.0.0.1:8501/", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ message: message })
    })
            .then(response => response.json())
            .then(data => {
              console.log("📩 서버 응답:", data);

              if (!data || !data.response) {
                throw new Error("서버 응답 데이터 오류");
              }

              // AI 응답 메시지 추가
              const aiMessage = document.createElement("div");
              aiMessage.className = "ai-message";

              // 서버 응답을 Markdown에서 HTML로 변환
              aiMessage.innerHTML = marked.parse(data.response);  // marked()로 변환된 HTML 삽입
              chatbotMessages.appendChild(aiMessage);

              // 스크롤 최하단으로 이동
              chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
            })
            .catch(error => {
              console.error("❌ Error:", error);
            });
    // 스크롤 최하단으로 이동
    chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
  }

  // 페이지 로드 시 초기화
  window.addEventListener('load', initializeChatbot);
</script>

</body>
</html>