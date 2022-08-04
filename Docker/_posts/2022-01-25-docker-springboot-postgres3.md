---
layout: post
title: Docker Spring Boot + Postgresql (3)
description: >
  [실습] Docker Spring Boot + Postgresql (3)
sitemap: false
hide_last_modified: true
categories: [Docker]
tags: [docker, springboot, postgres]
---

- Table of Contents
{:toc .large-only}

개선사항 진행

1. Docker Compose 환경 별로 구분하기.

2. 네트워크 관련 찾아보기

## Docker Compose 구분하기

단일 docker-compose.yml 을 multi-compose.yml 로 분할.

> docker-compose 파일 내에서는 if case 같은 조건문의 작성이 불가능하다.

조건문의 작성이 불가능 하여 Multi-compose file 형태로 작성을 하기로 하였다.

docker-compose 옵션 중, -f 옵션을 지정하여 compose 파일을 재정의할 수 있다. (옵션 참고)

여기서 재정의란, 기존 compose 파일 외에 다른 파일을 지정하여 덮어 쓰는 행위로, 같은 네이밍의 옵션이 있다면 나중에 지정한 파일의 옵션이 덮어씌워지고 새로운 옵션인 경우 해당 옵션을 추가하여 하나의 compose 파일로 합친 후 실행하는 것이다.

![dockerboot3-1](/assets/img/Docker/dockerboot3-1.png)

추가적으로, 각 환경마다 다른 변수 또는 값 때문에 .env 파일을 만들어 환경변수 형태로 각 환경 별 맞는 값을 제공하여 개발/운영 환경의 구분을 하기로 한다.

# 1. docker-compose.yml - base file

```yml
# docker-compose (base)
# base file
# 기본적으로 실행될 코드들을 정의한다.
# docker-compose -f docker-compose.yml -f docker-compose.{env}.yml up 으로
# 오버라이딩 할 파일을 선택하여 실행한다.

version: "3.7"

services:
  app:
    # Dockerfile - FROM
    image: adoptopenjdk/openjdk8
    # Dockerfile - EXPOSE
    ports:
      - 8080:8080
    # network 추가
    networks:
      #      - default
      - boot-network
    # image build dir
    build:
      context: .
      # Dockerfile - ARG
    #  args:
    #    WAR-FILE: ${DEV_WAR_FILE}
    # Dockerfile - ENTRYPOINT
    entrypoint:
      - java
      - "-jar"
      - /app.war
    # Dockerfile - COPY command
#    command: "COPY ${WAR_FILE} app.war"
#    # link : 참조할 다른 컨테이너 연결 - application.yml 내 DB 연결 네이밍 참고.
#    links:
#      - db:Postgresql
#    # 종속성 정의. 여기에선 db 실행 후에 app 실행함을 의미.
#    depends_on:
#      - db
#  db:
#    # DB 이미지
#    image: postgres:12.9-alpine
#    # 포트 지정
#    ports:
#      - 5432:5432
#    # -e 환경 변수 : docker run 명령 참고
#    environment:
#      - POSTGRES_PASSWORD=1tkdlqjvpn!
#    # 볼륨 지정 : 디렉토리 마운팅
#    volumes:
#      - ${DEV_VOLUME_DIR}:/var/lib/postgresql/data

# Docker Network : boot-network 란 이름의 bridge 네트워크 추가
# {projectName}_{networkName} 으로 생성됨.
# 없으면, default 네트워크로 연결
networks:
  boot-network:
    driver: bridge
  #default:
  #  external:
  #    name: boot-sample-network
```

# 2. docker-compose.dev.yml - 개발 환경 정의 시 사용

```yml
# docker-compose.dev
# 개발 환경 정의
# 개발인 경우, postgresql docker 이미지를 띄워 사용한다.

version: "3.7"

services:
  app:
    # Dockerfile - COPY command
    command: "COPY ${DEV_WAR_FILE} app.war"
    # link : 참조할 다른 컨테이너 연결 - application.yml 내 DB 연결 네이밍 참고.
    links:
      - db:Postgresql
    # 종속성 정의. 여기에선 db 실행 후에 app 실행함을 의미.
    depends_on:
      - db
  db:
    # DB 이미지
    image: postgres:12.9-alpine
    # network 추가
    networks:
      #      - default
      - boot-network
    # 포트 지정
    ports:
      - 5432:5432
    # -e 환경 변수 : docker run 명령 참고
    environment:
      - POSTGRES_PASSWORD=${DEV_POSTGRES_PASSWORD}
    # 볼륨 지정 : 디렉토리 마운팅
    volumes:
      - ${DEV_VOLUME_DIR}:/var/lib/postgresql/data
```

# 3. .env 파일 - 환경변수가 정의되어있다.

```
# docker-compose 파일에 변수 할당하기 위한 설정 파일
# 각 환경 별로 사용할 변수 및 내용을 정의


# dev

DEV_WAR_FILE=build/libs/boot-sample-0.0.1-SNAPSHOT.war
DEV_VOLUME_DIR=/boot-sample-db
DEV_POSTGRES_PASSWORD={password}

# demo

DEMO_WAR_FILE=build/libs/boot-sample-0.0.1-SNAPSHOT.war
DEMO_VOLUME_DIR=/boot-sample-db
DEMO_POSTGRES_PASSWORD=

# prod

PROD_WAR_FILE=build/libs/boot-sample-0.0.1-SNAPSHOT.war
PROD_VOLUME_DIR=/boot-sample-db
PROD_POSTGRES_PASSWORD=
```

위와 같이 환경을 구성하게 되면 각 환경(개발/데모/운영 등)별로 compose 파일을 생성하여 docker-compose 구동 시, 재정의 하는 방식으로 구동하면 된다.

.env에 지정된 환경 변수들로 각 옵션에 맞게 넣어주게 되면 따로 구동 시에 환경변수를 재지정하거나 넣어줄 필요가 없다.

# Docker Network in Docker-compose

docker network 에 대해서는 아래의 링크를 참고.

- docker networking 개요

https://docs.docker.com/network/

- docker network plugin

https://ziwon.github.io/post/designing-scalable-portable-docker-container-networks/

우선 샘플 상에서 시도 했던

"도커 네트워크" 를 cli 환경에서 우선 생성 --> compose 에서 external 로 사용은 하지 않아도 된다.

네트워크를 compose 에 지정하는 경우 자동으로 찾거나, default netwrok 에 연결하기 때문이다. 다만, 생성을 하든 안하든 네트워크를 사용할 것이라면, 각 서비스마다 옵션으로 network 에 연결해주어야 한다.

1. db 서비스 네트워크 지정

![dockerboot3-2](/assets/img/Docker/dockerboot3-2.png)

2. app 서비스 네트워크 지정

![dockerboot3-3](/assets/img/Docker/dockerboot3-3.png)

네트워크 생성은 아래 라인을 참고한다.

```yml
# Docker Network : boot-network 란 이름의 bridge 네트워크 추가
# {projectName}_{networkName} 으로 생성됨.
# 없으면, default 네트워크로 연결
networks:
  boot-network:
    driver: bridge
  #default:
  #  external:
  #    name: boot-sample-network
```
