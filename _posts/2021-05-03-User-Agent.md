---
title: User-Agent 로 접속한 사용자 브라우저 체크하기
categories: [Backend, Java]
tags: [Java, User-Agent]
---

### 유저 에이전트 체크하기

##### SourceCode

```java
public static String getAgent(HttpServletRequest request) {
		String userAgent = request.getHeader("User-Agent");
		String accessBr = null;
		if (userAgent.indexOf("Trident") > -1) { // IE
			accessBr = "IE";
		} else if (userAgent.indexOf("Edge") > -1) { // Edge
			accessBr = "Edge";
		} else if (userAgent.indexOf("Whale") > -1) { // Naver Whale
			accessBr = "Naver Whale";
		} else if (userAgent.indexOf("Opera") > -1 || userAgent.indexOf("OPR") > -1) { // Opera
			accessBr = "Opera";
		} else if (userAgent.indexOf("Firefox") > -1) { // Firefox
			accessBr = "FireFox";
		} else if (userAgent.indexOf("Safari") > -1 && userAgent.indexOf("Chrome") == -1) { // Safari
			accessBr = "Safari";
		} else if (userAgent.indexOf("Chrome") > -1) { // Chrome
			accessBr = "Chrome";
		} else if (userAgent.indexOf("iPhone") > -1 || userAgent.indexOf("iPad") > -1 || userAgent.indexOf("iPod") > -1) {
			accessBr = "iPhone Web";
		} else if (userAgent.indexOf("Android") > -1) {
			accessBr = "Android Web";
		}
		System.out.println("★★★★★★★★★★★★★★★★★★★★★★★★★★★★★");
		System.out.println("★ userAgent : " + userAgent + " ★");
		System.out.println("★ accessBr : " + accessBr + " ★");
		System.out.println("★★★★★★★★★★★★★★★★★★★★★★★★★★★★★");
		return accessBr;
	}
```
