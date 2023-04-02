---
title: 구글 로그인 API 연동 시, 에러 발생 및 해결(Web Service)
categories: [Etc, Error]
tags: [Error, Google Login Api]
---


다음 내용은 구글 로그인 API 를 연동하면서 발생했던 문제점 및 해결 방법을 복기한 내용입니다.

기존 연동 글 : lucete-stellae.tistory.com/5?category=905216

### 1. 로그인과 회원가입 분리 상황에서의 구글 로그인 버튼

위 글과 구글 API 문서에서 제공하는 예제를 구성하는 경우, 한 페이지에 로그인 버튼 및 로그아웃 버튼이 동시에 존재하게 됩니다.

이 경우의 예제를 실습하기에는 좋지만, 이는 평균적인 홈페이지 로그인 및 회원가입에서 SNS 연동하는 경우에는 부적합하다고 볼 수 있습니다.

따라서, 제가 연동 예제 실습 후 실제 연동하는 과정에서 구글로 로그인하는 부분과 회원가입하는 부분 2개의 구글 로그인 연동 버튼이 필요했습니다.

- 로그인 : 구글 로그인 호출 -> 로그인 정보 및 서비스 내 회원정보 비교 -> 정보 존재 시, 로그인 아닌 경우 비로그인.
- 회원가입 : 구글 로그인 호출 -> 로그인 정보에서 구글 유저 정보를 가져와 자식창에 세팅 -> 서비스 회원가입 진행.

위 프로세스를 구성하는 데에 있어서 한번 로그인을 호출 하면, 로그인이 된 것으로 판단되어

```js
function signOut() {
  var auth2 = gapi.auth2.getAuthInstance();
  auth2.signOut().then(function () {
    console.log("User signed out.");
  });
}
```

위 로그 아웃을 호출하기 전 까지는 자동으로 로그인 되는 문제가 있었습니다.

이 문제를 찾아본 결과,

```js
function onSignIn(googleUser) {
  var profile = googleUser.getBasicProfile();
  console.log("ID: " + profile.getId()); // Do not send to your backend! Use an ID token instead.
  console.log("Name: " + profile.getName());
  console.log("Image URL: " + profile.getImageUrl());
  console.log("Email: " + profile.getEmail()); // This is null if the 'email' scope is not present.
}
<div class="g-signin2" data-onsuccess="onSignIn"></div>;
```

이런 식으로, div 태그 안에 버튼이 생성되게 되는데, data-onsuccess 에 onSignIn 이 매핑되어 있어, 버튼이 렌더링 되고 나서, 버튼을 한번이라도 클릭하고 로그아웃을 하지 않는 경우, 다시 접속해도 해당 함수를 무조건 실행되게끔 되어있었습니다.

따라서 다음과 같이, 로그인 상황에서는 로그인 폼에 태우고, 로그아웃을 시켰습니다.

```js
function onSuccess(googleUser) {
  console.log(googleUser);
  var profile = googleUser.getBasicProfile();
  signOut();
  var $form = $("#snsLoginForm");
  $form.find("input[name='id']").val(profile.getEmail());
  $form.find("input[name='snsType']").val("google");
  $form.attr("action", "/comm/member/googleLogin.do");
  $form.submit();
}
```

회원 가입 상황에서도 필요한 부분을 실행 후, 로그아웃을 시킵니다.

```js
function onSuccess(googleUser) {
  var profile = googleUser.getBasicProfile();
  // 구글 가입 버튼 클릭 시, 가입정보 체크
  $.ajax({
    url: "/comm/member/snsSignChk.do",
    dataType: "json",
    data: {
      id: profile.getEmail(),
      password: profile.getEmail(),
      snsType: "google",
    },
    success: function (data) {
      console.log(data);
      if (data.result > 0) {
        $.alert2("이미 가입된 계정입니다.", {
          close: function () {
            signOut();
          },
        });
        signOut();
        return false;
      } else {
        $("#removeSection1").remove();
        $("#removeSection2").remove();
        $("#removeSection3").remove();
        var $form = document.signupForm;
        $form.snsLoginYn.value = "Y";
        $form.email.value = profile.getEmail();
        $form.snsType.value = "google";
        $("#snsLoginId").val(profile.getEmail());
        $("#snsLoginPw").val(profile.getEmail());
        signOut();
      }
    },
  });
}
```

이렇게 되면 중복 호출 문제 뿐만 아니라 로그인 후, 로그아웃도 서비스에서만 로그아웃 시키면 끝나게 됩니다.

