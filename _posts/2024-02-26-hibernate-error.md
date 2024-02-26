---
title: 데이터베이스에 'hibernate_sequence'(이)라는 개체가 이미 있습니다.
categories: [Etc, Error]
tags: [ORM, JPA, hibernate_sequence, Error]
---

## 환경

- Java 1.8 , Kotlin
- SpringBoot 2.7.18

## 문제 상황

Spring Data Jpa를 사용하면서 기본키 생성을 `AUTO_INCREMENT`로 하기 위해
`@SequenceGenerator` 를 사용하여 시퀀스를 생성 후, 이를 기본키로 할당 했었다.

이후, 시퀀스 생성이 아닌 다른 방식을 사용하기 위해 주석 처리를 하였음에도 에러가 발생했다.

## 문제 원인

테이블 기본키는 시퀀스로 하지 않고 별도 방식의 할당 없이 `@Id` 만 존재하는 경우
기본적으로 `TableGenerator`를 이용한다. 이 방식은 별도의 시퀀스를 테이블로 관리하고
이 테이블을 조회하여 시퀀스를 할당 받는 방식이다.

## 해결

JPA 설정 중, `hibernate.id.new_generator_mappings` 를 `false` 로 바꾼다.
이 옵션은 5.0 이후 버전 부터는 `true`가 기본 값이며, 이를 `true`로 하는 경우
기본적으로 시퀀스 생성 시, 테이블 방식 또는 데이터베이스 시퀀스를 자동으로 사용하도록 한다.

### 참고

- https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#configurations-mapping

