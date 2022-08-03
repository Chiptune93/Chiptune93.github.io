---
layout: post
title: Axios - Vuejs / React 환경에서 axios 모듈 get/post 통신 에러
description: >
    [Axios] Vuejs / React 환경에서 axios 모듈 get/post 통신 에러
sitemap: false
hide_last_modified: true
categories: [Error]
tags: [vuejs, react, axios, axios error]
---

- Table of Contents
{:toc .large-only}

## 1. 프로젝트 환경
- html 베이스로 프론트에서 Vuejs 사용 중

- Vuejs 버전 2.6.14

- axios 라이브러리 버전 0.26.1

## 2. 문제 상황
- axios 를 이용하여 ajax 통신을 backend 와 진행.
```js
comm.post({
    context: 'common_web',
    url: "/push/token/save",
    params: {
        pushToken: token,
        mobileOs: comm.mobile.os
    }
}, function (data) {});
```

위 코드는 /common_web/push/token/save URL 로 POST 요청을 보내는 ajax 정의 함수이다.

해당 통신을 실행하였을 때, Response 내용이 아예 없는 상황이 발생한다.

특징으로는 Response 에 담겨오는 내용 자체가 없으며

axios 라이브러리 response 상황에서는 'Network Error' 라고만 나온다.

해당 문제가 발생되는 특정 지점은 발견하기 힘드며, 해당 URL의 Response 또한

200 OK 를 무조건 리턴하는 URL 임에도 불구하고 Network Error 가 "IOS 앱(웹뷰사용)" 상황에서만 발생한다.

## 3. 문제 해결 시도
Google 에 검색 시, 아래와 같이 검색했다.

[검색 링크](https://www.google.com/search?q=ios+axios+network+error&amp;sxsrf=APq-WBt-D8cszOHOYhKcgIny6VLfDaNitA%3A1648191976365&amp;ei=6Gk9YqLtFdqQ1e8PvZybgA8&amp;ved=0ahUKEwiigZfK2eD2AhVaSPUHHT3OBvAQ4dUDCA4&amp;uact=5&amp;oq=ios+axios+network+error&amp;gs_lcp=Cgdnd3Mtd2l6EAMyBQgAEMsBMgYIABAFEB46BwgAEEcQsANKBAhBGABKBAhGGABQighY-AlgkgtoAXABeACAAXmIAbgDkgEDMC40mAEAoAEByAEKwAEB&amp;sclient=gws-wiz)

문제를 찾아본 결과, axios 라이브러리 쪽에서도 사람들이 지속적으로 문제 제기만 할 뿐, 이렇다 할 해결책이 없으며

IOS12 부터 지속적으로 발생한 문제임을 파악할 수 있다.

해당 검색 결과 내에서 결국 해결책으로는 완벽하진 않지만

axios 모듈 대신 문제가 있는 ajax 통신을 다른 라이브러리를 사용하거나, 직접 구현할 것을 권고 했다.



## 4. 해결
```js
var xhr = new XMLHttpRequest();
xhr.open('POST', url, true);
xhr.setRequestHeader('Content-type', 'application/json');
xhr.send(JSON.stringify(params));
xhr.onload = function () {
    // do something to response
    console.log("setPushToken result : " + this.responseText);
};
```




위와 같이 해당 URL로 POST 요청을 Xhr Request 로 보내는 함수를 만들어 사용하였다.

최초 언급한 문제는 해결 되었다.

만약 프로젝트에서 IOS 모바일 환경을 지원하도록 하는 프로젝트가 있고

프론트에서 axios 모듈을 사용한다면, 위 사항은 충분히 고려해주어야 한다.

방법은 여러가지가 있겠지만 아래 방법 정도가 우선 파악된 해결 방법이다.


1. ios 일때만 구분을 주어, 문제가 생기는 구간에 위 처럼 새로 정의하여 통신한다.
2. 공통 ajax 통신 구간 함수를 잡을 때, axios 라이브러리 대신 다른 것을 사용한다.






