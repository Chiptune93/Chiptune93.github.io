---
title: IOS - invalid Date 관련 문제
categories: [Frontend, Scripts]
tags: [ios, invalid date, ios date]
---

최근 IOS 모바일 앱 WebView 상황에서 invalid Date 문제를 겪게 되었다.

증상은, 날짜 객체가 표현이 되지 않는 현상이며, format을 변환하거나 date 계산을 하는 과정에서 해당 현상이 발생되었다. 우선적으로, IOS에서는 ISO8601 형식을 따라야만 표현이 가능하다.

https://ko.wikipedia.org/wiki/ISO_8601

따라서, 기존 애플리케이션에서 문자열 형식으로 사용하던 Date 객체들을 전부 해당 형식으로 바꾸어주어야 했다.

검색해보면 moment 라이브러리를 사용하는 방법을 추천하고 있지만, 2022년 3월 기준 해당 방법은 소용없었다. (모바일 IOS 15버전 이상 기준)

- moment 사용 (실패)

```js
moment(new Date()).format("YYYY.MM.DD");
```

우선, IOS에서 동작하는 객체 형태를 확인한 결과, 날짜 형식 지정 및 계산을 하기 위해서는 항상 객체가 javascript date 객체여야 했다. 따라서, date 객체를 표현하거나 계산할 때는 항상 new Date 로 선언해주어야 했다.

- IOS 내에서 사용 가능한 형태

```js
new Date()
new Date(year, month, date, hour, minute, second);
...
```

이런 식이다 보니 결국 공통으로 문자열 패턴을 파라미터로 받아 date 객체로 리턴해주는 함수가 필요했다. 또한, 애플리케이션에서는 UTC 기준시로 변경해주어야 하는 부분이 있어 이 또한 적용하여 함수를 짰다.

- 문자열을 받아 javascript date 객체를 리턴하는 함수

