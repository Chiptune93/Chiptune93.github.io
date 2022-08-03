---
layout: post
title: Docker Spring Boot + Postgresql (2)
description: >
    [실습] Docker Spring Boot + Postgresql (2)
sitemap: false
hide_last_modified: true
categories: [Docker]
tags: [docker,springboot,postgres]
---

- Table of Contents
{:toc .large-only}

개선사항 진행
1. 볼륨 마운트에서 디렉토리 마운트로 변경

2. 스프링 부트 jsp 찾을 수 있게 수정


## Spring Boot + JSP
1. spring boot jar 배포 환경에서 jsp 경로 문제 때문에 war배포로 임시 수정 (해결방법 찾을때 까지만)

Dockerfile
```dockerfile
FROM adoptopenjdk/openjdk8
EXPOSE 8080:8080
ARG WAR_FILE=build/libs/boot-sample-0.0.1-SNAPSHOT.war
COPY ${WAR_FILE} app.war
ENTRYPOINT [ "java", "-jar", "/app.war" ]
```

Build 후 run command
```
docker run -d -p 8080:8080 --network boot-sample-network --name Boot-Sample boot-sample
```

## Postgresql Docker 
1. 볼륨 바인딩에서 경로 바인딩으로 변경.

2. 바인딩 된 폴더를 깃으로 공유하고 있었는데, 공유 시 특정 파일 또는 경로를 무시하는 현상 발생. 지정된 바인딩 경로는 압축하여 공유하는 형태로 변경하여 러닝함.
```
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD='${password}' -w ${bind경로} -v ${bind경로}:/var/lib/postgresql/data --platform linux/amd64 --network boot-sample-network --name Postgresql postgres:12.9-alpine
```
( 윈도우에서는 해당 스크립트를 power shell 에서 실행. ' 를 " 로 변경, 경로 문제 발생 시 원하는 경로 위치하여 ${pwd} 변수 사용 )

위 러닝 스크립트로 동일 Docker Network 상에서 실행 시 부트 프로젝트에서 데이터 바인딩까지 가능한 것을 확인. 

## Docker-compose.yml 변환 작업 진행
1. Postgresql 과 Spring Boot를 서비스로 묶어서 실행하기.
```dockerfile
version: "3.7"

services:
  app:
    # Dockerfile - FROM
    image: adoptopenjdk/openjdk8
    # Dockerfile - EXPOSE
    ports:
      - 8080:8080
    # image build dir
    build:
      context: .
      # Dockerfile - ARG
      args:
        WAR-FILE: build/libs/boot-sample-0.0.1-SNAPSHOT.war
    # Dockerfile - ENTRYPOINT
    entrypoint: 
      - java
      - '-jar'
      - /app.war
    # Dockerfile - COPY command
    command: 'COPY ${WAR_FILE} app.war'
    # link : 참조할 다른 컨테이너 연결 - application.yml 내 DB 연결 네이밍 참고.
    links:
      - db:Postgresql
    # 종속성 정의. 여기에선 db 실행 후에 app 실행함을 의미.
    depends_on:
      - db
  db:
    # DB 이미지
    image: postgres:12.9-alpine
    # 포트 지정
    ports:
      - 5432:5432
    # -e 환경 변수 : docker run 명령 참고
    environment:
      - POSTGRES_PASSWORD=${password}
    # 볼륨 지정 : 디렉토리 마운팅
    volumes:
      - ${bind-dir}:/var/lib/postgresql/data

# Docker Network : 미리 생성된 네트워크 이름을 지정
networks:
  default:
    external:
      name: boot-sample-network
```

이후 Docker Compose 실행
```
docker-compose up -d
```

확인작업 - 러닝 OK

![dockerboot2-1](/assets/img/Docker/dockerboot2-1.png)


spring boot 확인 - OK

![dockerboot2-2](/assets/img/Docker/dockerboot2-2.png)


> 2차 개선사항

1. docker compose 에서 환경 별 (개발/운영) 로 나누어 개발에서는 docker network 사용, 운영에서는 Server to Server 통신을 할 수 있게끔 빌드 구분하기.

2. docker compose 에서 네트워크 지정 관련 옵션 찾아보기 (미리 생성된 네트워크 말고, 다른 방식이 있는지)





