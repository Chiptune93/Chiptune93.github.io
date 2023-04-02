---
title: SpringBoot - Rest Api Sample 만들기 #1
categories: [Backend, Spring]
tags: [springboot, rest api, api, h2database]
---

기존에 급하게 진행한 사내 SMS API 서비스를 만들고 나서, 정리도 할 겸 샘플로 REST API 샘플 프로젝트를 만들어보기로 했다.
기본적인 버전 정보는 다음과 같다.

### 1. 기본 프로젝트 세팅

JDK11
Spring Boot 2.7.1
Gradle 7.4.1 (Project Initialize > VS Code Spring Extension > Create a Gradle Project)
그리고 Build.gradle 에 추가한 dependency 는 아래와 같다.

```gradle
implementation 'org.springframework.boot:spring-boot-starter-web'
compileOnly 'org.projectlombok:lombok'
annotationProcessor 'org.projectlombok:lombok'
testImplementation 'org.springframework.boot:spring-boot-starter-test'

// dev tool
implementation group: 'org.springframework.boot', name: 'spring-boot-devtools'
// https://mvnrepository.com/artifact/com.google.code.gson/gson
implementation group: 'com.google.code.gson', name: 'gson', version: '2.8.9'
// https://mvnrepository.com/artifact/com.h2database/h2
implementation group: 'com.h2database', name: 'h2', version: '2.1.214'
// https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-data-jdbc
implementation group: 'org.springframework.boot', name: 'spring-boot-starter-data-jdbc', version: '2.7.1'
// https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-data-jpa
implementation group: 'org.springframework.boot', name: 'spring-boot-starter-data-jpa', version: '2.7.1'
// https://mvnrepository.com/artifact/org.mybatis.spring.boot/mybatis-spring-boot-starter
implementation group: 'org.mybatis.spring.boot', name: 'mybatis-spring-boot-starter', version: '2.2.2'
```

설정하면서, 추가적으로 원래는 테스트 할 때 반복문을 통해서 데이터 샘플을 생성하여 테스트하곤 했었는데, 실제 이 샘플을 기반으로 서비스를 생성하게 되면 어차피 데이터베이스에서 데이터를 가져와 API를 구성해야 하는 만큼 샘플 데이터를 어떻게 하면 효율적으로 제공할 수 있을까를 고민하였는데, 그 때 마침 검색해서 나온 것이 h2 Database 였다.

여태까지는 "테스트" 단계는 그다지 많이 고려를 하지 않았었는데, 막상 사용해보니 생각보다 괜찮았다.

Spring Boot의 Auto Configuration을 통하여 별도의 많은 셋팅을 하지 않더라도 DB를 세팅하여 프로젝트를 돌릴 수 있었다.
아래는 h2 database에 대해 찾은 블로그 글이다.

https://dololak.tistory.com/285

실제 서비스에서는 MyBatis를 사용하는 만큼 샘플 프로젝트에서도 연동해보았다.

### 2. h2 Database + MyBatis 연계 설정

우선 build.gradle에 아래의 라이브러리가 필요하다.

```gradle
 build.gradle
// https://mvnrepository.com/artifact/com.h2database/h2
implementation group: 'com.h2database', name: 'h2', version: '2.1.214'
// https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-data-jdbc
implementation group: 'org.springframework.boot', name: 'spring-boot-starter-data-jdbc', version: '2.7.1'
// https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-data-jpa
implementation group: 'org.springframework.boot', name: 'spring-boot-starter-data-jpa', version: '2.7.1'
// https://mvnrepository.com/artifact/org.mybatis.spring.boot/mybatis-spring-boot-starter
implementation group: 'org.mybatis.spring.boot', name: 'mybatis-spring-boot-starter', version: '2.2.2'
```

설정 파일을 아래와 같이 세팅한다.

application.yml

```yml
spring:
  application:
    name: REST-API
  datasource:
    hikari:
      # 메모리를 사용하여 DB를 올린다.
      jdbc-url: jdbc:h2:mem:h2-test
      # 파일 형태를 사용하고자 한다면 다음과 같이 사용한다.
      # jdbc-url: jdbc:h2:file:{경로}/{파일명}
      driver-class-name: org.h2.Driver
      username: sa
      password:
      generate-unique-name: false
      maximum-pool-size: 4
  h2:
    console:
      enable: true
      path: /h2-console
```

h2-test라는 DB명은 마음대로, username/password는 위와 같이 설정한다. 아래의 h2 항목은 브라우저로 콘솔창에 접근하기 위한 설정과 경로이다. 위 설정대로라면 어플리케이션 구동 후, http://localhost:8080/h2-console 로 콘솔에 접속이 가능하다(8080포트기준)

그리고 난 후 간단한 test 클래스를 작성하여 어플리케이션을 구동하여 DB가 올라오는지 확인 할 수 있다.

testRunner.java

