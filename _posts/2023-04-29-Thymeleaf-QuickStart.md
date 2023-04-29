---
title: Thymeleaf With Springboot
categories: [Backend, Spring]
tags: [thymeleaf, springboot, spring]
---


# Thymeleaf Examples

## What is Thymeleaf

Thymeleaf는 HTML, XML, JavaScript, CSS와 같은 웹 문서를 만들기 위한 자바 템플릿 엔진입니다. Spring Boot에서는 Thymeleaf를 사용하여 서버 측의 데이터를 템플릿과 결합하여 동적으로 생성된 웹 페이지를 생성할 수 있습니다.

Thymeleaf는 HTML 파일에서 서버 측의 데이터를 쉽게 바인딩할 수 있는 문법을 제공합니다. 예를 들어, 다음과 같이 서버 측에서 전달된 데이터를 HTML 문서에 출력할 수 있습니다.

## How to Use

### 1. 의존성 추가

- Maven

    ```xml
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-thymeleaf</artifactId>
    </dependency>
    ```

- Gradle

    ```gradle
    // https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-thymeleaf
    implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'
    ```

- 추가 의존성
  - boot-starter-web
  - boot-starter-test

### 2. 정적 리소스 파일 경로 설정

```text
- resources
    - static <- css/js 같은 에셋들을 저장하는 장소. 자동으로 인식함.
    - templates <- html 파일을 위치시키는 장소.
```

templates 폴더 하위에 있는 html 파일들은 static 폴더 하위의 정적 파일로 접근과 다르게 url을 바로 호출할 수 없습니다.

### 3. thymeleaf 옵션 설정

- application.yml
  ```yml
    thymeleaf:
      prefix: classpath:templates/ # 루트 폴더 변경
      check-template-location: true # 로케이션 경로 체크
      suffix: .html # 파일 확장자 기본 설정
      mode: HTML
      cache: false # 캐시 설정, default true, 개발 시에는 false로 두어서 정적 파일처럼 사용
  ```

### 4. 컨트롤러,서비스,레파지토리 및 html 파일 작성

- Controller
  ```java
  package dev.chiptune.springboot.controller;
  
  import dev.chiptune.springboot.service.UserService;
  import org.springframework.beans.factory.annotation.Autowired;
  import org.springframework.stereotype.Controller;
  import org.springframework.ui.Model;
  import org.springframework.web.bind.annotation.GetMapping;
  
  @Controller
  public class IndexController {
  
      @Autowired
      UserService userService;
  
      @GetMapping(value = "/")
      public String test(Model model) {
          model.addAttribute("users", userService.getAllUser());
          return "/test";
      }
  }

  ```
- Service
  ```java
  package dev.chiptune.springboot.service;
  
  import dev.chiptune.springboot.model.User;
  import dev.chiptune.springboot.repository.UserRepo;
  import org.springframework.beans.factory.annotation.Autowired;
  import org.springframework.stereotype.Service;
  
  import java.util.List;
  
  @Service
  public class UserService {
  @Autowired
  UserRepo userRepo;
  
      public List<User> getAllUser() {
          return userRepo.getAllUser();
      }
  }

  ```
- Repo
  ```java
  package dev.chiptune.springboot.repository;
  
  import java.util.List;
  
  import dev.chiptune.springboot.model.User;
  import org.springframework.stereotype.Repository;
  
  
  @Repository
  public interface UserRepo {
    List<User> getAllUser();
  }

  ```
- Mapper
  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  
  <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
  
  <mapper namespace="dev.chiptune.springboot.repository.UserRepo">
      <select id="getAllUser" resultType="User">
          SELECT * FROM SAMPLE_USER
      </select>
  </mapper>

  ```
- html
  ```html
  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
  <html lang="en">
  <head>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
      <title>Document</title>
  </head>
  <body>
  <table>
      <thead>
      <th>아이디</th>
      <th>이름</th>
      <th>나이</th>
      <th>가입일</th>
      </thead>
      <tbody>
      <tr th:each="item : ${users}">
          <td th:text="${item.userId}">Item Id</td>
          <td th:text="${item.userName}">Item Name</td>
          <td th:text="${item.userAge}">Item Age</td>
          <td th:text="${item.userJoinDate}">Item joinDate</td>
      </tr>
      </tbody>
  </table>
  </body>
  </html>

  ```

### 5. 예제 프로젝트 다운로드

https://github.com/Chiptune93/springboot-examples/tree/thymeleaf
