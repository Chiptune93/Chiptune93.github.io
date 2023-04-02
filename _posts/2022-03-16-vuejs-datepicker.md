---
title: VueJs - Datepicker 이벤트 관련 문제
categories: [Frontend]
tags: [vuejs, datepicker]
---

vuejs Datepicker 사용 시, IOS 15+ 모바일 환경에서 발생한 문제에 대해 공유하고자 한다.

작업 중인 애플리케이션 내에서 vuejs datepicker 를 사용하고 있는데 해당 datepicker 에는 이벤트가 다음과 같이 선언되어 있다.

```html
<vuejs-datepicker
  v-model="params.startDate"
  :format="$data._datepicker.format"
  :language="_getDatepickerLanguage()"
  :disabled-dates="disabledDatesFrom"
  @input="params.startDate = _formatedDatepicker($event)"
  @selected="updateDDT"
>
</vuejs-datepicker>
```

@input 은 datepicker에서 날짜를 선택 시, yyyy.mm.dd 형식으로 변환하여 model 에 값을 넣어주는 이벤트이다.

@selected 는 datepicker에서 날짜를 선택하면, 자동적으로 다음 datepicker에 disabled 옵션을 걸어주는 역할을 하는 이벤트 이다.

여기서 발생한 첫번째 문제는 아래의 링크 내용 처럼 ios date 가 문제가 되면서 발생한다.

https://lucete-stellae.tistory.com/72

vuejs datepicker github을 보면 https://github.com/charliekassel/vuejs-datepicker#readme

사용방법에 아래와같이 나와있다.

```
USAGE

<script>
var state = {
  date: new Date(2016, 9,  16)
}
</script>
<datepicker :value="state.date"></datepicker>
```

즉, 사용 시에 변수 초기화는 date 객체로 하라는 뜻이다. 그러나, 애플리케이션에서는 datepicker에 문자열로 된 모델을 통해 값을 초기화 하거나 바꾸고 있었고, 이 부분에서 전부 invalid date가 떨어져 오류가 발생하고 있었다.

> 따라서, datepicker 사용 시에 변수는 항상 javascript date를 통해 초기화하거나 수정하였다.

두번째 문제는 model 에서 발생했다.

```html
<vuejs-datepicker
  v-model="params.startDate"
  :format="$data._datepicker.format"
  :language="_getDatepickerLanguage()"
  :disabled-dates="disabledDatesFrom"
  @input="params.startDate = _formatedDatepicker($event)"
  @selected="updateDDT"
>
</vuejs-datepicker>
```

다시, vuejs datepicker 선언부를 살펴보면 model 옵션이 사용된 것을 알 수 있다. v-model 옵션은 vuejs 를 사용하는 많은 이유 중 값이 동적으로 변경되더라도 렌더링 되는 페이지에서 변경되기 위해 사용하는 옵션이다.
<br/>
<br/>
그리고 datepicker 는 사용 시, input 요소를 통해 선택된 날짜를 보여주게 되어있기 때문에 model을 요소에 바인딩 하는 경우 해당 model 의 값을 보여주고 있다.
<br/>
<br/>
이 경우에, datepicker 에서 날짜를 선택하면 @input 이벤트가 실행되어 v-model의 값에 변화를 주어야 하는데 첫번째로 선택하면 v-model에 변화가 없고, 한번 더 선택해야 실제 v-model의 값에 값을 할당한다는 것이다.
<br/>
<br/>
확인해본 결과, input 이벤트에서 실행되는 \_formatedDatepicker는 다음과 같았다.

```js
_formatedDatepicker: function (date, format) {
	if (util.isEmpty(date)) return "";
	var f = 'YYYY.MM.DD';
	if (format) {
		if (format == 'time') f = 'HH:MM';
		else f = format;
	}
	return moment(date).format(f);
},
```

IOS date문제와 엮여서 그런 줄 알았으나 의외로 이 부분은 문제가 없었다. 문제는

> v-model 과 @input 에서 같은 model 을 사용하는 경우 무슨이유에선 지 model 변수 쪽으로 @input에서 바인딩한 결과가 전달이 안된다는 것이다.

예로 저 부분에서 v-model을 지우고 테스트 해본 결과 정상적으로 datepicker 에서 선택한 날짜 값이 한번에 바인딩 되었다. v-model만 선언하면 두번 선택해야 값이 전달되는 현상이 발생한 것이다.

<br/>

vuejs datepicker 문서 내에 event 항목을 보면, input value가 변경되면 input 이벤트를 발생을 시키는데

```
input | Date|null | Input value has been modified
```

여기서 발생하는 이벤트가 v-model 값 변경 이벤트까지 바로 전달이 안되는 듯 했다. 뭔가 중간에 끊기거나 해서 첫번째 선택한 값이 두번째 선택할 때 v-model 쪽으로 전달이 되는 것으로 예상했다.

```html
<vuejs-datepicker v-model="datepicker.from" // 다른 변수 선언
	:format="$data._datepicker.format"
	:language="_getDatepickerLanguage()"
	:disabled-dates="disabledDatesFrom"
	@input="params.startDate = _formatedDatepicker($event)" // v-model과는 다른 변수 사용
	@selected="updateDDT">
</vuejs-datepicker>
```

더 파볼 수는 없었기 때문에 여기서 고민은 접고 결국 초기화 객체를 하나 더 만들어 사용하는 방법으로 해결했다. back 단에서 초기값을 가져오기 때문에 이를 임시 변수에 세팅하고, 데이터 조회 시 원래 model에 있던 값에 해당 데이터를 옮겨서 조회하도록 했다.
