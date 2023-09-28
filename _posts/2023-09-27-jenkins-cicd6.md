---
title: 6. 서버에 Docker Jenkins 구동하기
categories: [Project, Jenkins CI/CD]
tags: [Personal Project, Jenkins, pipeline, blueocean, jenkins docker, cicd]
---

## Jenkins 폴더 생성 및 Docker 올릴 준비

원하는 경로에 jenkins 폴더를 생성한다. 해당 공간이 jenkins 관련 작업을 할 공간으로 지정한다.  
그리고 아래의 2개 파일을 작성한다. dockerfile을 통해 이미지 지정 후, docker-compose를 통해 컨테이너를 올릴 것이다.

*   dockerfile


```
FROM jenkins/jenkins:lts

USER root 

RUN apt-get update && \
    apt-get -y install apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        zip \
        unzip \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y install docker-ce
```

*   docker-compose.yml


```
# docker-compose.yml
version: '3.7'

services:
  jenkins:
    build: 
      context: .
    container_name: jenkins
    user: root
    ports:
      - 9090:8080
      - 50000:50000
    volumes:
      - ./jenkins_home:/var/jenkins_home # 현재 경로 내 jenkins_home 과 연결
      - /var/run/docker.sock:/var/run/docker.sock # OS 내 docker.sock을 연결
```

이제 해당 파일을 저장 후, `docker compose up -d` 를 이용해 구동한다.

## 젠킨스 세팅 하기


구동이 완료되면, `localhost:9090` 을 통해 젠킨스에 접속한다.

![](/assets/img/jenkins/attachments/26607728/26443834.png?width=340)

여기서 패스워드를 요구하는데, 아까 생성한 jenkins\_home 폴더 내에 `/jenkins_home/secrets/initialAdminPassword` 를 열어보면 나오는 패스워드를 입력한다.

이후, 추천 플러그인으로 설치한다.

![](/assets/img/jenkins/attachments/26607728/26443840.png?width=340)

플러그인 설치가 진행된다.

![](/assets/img/jenkins/attachments/26607728/26443846.png?width=340)

설치가 완료되면 관리자 계정을 세팅한다.

![](/assets/img/jenkins/attachments/26607728/26443852.png?width=340)

Jenkins URL 지정이 나오는데, 그대로 해도 무방하다.

![](/assets/img/jenkins/attachments/26607728/26443858.png)

Docker를 이용하여 Jenkins 서버 구동이 끝났다.
