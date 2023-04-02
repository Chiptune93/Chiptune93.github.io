---

title: Vuejs - EL 값을 바인딩 하면, 이벤트 전달이 안되는 현상
description: >
  [ Vue js + JSP ] EL 값을 바인딩 하면, 이벤트 전달이 안되는 현상


categories: [Frontend]
tags: [vuejs, jsp, el]
---



JSP 페이지 내에서 Vue.js 컴포넌트를 사용하던 중, 이벤트 전달이 안되는 현상이 발생했다.

jsp 페이지 내 vue.js 선언 부분

```js
var vm = new Vue({
	el: '#content',
	components: {},
	data: function () {
		return {
        	list: [],
			pageInfo: {
				pageNo: 1,
				pageSize: 10,
				totalCount: 0,
			}
		}
	},
	created: function () {
		let vm = this;
		vm.list = JSON.parse('${result.list}');
		vm.totalCount = ${result.totalCount};
	},
	mounted: function () {
		console.log('mounted p');
	},
	updated: function () {
		console.log('updated p');
	},
	distroyed: function () {
		console.log('distroyed p');
	},
	methods: {
		goPage: function (pageNo) {
			location.href="./index.do?pageNo=" + pageNo;
		},
	}
});
```

컴포넌트 부분

```html
<paging
  v-bind:total-count="pageInfo.totalCount"
  v-bind:page-no="pageInfo.pageNo"
  v-bind:opts="pageInfo"
  @update:page="goPage"
></paging>
```

pageInfo 값을 가져와서 페이징을 그리는 컴포넌트이다.

이 상황에서 아무리 pageInfo 의 totalCount 를 업데이트 해도 페이지가 정상적으로 동작하지 않았다.

1. 컴포넌트 선언 부에, 콘솔 로그를 찍고 확인해보았다.

> 로그가 찍히지 않았다.

2. Create 시점에서 totalCount 를 임의의 값으로 변경했다.

> 해당 값으로 페이징이 정상동작 하였다.

위 상황을 통해 결국엔 이벤트 전파에 문제가 있다고 생각했고

무엇이 문제인지 찾아본 결과 공식 문서에서 아래의 내용을 찾았다.

![vuejsp1](/assets/img/Vuejs/vuejsp1.png)

![vuejsp2](/assets/img/Vuejs/vuejsp2.png)

즉, Create 시점에서는 $el 을 사용할 수 없다는 얘기이다. 아무리 create 시점에서 변수에 el 값을 바인딩 해봤자 Vue 에서 해당 값이 변경됨을 감지하지 못하는 것이다.

따라서 아래와 같이 mount 부분에서 수정을 해줌으로써 문제를 해결했다.

```js
mounted: function () {
	console.log('mounted p');
	let vm = this;
	vm.pageInfo.totalCount = ${result.totalCount};
	vm.pageInfo.pageNo = ${result.paramMap.pageNo};
},
```

JSP 페이지에서 Vue.js 를 사용한다면 꼭 명심해야할 사항으로 보인다.
