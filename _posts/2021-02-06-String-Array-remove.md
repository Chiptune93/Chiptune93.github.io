---
title: Javascript - String Array 내 빈 요소 제거하기
categories: [Frontend, Scripts]
tags: [tag]
---

자바 스크립트에서 String Array 내 empty, undefined, false 등의 요소 제거

```js
strArr = $.grep(strArr, function (n) {
  return n == " " || n;
}); // 배열 빈 요소 제거
```
