---
layout: post
title: Javascript - String Array 내 빈 요소 제거하기
description: >
  String Array 내 빈 요소 제거하기
sitemap: false
hide_last_modified: true
categories: [category]
tags: [tag]
---

- Table of Contents
{:toc .large-only}

자바 스크립트에서 String Array 내 empty, undefined, false 등의 요소 제거

```js
strArr = $.grep(strArr, function (n) {
  return n == " " || n;
}); // 배열 빈 요소 제거
```
