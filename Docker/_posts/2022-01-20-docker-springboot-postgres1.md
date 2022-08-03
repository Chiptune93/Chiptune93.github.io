---
layout: post
title: Docker Spring boot + Postgresql (1)
description: >
    [실습] Docker Spring boot + Postgresql (1)
sitemap: false
hide_last_modified: true
categories: [Docker]
tags: [docker, springboot, postgresql]
---

- Table of Contents
{:toc .large-only}

## Docker 명령 참고
- 조회
```
docker ps -a
-a : 정지 중 포함
```

- 중지
```
docker stop <container-id/container-name>
```

- 시작
```
docker start <container-id/container-name>
```

- 재시작
```
docker restart <container-id/container-name>
```

- 접속
```
docker attach <container-id/container-name>
```

## Postgrelsql 12.9-alpine Docker run
```
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=<password> --name Postgresql postgres:12.9-alpine
```

- Postsql Volume 생성 및 탑재 후 러닝
```
docker create volume postgresql-sample
```

* /var/lib/postgresql/data 에 데이터가 저장되기 때문에 해당 경로를 지정 및 캡쳐
```
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD="{password}" -v postgresql-sample:/var/lib/postgresql/data --network boot-sample-network --name Postgresql postgres:12.9-alpine
```


이후 localhost:5432 로 postgresql 접속.
```
-- 사용자 조회
select * from pg_user;

-- 사용자 생성
create user test password 'test';

-- 데이터 베이스 생성
create database test owner test

-- 데이터 베이스 조회
select datname from pg_database;
```

테스트용 테이블 생성
```
-- Drop table

-- DROP TABLE public.test_table;

CREATE TABLE public.test_table (
	"name" varchar(200) NULL,
	value varchar(200) NULL
);
COMMENT ON TABLE public.test_table IS 'test_table';
```

테스트용 데이터 삽입
```
INSERT INTO public.test_table ("name",value) VALUES
	 ('1','TEST_VALUE1'),
	 ('2','TEST_VALUE2'),
	 ('3','TEST_VALUE3'),
	 ('4','TEST_VALUE4'),
	 ('5','TEST_VALUE5'),
	 ('6','TEST_VALUE6'),
	 ('7','TEST_VALUE7'),
	 ('8','TEST_VALUE8'),
	 ('9','TEST_VALUE9'),
	 ('10','TEST_VALUE10');
INSERT INTO public.test_table ("name",value) VALUES
	 ('11','TEST_VALUE11'),
	 ('12','TEST_VALUE12'),
	 ('13','TEST_VALUE13'),
	 ('14','TEST_VALUE14'),
	 ('15','TEST_VALUE15'),
	 ('16','TEST_VALUE16'),
	 ('17','TEST_VALUE17'),
	 ('18','TEST_VALUE18'),
	 ('19','TEST_VALUE19'),
	 ('20','TEST_VALUE20');
```

DB준비 완료



## Spring Boot 2.6.2 + jstl
- build.gradle 설정
```gradle
plugins {
	id 'org.springframework.boot' version '2.6.2'
	id 'io.spring.dependency-management' version '1.0.11.RELEASE'
	id 'java'
}

group = 'com.docker'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '8'

repositories {
	mavenCentral()
}

dependencies {
	implementation 'org.springframework.boot:spring-boot-starter-web'
	testImplementation 'org.springframework.boot:spring-boot-starter-test'
	
	// 사용자 추가

	// dev tool ( 정적 리소스 재시작없이 적용 )
	implementation group: 'org.springframework.boot', name: 'spring-boot-devtools'

	// mybatis-spring-boot
	implementation group: 'org.mybatis.spring.boot', name: 'mybatis-spring-boot-starter', version: '2.1.4'
	// log4j2
	implementation group: 'org.bgee.log4jdbc-log4j2', name: 'log4jdbc-log4j2-jdbc4.1', version: '1.16'   
	// jdbc ( postgresql - jdbc driver )
	implementation group: 'org.postgresql', name: 'postgresql', version: '42.3.1'


	// 스프링 부트는 기본적으로 내장 톰캣을 가지고 있지만 
	// jsp 엔진이 존재하지 않아, jasper 와 jstl 의존성을 추가해주어야 한다.

	// jstl 
	implementation group: 'javax.servlet', name: 'jstl', version: '1.2'

	// jasper
	implementation group: 'org.apache.tomcat', name: 'tomcat-jasper', version: '9.0.56'



}

test {
	useJUnitPlatform()
}
```

- application.yml 설정
```yml
spring:
    application:
        name: springboot-docker-sample

    # DB Connection ( localhost:5432 --> Docker Postgresql 5432 )
    datasource:
        hikari:
            # connect to host port
            #jdbc-url: jdbc:log4jdbc:postgresql://localhost:5432/test
            # connect to container port
            jdbc-url: jdbc:log4jdbc:postgresql://Postgresql/test
            driver-class-name: net.sf.log4jdbc.sql.jdbcapi.DriverSpy
            username: test
            password: test
            maximum-pool-size: 5
    
    # mvc config 
    # 뷰 경로 지정 및 확장자 설정

    # jar 파일로 압축하는 경우, jsp 지원 안하므로 기본 경로가
    # META-INF/resources/WEB-INF/view 가 된다.

    # develop 필요 ... 
    mvc:
        view:
            prefix: /WEB-INF/views/
            suffix: .jsp

    # devtool config
    # 정적 리소스 수정에도 재시작 없이 변경사항 적용
    devtools: 
        livereload:
            enabled: true
```

** 동일 docker network 상에 컨테이너가 존재하는 경우 컨테이너의 Name 값이 {ip}:{port} 값과 대치되어 사용이 가능하다.



- 프로젝트 구조

![dockerboot1](/assets/img/Docker/dockerboot1.png)

sample 프로젝트


## Docker Network 생성
```
docker create network boot-sample-network
```

최종 Docker 이미지 실행 명령
- postgresql ( M1 MAC 에서는 " 를 ' 로 변경 )
```
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD="{password}" -v postgresql-sample:/var/lib/postgresql/data --network boot-sample-network --name Postgresql postgres:12.9-alpine
```

- spring boot
```
docker run -d -p 8080:8080 --network boot-sample-network --name Boot-Sample boot-sample
```

- postgresql volume file

\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes 에 압축해제. (윈도우만)

> M1 Mac에서는 직접 경로로 넣는 부분을 찾지 못해 그냥 다시 만들었다 ... 


[postgresql-sample.zip](/assets/file/Docker/postgres-sample.zip)

* 각 이미지는 dklim93/<image-name> 으로 받을 수 있음.





참고 
- postgresql yml 설정

https://csy7792.tistory.com/292


- 정적 소스 재시작 없이 구동

https://suzxc2468.tistory.com/186

- web xml 설정 사용

https://oingdaddy.tistory.com/356

- docker Network 공유

https://ooeunz.tistory.com/83

- docker Network 설정

https://docs.docker.com/engine/reference/commandline/network_connect/

- 리소스 경로 설정 관련

https://atoz-develop.tistory.com/entry/spring-boot-web-mvc-static-resources

https://stackoverflow.com/questions/28725635/spring-boot-configure-it-to-find-the-webapp-folder

- docker volume 윈도우 경로
```
\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes
```


개선사항
- 데이터 공유는 volume 형태가 아닌 파일(디렉토리) 공유 형태로 변경 > 쉽게 옮길 수 있다.

- 스프링 jsp 리소스 경로는 방법을 통해 복잡하지 않은 경로로 변경할 것.

