### 2. gapi Cannot read Property 'style' of null

제일 삽질 많이한 문제로써 버튼을 2개이상 만드니 동작을 아예 안하는 문제가 생겼습니다.

여기서 기본적으로 깔고가야할 내용은 구글 로그인 연동 버튼에 적용되는 버튼 렌더링명이 겹치면 안된다는 것입니다.

관련한 내용으로는 다음을 참고했습니다.

[github.com/google/google-api-javascript-client/issues/281](github.com/google/google-api-javascript-client/issues/281)

기본으로 제공되는 `<div class="g-signin2" data-onsuccess="onSignIn"></div>` 만 사용하는 경우,
<br/> 하나만 사용해야 하는데 동일한 클래스명을 갖는 버튼을 하나 더 추가하는 경우 먹통이 됩니다.

따라서, 해당 버튼들을 커스텀 렌더링을 해야합니다.

커스텀 렌더링은 구글 문서의 다음을 참고해주세요.

[developers.google.com/identity/sign-in/web/build-button](developers.google.com/identity/sign-in/web/build-button)

아래는 제가 사용한 코드입니다.

##### 로그인 페이지 html

```js
<script src="https://apis.google.com/js/platform.js?onload=renderButtonLogin" async defer></script>
<meta name="google-signin-client_id" content="380583811608-sqj8rb44q1sd2vfac8sq75bp7af966pt.apps.googleusercontent.com">

<script type="text/javascript">
	function onSuccess ( googleUser ) {
		console.log( googleUser );
		var profile = googleUser.getBasicProfile();
		signOut();
		var $form = $( "#snsLoginForm" );
		$form.find( "input[name='id']" ).val( profile.getEmail() );
		$form.find( "input[name='snsType']" ).val( "google" );
		$form.attr( "action" ,"/comm/member/googleLogin.do" );
		$form.submit();
	}
	function onFailure ( error ) {
		console.log( error );
	}
	function renderButtonLogin () {
		gapi.signin2.render( 'my-signin1' ,{
			'scope' : 'profile email' ,
			'width' : 100 ,
			'height' : 50 ,
			'longtitle' : true ,
			'theme' : 'dark' ,
			'onsuccess' : onSuccess ,
			'onfailure' : onFailure
		} );
	}
	function signOut () {
		var auth2 = gapi.auth2.getAuthInstance();
		auth2.signOut().then( function () {
			console.log( 'User signed out.' );
		} );
	};
</script>


<!-- 로그인 버튼 -->
<div id="my-signin1"></div>
<!-- 로그인 버튼 -->
```

##### 회원가입 페이지 html

```js
<script src="https://apis.google.com/js/platform.js?onload=renderButton" async defer></script>
<meta name="google-signin-client_id" content="380583811608-sqj8rb44q1sd2vfac8sq75bp7af966pt.apps.googleusercontent.com">

<script type="text/javascript">
function onSuccess ( googleUser ) {
			var profile = googleUser.getBasicProfile();
			// 구글 가입 버튼 클릭 시, 가입정보 체크
			$.ajax( {
				"url" : "/comm/member/snsSignChk.do" ,
				"dataType" : "json" ,
				"data" : {
					"id" : profile.getEmail() ,
					"password" : profile.getEmail() ,
					"snsType" : "google"
				} ,
				"success" : function ( data ) {
					console.log( data );
					if ( data.result > 0 ) {
						$.alert2( "이미 가입된 계정입니다." ,{
							"close" : function () {
								signOut();
							}
						} );
						signOut();
						return false;
					} else {
						$( "#removeSection1" ).remove();
						$( "#removeSection2" ).remove();
						$( "#removeSection3" ).remove();
						var $form = document.signupForm;
						$form.snsLoginYn.value = "Y";
						$form.email.value = profile.getEmail();
						$form.snsType.value = "google";
						$( "#snsLoginId" ).val( profile.getEmail() );
						$( "#snsLoginPw" ).val( profile.getEmail() );
						signOut();
					}
				}
			} );
		}
		function onFailure ( error ) {
			console.log( error );
		}
		function renderButton () {
			gapi.signin2.render( 'my-signin2' ,{
				'scope' : 'profile email' ,
				'width' : 100 ,
				'height' : 50 ,
				'longtitle' : true ,
				'theme' : 'dark' ,
				'onsuccess' : onSuccess ,
				'onfailure' : onFailure
			} );
		}
</script>

<!-- 회원가입 버튼 -->
<div id="my-signin2"></div>
<!-- 회원가입 버튼 -->


```