```js
initDate: function (date) {
    // 패턴으로 정의되는 시간 및 날짜 데이터를 받아 Javascript Date Utc 객체로 내보낸다.
    var pattern1 = /^(19[0-9]{2}|2[0-9]{3}).(0[1-9]|1[012]).([123]0|[012][1-9]|31) ([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/; // yyyy.mm.dd hh:mm:ss
    var pattern2 = /^(19[0-9]{2}|2[0-9]{3}).(0[1-9]|1[012]).([123]0|[012][1-9]|31)$/; // yyyy.mm.dd
    var pattern3 = /^(0[0-9]|1[0-9]|2[0-3])(:[0-5]\d)(:[0-5]\d)$/; // HH:MM:SS
    var pattern4 = /^([0-5]\d)(:[0-5]\d)$/; // HH:MM
    var pattern5 = /^(19[0-9]{2}|2[0-9]{3})-(0[1-9]|1[012])-([123]0|[012][1-9]|31)$/; // yyyy-mm-dd
    var pattern5_ = /^(19[0-9]{2}|2[0-9]{3})-([1-9])-([1-9]|[123]0|[012][1-9]|31)$/; // yyyy-m-d
    var pattern5__ = /^(19[0-9]{2}|2[0-9]{3})-([1-9])-([123]0|[012][1-9]|31)$/; // yyyy-m-dd
    var pattern5___ = /^(19[0-9]{2}|2[0-9]{3})-(0[1-9]|1[012])-([1-9])$/; // yyyy-mm-d
    var pattern6 = /^(19[0-9]{2}|2[0-9]{3}).(0[1-9]|1[012])$/; // yyyy.mm
    var pattern7 = /^(19[0-9]{2}|2[0-9]{3})-(0[1-9]|1[012])-([123]0|[012][1-9]|31)T([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9].[0-9][0-9][0-9]Z)$/; // IOS yyyy-mm-ddThh:mm:ss.000Z
    var y, m, d, h, mm, s;

    if (date == null || date == "" || date == "undefined") return null;

    if (date.match(pattern1)) {
      //console.log("* init Date pattern 1 *");
      y = date.substring(0, 4);
      m = date.substring(5, 7);
      d = date.substring(8, 10);
      h = date.substring(11, 13);
      mm = date.substring(14, 16);
      s = date.substring(17, 19);
      return new Date(Date.UTC(y, m - 1, d, h, mm, s));
    } else if (date.match(pattern2)) {
      //console.log("* init Date pattern 2 *");
      y = date.substring(0, 4);
      m = date.substring(5, 7);
      d = date.substring(8, 10);
      h = 0;
      mm = 0;
      s = 0;
      return new Date(Date.UTC(y, m - 1, d, h, mm, s));
    } else if (date.match(pattern3)) {
      //console.log("* init Date pattern 3 *");
      var today = new Date();
      y = today.getFullYear();
      m = today.getMonth();
      d = today.getDate();
      h = date.substring(0, 2);
      mm = date.substring(3, 5);
      s = date.substring(6, 8);
      return new Date(Date.UTC(y, m, d, h, mm, s));
    } else if (date.match(pattern4)) {
      //console.log("* init Date pattern 4 *");
      var today = new Date();
      y = today.getFullYear();
      m = today.getMonth();
      d = today.getDate();
      h = date.substring(0, 2);
      mm = date.substring(3, 5);
      s = 0;
      return new Date(Date.UTC(y, m, d, h, mm, s));
    } else if (date.match(pattern5)) {
      //console.log("* init Date pattern 5 *");
      var today = new Date();
      y = date.substring(0, 4);
      m = date.substring(5, 7);
      d = date.substring(8, 10);
      h = 0;
      mm = 0;
      s = 0;
      return new Date(Date.UTC(y, m, d, h, mm, s));
    } else if (date.match(pattern5_)) {
      //console.log("* init Date pattern 5_ *");
      var today = new Date();
      y = date.substring(0, 4);
      m = date.substring(5, 6);
      d = date.substring(7, 8);
      h = 0;
      mm = 0;
      s = 0;
      console.log(y, m, d, h, mm, s);
      return new Date(Date.UTC(y, m, d, h, mm, s));
    } else if (date.match(pattern5__)) {
      //console.log("* init Date pattern 5__ *");
      var today = new Date();
      y = date.substring(0, 4);
      m = date.substring(5, 6);
      d = date.substring(7, 9);
      h = 0;
      mm = 0;
      s = 0;
      return new Date(Date.UTC(y, m, d, h, mm, s));
    } else if (date.match(pattern5___)) {
      //console.log("* init Date pattern 5___ *");
      var today = new Date();
      y = date.substring(0, 4);
      m = date.substring(5, 7);
      d = date.substring(8, 9);
      h = 0;
      mm = 0;
      s = 0;
      return new Date(Date.UTC(y, m, d, h, mm, s));
    } else if (date.match(pattern6)) {
      //console.log("* init Date pattern 6 *");
      var today = new Date();
      y = date.substring(0, 4);
      m = date.substring(5, 7);
      d = 1;
      h = 0;
      mm = 0;
      s = 0;
      return new Date(Date.UTC(y, m - 1, d, h, mm, s));
    } else if (date.match(pattern7)) {
      //console.log("* init Date pattern 6 *");
      /* 2022-02-16T10:28:00.000Z */
      y = date.substring(0, 4);
      m = date.substring(5, 7);
      d = date.substring(8, 10);
      h = date.substring(11, 13);
      mm = date.substring(14, 16);
      s = date.substring(17, 19);
      return new Date(Date.UTC(y, m - 1, d, h, mm, s));
    } else {
      //console.log("* init Date no match *");
      return null;
    }
  }
```

이 함수를 사용하여, 객체를 리턴받은 후 포맷 변경이나 기타 작업을 했다. 문제는 해당 형식이 필요한게 IOS 모바일 환경에서만 그랬다는 것이다.

정말 불편하긴 하지만 이런 부분이 아니면 인식을 하지 못하니 울며 겨자먹기로 일일히 변경을 해주어야 했다.