```java
package rest.api.sample;

import java.sql.Connection;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

@Component
public class TestRunner implements ApplicationRunner {

    @Autowired
    DataSource dataSource;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        Connection connection = dataSource.getConnection();
        System.out.println("url : " + connection.getMetaData().getURL());
        System.out.println("userName : " + connection.getMetaData().getUserName());
    }

}
```

![restapi1](/assets/img/Spring/restapi1.png)

이렇게 로그가 정상적으로 찍힌다면 문제없이 구동된 것이고, 콘솔로도 확인이 가능하다.
내가 겪은 문제로는 Spring Boot 의 Auto Configuration이 제대로 동작하지 않아서 No Bean for datasouce 에러가 뜨긴 했는데, 새로고침과 재로딩을 통해 문제를 해결했다.

이제 MyBatis를 추가해보자.

build.gradle에는 아까 추가를 했으니, application.yml에 아래의 설정을 추가한다.

application.yml

```yml
mybatis:
  # mapper파일 위치 설정
  mapper-locations: mybatis/**/*.xml
  # 카멜 케이스 허용
  configuration:
    map-underscore-to-camel-case: true
  # 풀 패키지명을 지정하지 않기 위한 미리 정의 추가
  type-aliases-package: rest.api.sample.data
```

그리고 각 설정에 맞게 repository에 interface 클래스와 mapper를 추가하면 된다.

![restapi2](/assets/img/Spring/restapi2.png)

각 폴더에 맞게 작성한 모습

### 3. Boot Running 시, h2 database에 샘플 데이터 추가하기.

기본적으로 h2 database를 사용하게 되면, schema와 데이터를 어플리케이션 구동 시, 자동으로 찾아서 실행해준다.
따라서, 해당 sql 파일을 작성하여 적절하게 놔두면 어플리케이션 구동 시, 알아서 읽어서 실행을 시켜준다.

경로는 resouces 폴더 아래이며, 아래와 같이 작성했다.

schema.sql

```sql
CREATE TABLE IF NOT EXISTS members
(
    user_id         VARCHAR(50)     NOT NULL,
    user_name       VARCHAR(50)     NOT NULL,
    user_email      VARCHAR(50)     NOT NULL,
    user_age        VARCHAR(50)     NOT NULL,
    user_address    VARCHAR(50)     NOT NULL,
    user_enter_date VARCHAR(50)     NOT NULL,
    PRIMARY KEY (user_id)
);
```

data.sql

```sql
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user1','유저1','user1@user.net','1','서울시 유저구 유저동 1길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user2','유저2','user2@user.net','2','서울시 유저구 유저동 2길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user3','유저3','user3@user.net','3','서울시 유저구 유저동 3길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user4','유저4','user4@user.net','4','서울시 유저구 유저동 4길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user5','유저5','user5@user.net','5','서울시 유저구 유저동 5길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user6','유저6','user6@user.net','6','서울시 유저구 유저동 6길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user7','유저7','user7@user.net','7','서울시 유저구 유저동 7길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user8','유저8','user8@user.net','8','서울시 유저구 유저동 8길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user9','유저9','user9@user.net','9','서울시 유저구 유저동 9길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user10','유저10','user10@user.net','10','서울시 유저구 유저동 10길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user11','유저11','user11@user.net','11','서울시 유저구 유저동 11길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user12','유저12','user12@user.net','12','서울시 유저구 유저동 12길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user13','유저13','user13@user.net','13','서울시 유저구 유저동 13길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user14','유저14','user14@user.net','14','서울시 유저구 유저동 14길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user15','유저15','user15@user.net','15','서울시 유저구 유저동 15길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user16','유저16','user16@user.net','16','서울시 유저구 유저동 16길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user17','유저17','user17@user.net','17','서울시 유저구 유저동 17길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user18','유저18','user18@user.net','18','서울시 유저구 유저동 18길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user19','유저19','user19@user.net','19','서울시 유저구 유저동 19길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user20','유저20','user20@user.net','20','서울시 유저구 유저동 20길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user21','유저21','user20@user.net','21','서울시 유저구 유저동 21길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user22','유저22','user20@user.net','22','서울시 유저구 유저동 22길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user23','유저23','user20@user.net','23','서울시 유저구 유저동 23길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user24','유저24','user20@user.net','24','서울시 유저구 유저동 24길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user25','유저25','user20@user.net','25','서울시 유저구 유저동 25길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user26','유저26','user20@user.net','26','서울시 유저구 유저동 26길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user27','유저27','user20@user.net','27','서울시 유저구 유저동 27길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user28','유저28','user20@user.net','28','서울시 유저구 유저동 28길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user29','유저29','user20@user.net','29','서울시 유저구 유저동 29길','2022-07-01');
INSERT INTO members (user_id,user_name,user_email,user_age,user_address,user_enter_date) VALUES ('user30','유저30','user20@user.net','30','서울시 유저구 유저동 30길','2022-07-01');
```

이렇게 작성해 놓고 어플리케이션을 구동시킨 다음, http://localhost:8080/h2-console 로 접속하여 데이터를 확인할 수 있다.

![restapi3](/assets/img/Spring/restapi3.png)
