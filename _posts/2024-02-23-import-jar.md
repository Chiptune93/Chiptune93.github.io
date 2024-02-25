---
title: 프로젝트에 외부 Jar 넣어 사용하기
categories: [Backend, Spring]
tags: [Custom Jar, Spring Boot, Jar Import]
---

## 특정 프로젝트 Jar 를 다른 프로젝트에 넣기.

- 프로젝트 A(SpringBoot)를 Jar 혈태로 압축하여 다른 프로젝트에서 사용할 수 있게끔 만드는 것을 목표로 하였다.
- 특정 컴포넌트 클래스만 제공하는게 아니라 스프링 부트 애플리케이션 자체를 말아서 같이 전달하고 싶었다.

### 개발 환경
  - 프로젝트 A 
    - Java 1.8 기반 Kotlin 1.9
    - Spring Boot 2.7.18
  - 프로젝트 B
    - Java 1.8
    - Spring Boot 2.7.18

### Jar 파일 생성

여기서 그냥 부트를 Jar로 패키징하여 그냥 넣게되면 참조할 수 없는데, 이유는 다음과 같다.

> A standard Spring Boot JAR puts the classes into the BOOT-INF dir. Therefore, it cannot be used as dependency by other projects.

[참고링크](https://stackoverflow.com/questions/76573580/not-able-to-import-local-project-jar-into-another-local-maven-spring-boot-kotlin#:~:text=A%20standard%20Spring%20Boot%20JAR%20puts%20the,be%20used%20as%20dependency%20by%20other%20projects)

일반적으로 Jar로 패키징한 프로젝트들의 파일들은 클래스를 `BOOT-INF` 경로에 넣게되는데 여기는 참조할 수 있는 경로가 아니다.
게다가 모든 의존성이 포함되지 않기 때문에 설령 참조할 수 있는 경로에 넣더라도 사용할 수 없다.

Gradle의 jar 태스크로 생성된 기본 JAR 파일에는 컴파일된 클래스 파일과 프로젝트의 리소스만 포함된다.
즉, 프로젝트에서 선언된 의존성(라이브러리)들은 기본적으로 JAR 파일에 포함되지 않는다. 
이는 jar 태스크가 단순히 프로젝트 소스 코드와 리소스 파일을 패키징하는 것을 목적으로 하기 때문이다.

따라서, 일반적인 Jar 형태로 패키징을 하여 다른 프로젝트에서 참조하는 경우
A 프로젝트에서 사용하는 의존성 패키지들을 전부 B에서 다시 넣어주어야 동작하게 된다.

### 모든 의존성을 포함한 패키징 하기

일반적으로 Fat-jar 혹은 Uber-jar 라고 불리우는
모든 의존성이 포함된 Jar를 패키징하여야 다른 프로젝트에서 별도의 의존성 추가 없이 동작할 수 있다는 것을 알았다.

1. Gradle에서 Shadow 혹은 spring-boot-gradle-plugin 과 같은 플러그인 사용
- shadowJar를 통한 패키징 작업 수행.

```gradle
plugins {
    id 'com.github.johnrengelman.shadow' version 'x.x.x'
}

shadowJar {
    archiveClassifier.set('')
    manifest {
        attributes 'Main-Class': 'com.example.Main'
    }
}
```
 
2. 직접 작업을 수행하기.
- 기존 jar 태스크에 내용을 수정하여 모든 의존성 포함하게 만들기

```gradle
tasks.jar {  
	  // 압축파일명
    archiveName = "tech-lab-core.jar"
    // 코틀린일 경우, 메인 클래스 경로를 넣어주어야 함.
    manifest.attributes["Main-Class"] = "{메인클래스까지의경로}.Application.Kt"
    // 모든 의존성 압축 파일을 포함시키는 구문.
    val dependencies = configurations  
        .runtimeClasspath  
        .get()  
        .map(::zipTree)  
    from(dependencies)  
    // 중복 의존성 발견 시, 처리 전략.
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE  
}
```

위 방법을 적용한 프로젝트 A를 패키징 하면 압축 파일로 떨어지게 된다.

### 해당 패키지를 포함 시키기

[인텔리제이에서 패키징 포함하는 방법](https://inpa.tistory.com/entry/IntelliJ-%F0%9F%92%BD-%EC%9E%90%EB%B0%94-%EC%99%B8%EB%B6%80-%EB%9D%BC%EC%9D%B4%EB%B8%8C%EB%9F%AC%EB%A6%AC-%EA%B0%84%EB%8B%A8-%EC%B6%94%EA%B0%80%ED%95%98%EA%B8%B0)

모든 의존성을 포함한 패키지 파일을 다른 프로젝트에 넣게 되면
그제서야 모든 의존성을 불러오고 참조할 수 있게 된다.즉, 프로젝트 B를 구동할 때, 프로젝트 A의 의존성 및 스프링 빈 등이 같이 올라오게 된다.

**따라서, 구성할 때 빈이 중복되어 올라오거나 순서 상의 문제로
오류가 발생할 수 있으니 주의를 해야 한다.**




