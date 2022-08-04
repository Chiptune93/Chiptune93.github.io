---
layout: post
title: JSP - Input text 항목 엔터 시, 자동 submit 막기.
description: >
  Input text 항목 엔터 시, 자동 submit 막기.
sitemap: false
hide_last_modified: true
categories: [Frontend]
tags: [jsp, auto submit]
---

- Table of Contents
{:toc .large-only}

가끔가다 마주치는 문제로, input type text 요소에 onkeypress 를 설정하지 않았는데도

해당 요소가 속한 form 이 자동으로 submit 되는 문제가 있었다.

이는 브라우저의 문제로, document 내 input 요소 첫번째를 자동으로 잡아 submit 하는 기능이 존재하기 때문이다.

또한, form 태그내 input 요소가 하나 인 경우 해당 요소를 포커싱 한 후, enter 입력 시 form을 submit 시켜버린다.

따라서, 해당 상황을 방지하기 위해서는 다음과 같은 방법이 있다.

## 1. 엔터 입력 제어 - 키보드 입력의 엔터키를 판별하여 자바스크립트로 제어한다.

```jsp
<form name="textForm">
...
<input type="text" onkeypress="keypress();" />
...
</form>
<script>
	function keypress( event ) {
    	if ( event.keyCode == 13 ) {
        	submit();
        }
    }
</script>
```

## 2. Form 태그에 onSubmit="return false;" 추가

```jsp
<form name="textForm" onsubmit="return false;">
...
<input type="text" value="" />
...
</form>
```

## 3. input 태그를 하나더 추가한다 - input type="hidden" 을 하나 더 둔다.

```jsp
<form name="textForm">
...
<input type="hidden" value="" />
<input type="text" value="" />
...
</form>
```
