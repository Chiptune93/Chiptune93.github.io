---
title: JSP/HTML - 페이지 캐시 미사용 설정
categories: [Frontend]
tags: [jsp, html, no cache, cache]
---

## JSP

JSP의 경우 페이지 상단에 아래 구문을 넣으면 캐쉬가 적용되지 않는다.

```jsp
<%
 response.setHeader("Cache-Control","no-cache");
 response.setHeader("Pragma","no-cache");
 response.setDateHeader("Expires",0);
%>
```

## HTML

HTML의 경우 아래 구문을 <head> 태그 사이에 넣어주면 된다.

```html
<meta http-equiv="Cache-Control" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<meta http-equiv="Pragma" content="no-cache" />
```
