---
title: Google Login API 연동하기(Web Service)
categories: [Etc]
tags: [google, login api]
---



* 2021.01.18 기준 작동 확인됨.

# 1. 구글 API Console 접속

- 라이브러리에 접속하여 Google+ API 사용 클릭.

![e1](/assets/img/Etc/e1.png)

# 2. 사용자 인증 정보 만들기

- 사용자 인증 정보 탭에서 상단의 '사용자 인증 정보 만들기' 클릭 후, OAuth Client ID 클릭.

![e2](/assets/img/Etc/e2.png)

- 유형에 웹 애플리케이션 선택 후, Local 에서 테스트를 위해, localhost 주소 입력

![e3](/assets/img/Etc/e3.png)

- 하단의 만들기 버튼을 클릭하면 다음과 같은 정보가 뜸.

![e4](/assets/img/Etc/e4.png)

여기서, 클라이언트 ID 를 복사해놓는다.

# 3. 서비스에 로그인 버튼 추가 및 작업

- 소스 헤더에 라이브러리 추가.

```html
<script src="https://apis.google.com/js/platform.js" async defer></script>
<meta
  name="google-signin-client_id"
  content="클라이언트ID.apps.googleusercontent.com"
/>
```

- 로그인 버튼 추가.

```html
<div class="g-signin2" data-onsuccess="onSignIn"></div>
```

- 로그인 후, 정보 가져오는 스크립트 추가.

```js
function onSignIn(googleUser) {
  var profile = googleUser.getBasicProfile();
  console.log("ID: " + profile.getId()); // Do not send to your backend! Use an ID token instead.
  console.log("Name: " + profile.getName());
  console.log("Image URL: " + profile.getImageUrl());
  console.log("Email: " + profile.getEmail()); // This is null if the 'email' scope is not present.
}
```

- 이후, 이 스크립트를 사용하여 서버-사이드로 넘겨서 처리하거나 기타 등등 원하는 작업을 연동한다.

- 로그아웃 버튼 추가, 해당 버튼을 클릭하면 연동이 해제된다.

```html
<a href="#" onclick="signOut();">Sign out</a>
<script>
  function signOut() {
    var auth2 = gapi.auth2.getAuthInstance();
    auth2.signOut().then(function () {
      console.log("User signed out.");
    });
  }
</script>
```

정보를 가져오고, 로그아웃 하는 부분은 구글에서 하는 것이고,

서비스에서 실제 로그인, 회원가입 등등의 구현은 직접해야 한다.

연동이 매우 쉬운편이라 쉽게 따라할 수 있었다.
