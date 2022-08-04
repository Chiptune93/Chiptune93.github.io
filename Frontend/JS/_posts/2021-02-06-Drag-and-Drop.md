---
layout: post
title: Javascript - Drag and Drop 간단하게 구현하기.
description: >
  Drag and Drop 간단하게 구현하기.
sitemap: false
hide_last_modified: true
categories: [Frontend]
tags: [JS, Drag and Drop]
---

- Table of Contents
{:toc .large-only}

아래 방법은 javascript 를 통해 Drag and Drop 기능을 사용하는 방법에 대해 구현한 내용이며

data-set 을 통해 데이터를 실제 이동 시키는 것이 아니라, 사용자가 정의한 함수를 실행 시킴으로써

간단하게 구현한 예제입니다.

## 1. 드래그 기능이 시작하는 요소 ( a태그 ) 에 아래와 같은 속성 부여

```html
<a href="#" class="" draggable='true' ondragend="{functionName}";">드래그할 항목명</a>
```

- draggable : 드래그가 가능하도록 설정하겠다는 속성

- ondragend : 드래그가 "끝날때" 실행할 함수 설정

## 2. 드래그한 요소를 받을 영역에 아래와 같은 속성 부여

```html
<div class="" ondragover="onDragOver(event);">...</div>
<script>
  function onDragOver(event) {
    event.preventDefault();
  }
</script>
```

- ondragover : 드래그된 요소가 오버되면, 실행할 함수 설정

- event.preventDefault() : 이벤트 전파 방지 설정을 기본으로 추가한다. 이후 커스텀 정의해도 됨.

이렇게 구성하면, 간단하게 드래그 앤 드롭 기능을 구현하면서, 사용자 정의 함수를 통해 원하는대로 수정이 가능하다.

> 예를 들어, 드래그 할 영역에서 파일이라던가, 다른 값들을 가져와야 한다면, 사용자 정의 함수 측에 data-params 같은 방식을 써서 드래그 오버 되는 영역 내 요소를 잡아 바인딩 하는 등의 방식을 사용할 수 있다.

간단하게 구현하고자 하면 이렇게 하는게 제일 빨랐다.

그 외에 드래그앤드롭 속성에 대해 자세한 글을 원한다면 아래를 참조바랍니다.

[mber.tistory.com/19](mber.tistory.com/19)
