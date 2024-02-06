---
title: "kotlin 클래스 'class-name'에는 [public, protected] no-arg 생성자가 포함되어야 합니다."
categories: [Etc, Error]
tags: [kotlin, kotlin error, kotlin compiler]
---


## 버전 정보
- Springboot 3.2
- Java 17 with Kotlin
- Spring Data JPA 사용 환경

## 문제 상황
- 엔티티 클래스를 작성하던 도중 만난 문제.
- 기본적으로 Hibernate가 관리하는 엔티티 클래스의 경우 Reflection을 이용하여 엔티티를 생성한다.
  (Reflection을 사용하는 이유는 문자열로 클래스를 탐색하여 객체를 생성하기에 컴파일 단계에서 에러를 뱉지 않는다. new 연산자는 원하는 클래스를 import하지 않으면 컴파일과정에서 에러가 발생한다.)
- 따라서, 기본 생성자들이 포함되어 있어야 한다.(All Arg, No Arg ... )

## 해결 방법
- Lombok 어노테이션을 사용하여 생성자 사용 지정.
- 직접 생성자를 생성하기.

여간 귀찮은 작업이 아닐 수 없다.
다행히 코틀린 공식에서 컴파일러 플러그인을 통해 이러한 문제를 쉽게 우회할 수 있다.
https://kotlinlang.org/docs/no-arg-plugin.html#jpa-support

언급된 내용은 아래와 같다.

> `kotlin-spring`의 위에 래핑된 플러그인 과 마찬가지로 는 `all-open`의 `kotlin-jpa`위에 래핑됩니다 `no-arg`. 플러그인은 [`@Entity`](https://docs.oracle.com/javaee/7/api/javax/persistence/Entity.html), [`@Embeddable`](https://docs.oracle.com/javaee/7/api/javax/persistence/Embeddable.html)및 _no-arg_ 주석을 자동으로 지정합니다.[`@MappedSuperclass`](https://docs.oracle.com/javaee/7/api/javax/persistence/MappedSuperclass.html)

다음과 같이 build.gradle에 지정해 사용한다.

```yml
plugins { 
	// ...
	kotlin("plugin.jpa") version "1.9.22" 
	// ...
}
```

