---
title: Javascript - 스크립트 파일 import 시, 캐시 안남게 처리하기
categories: [Frontend, Scripts]
tags: [cache, javascript, import script]
---

- 파일 자체에 버전 변수를 주어서, 브라우저에서 가져올 때, 다른 파일로 인식하게끔 하여 새로 로딩하게 함.

```JS
<%@page import="java.util.Random"%>
<%
        Random random = new Random();
        int ran = random.nextInt(1000000);
%>
...
<script src="{스크립트파일경로}?ver=<%= ran %>" />
...
```
