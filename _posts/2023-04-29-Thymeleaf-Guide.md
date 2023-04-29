---
title: Thymeleaf Basic
categories: [Backend, Spring]
tags: [thymeleaf, springboot, spring]
---


# Thymeleaf

> Thymeleaf + Springboot Quick Start
> 
> [https://chiptune93.github.io/posts/Thymeleaf-QuickStart/](https://chiptune93.github.io/posts/Thymeleaf-QuickStart/)

## 기본 사용 문법에 대한 정리

### 표준 표현식

- 간단한 표현
  - 변수 표현식: `${...}`
  - 선택 변수 표현식: `*{...}`
  - 메시지 표현: `#{...}`
  - 링크 URL 표현식: `@{...}`
  - 조각 표현: `~{...}`

- 리터럴
  - 텍스트 리터럴: `'one text', 'Another one!',…`
  - 숫자 리터럴: `0, 34, 3.0, 12.3,…`
  - 부울 리터럴: `true,false`
  - 널 리터럴: `null`
  - 리터럴 토큰: `one, sometext, main,…`

- 텍스트 작업:
  - 문자열 연결: `+`
  - 리터럴 대체: `|The name is ${name}|`

- 산술 연산:
  - 이항 연산자: `+, -, *, /,%`
  - 빼기 기호(단항 연산자): `-`

- 부울 연산:
  - 이진 연산자: `and,or`
  - 부울 부정(단항 연산자): `!,not`

- 비교와 평등:
  - 비교기: `>, <, >=, <=( gt, lt, ge, le)`
  - 같음 연산자: `==, !=( eq, ne)`

- 조건 연산자:
  - if : `(if) ? (then)`
  - if-then-else: `(if) ? (then) : (else)`
  - 기본: `(value) ?: (defaultvalue)`

### 메세지

- 정적 메세지에 동적으로 변하는 데이터와 같이 사용하기

  - 정적인 메세지가 기본, 동적으로 변경하기
      
    ```html
    <p th:utext="#{home.welcome}">Welcome to our grocery store!</p>
    <!-- ⬇ 값 지정하기. -->
    home.welcome=¡Bienvenido a nuestra tienda de comestibles!
    <!-- ⬇ 실제 렌더링된 구문 -->
    <p>¡Bienvenido a nuestra tienda de comestibles, John Apricot!</p>
    <!-- ⬇ Expression Language 과 같이 사용할 수 있음. -->
    <p th:utext="#{home.welcome(${session.user.name})}">
      Welcome to our grocery store, Sebastian Pepper!
    </p>
    <!-- 더 복잡하게도 사용 가능하다. -->
    <p th:utext="#{${welcomeMsgKey}(${session.user.name})}">
      Welcome to our grocery store, Sebastian Pepper!
    </p>
    ```

### th: 표현식

- `th:text`: 텍스트 값을 출력하는 표현식

```html
<p th:text="${user.name}">Name</p>
```

- `th:utext`: HTML 인코딩되지 않은 텍스트를 출력하는 표현식

```html
<p th:utext="${user.description}">Description</p>
```

- `th:if`: 조건을 검사하여 해당 요소를 표시할지 여부를 결정하는 표현식

```html
<p th:if="${user.admin}">Admin</p>
```

- `th:unless`: th:if와 반대로 작동하며, 조건이 거짓일 때 해당 요소를 표시하는 표현식

```html
<p th:unless="${user.admin}">Not an Admin</p>
```

- `th:switch`: 다중 분기 처리를 위한 표현식

```html
<div th:switch="${user.role}">
    <p th:case="'ADMIN'">Admin</p>
    <p th:case="'USER'">User</p>
    <p th:case="'GUEST'">Guest</p>
    <p th:case="*">Unknown</p>
</div>
```

- `th:each`: 반복문을 처리하는 표현식

```html
<ul>
    <li th:each="product : ${products}" th:text="${product.name}"></li>
</ul>
```

- `th:with`: 변수를 생성하거나 값에 대한 별칭을 지정하는 표현식

```html
<div th:with="discount=${product.price * 0.1}">
    <p th:text="'Discount: ' + ${discount}"></p>
</div>
```

- `th:attr`: HTML 요소에 속성을 추가하는 표현식

```html
<a th:attr="href=@{/products/{id}(id=${product.id})}, title=${product.name}">
    <img th:src="@{/images/product.png}" />
</a>
```

- `th:href`: 링크 URL을 생성하는 표현식

```html
<a th:href="@{/products/{id}(id=${product.id})}">Product Detail</a>
```

- `th:src`: 이미지나 스크립트 등의 소스 URL을 생성하는 표현식

```html
<img th:src="@{/images/product.png}" />
```

### 더 많은 가이드는 공식 문서를 참고하세요!

**[https://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html#introducing-thymeleaf](https://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html#introducing-thymeleaf)**
