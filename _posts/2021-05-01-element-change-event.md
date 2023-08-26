---
title: jQuery - 실시간 요소 변경 탐지하기
categories: [Frontend, Scripts]
tags: [Element Change, jQuery, event handler]
---

### input 요소에 대한 실시간 변경을 탐지하여 원하는 내용을 실행하도록 하는 함수

```js
$(document).ready( function () {
	// 비교를 위한 현재 값 저장
	var old_value = $("#inputText").val();
    // on 메소드에 체크하고자 하는 Action을 기입한다.
    // propertychange 는 개발자도구나 기타 방법으로 property 가 변경된 경우를 뜻함.
    $( "#test" ).on( "propertychange change paste keyup keydown input" ,function () {
    	var now_value = $( this ).val();
        // 원하는 내용
        // 여기서는 이전값과 비교하여 다른 경우 notice 하는 내용
        if ( now_value == old_value ) { return; }
        old_value = now_value;
		alert( "값이 변경되었습니다." );
    });
}
```

> propertychange 의 경우, disable이나 readonly 시킨 요소에 대해 개발자도구나 기타 방법을 통해 속성 변경이 일어날 경우 감지하여 값을 저장하는 것을 막는다던가 하는 방법도 있어 유용할 것 같다.
