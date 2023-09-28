---
title: 3. Jenkins CI/CD 실습 환경 구성
categories: [Project, Jenkins CI/CD]
tags: [Personal Project, Jenkins, pipeline, blueocean]
---

## Jenkins 서버 구성


*   환경적인 자유로움 및 관리의 편함을 위해 Docker로 구성한다.

*   먼저 Mac 로컬에서 작업 후, 특정 작업 실습이 완료되면 홈 서버로 옮긴다.


## Docker Jenkins


*   amd64 환경인 Mac은 전용 이미지를 다운 받아야 한다.

    ```
    docker pull amd64/jenkins
    ```


macOS 및 Linux에서
---------------

1.  터미널 창을 엽니다.

2.  다음 명령을 사용하여 Docker에서 [브리지 네트워크를](https://docs.docker.com/network/bridge/) 만듭니다 `docker network create`.

    ```
    docker network create jenkins
    ```

3.  Jenkins 노드 내에서 Docker 명령을 실행하려면 `docker:dind`다음 `docker run`명령을 사용하여 Docker 이미지를 다운로드하고 실행하십시오.

    ```
    docker run --name jenkins-docker --rm --detach \
      --privileged --network jenkins --network-alias docker \
      --env DOCKER_TLS_CERTDIR=/certs \
      --volume jenkins-docker-certs:/certs/client \
      --volume jenkins-data:/var/jenkins_home \
      --publish 2376:2376 \
      docker:dind --storage-driver overlay2
    ```

4.  다음 두 단계를 실행하여 공식 Jenkins Docker 이미지를 사용자 지정합니다.

  1.  다음 콘텐츠로 Dockerfile을 만듭니다.

      ```
      FROM jenkins/jenkins:2.414.1-jdk17
      USER root
      RUN apt-get update && apt-get install -y lsb-release
      RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
        https://download.docker.com/linux/debian/gpg
      RUN echo "deb [arch=$(dpkg --print-architecture) \
        signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
        https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
      RUN apt-get update && apt-get install -y docker-ce-cli
      USER jenkins
      RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
      ```

  2.  이 Dockerfile에서 새 Docker 이미지를 빌드하고 이미지에 "myjenkins-blueocean:2.414.1-1"과 같은 의미 있는 이름을 할당합니다.

      ```
      docker build -t myjenkins-blueocean:2.414.1-1 .
      ```

      공식 Jenkins Docker 이미지를 아직 다운로드하지 않은 경우 위 프로세스에 따라 자동으로 다운로드됩니다.

5.  `myjenkins-blueocean:2.414.1-1`다음 명령을 사용하여 Docker에서 자체 이미지를 컨테이너로 실행합니다 `docker run`.

    ```
    docker run --name jenkins-blueocean --restart=on-failure --detach \
      --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
      --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
      --publish 8080:8080 --publish 50000:50000 \
      --volume jenkins-data:/var/jenkins_home \
      --volume jenkins-docker-certs:/certs/client:ro \
      myjenkins-blueocean:2.414.1-1
    ```


설치 후 진행
-------

### localhost:8080 으로 접속, Jenkins Unlock 진행. 패스워드는 아래 명령어를 통해 도커 내부 파일을 확인한다.

![](/assets/img/jenkins/attachments/24903735/25067521.png?width=204)

```
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```

### 플러그인 설치 진행, 처음에는 추천 플러그인으로 진행한다.

![](/assets/img/jenkins/attachments/24903735/25067527.png?width=204)

### 플러그인 설치가 진행된다.

![](/assets/img/jenkins/attachments/24903735/25067533.png?width=217)

### 설치가 완료되면, 관리자 계정 생성을 진행한다.

![](/assets/img/jenkins/attachments/24903735/25100289.png?width=217)

여기서는 맥 로컬이므로, chiptune / 1234 로 진행했다. 옆의 버튼을 보니, 스킵해도 되나보다.

### Jenkins URL 지정

![](/assets/img/jenkins/attachments/24903735/25067539.png?width=217)

로컬로 그대로 지정했다. (어차피 Docker 라서)

### 젠킨스 설정 완료 및 시작

이제 젠킨스 서비스를 시작할 수 있다.

![](/assets/img/jenkins/attachments/24903735/25133063.png)

추가 사항
=====

**Docker in Docker (DinD) 란?**
------------------------------

![](https://blog.kakaocdn.net/dn/bBdSOp/btrjjuDkbtb/hgXFD7YDh5F05wVUyPz9LK/img.png)

**도커 안에 도커라는 의미**이다.

도커 바이너리를 설정하고 컨테이너 내부의 격리된 Docker 데몬을 실행하는 작업

**CI 측면에서 접근한다면 job(task)을 수행하는 Executor(Agent)가 Docker Client와 Docker Daemon 역할까지 하게 되어 도커 명령을 수행하는데 문제가 없어진다.**

하지만, Docker 공식 입장은 DinD 사용하는 것을 권장하지 않는다.

단순하게 말하면, Host\_container가 Host\_machine에서 할 수 있는 거의 모든 작업을 할 수 있는 치명적인 결함이 있기 때문이다.

도커에서 사용하려면 실제 데몬을 동작시켜야 하기 때문에 도커 데몬에 추가 권한이 필요하다.

DinD 도커를 만들 때 명령을 살펴보면 --privileged 모드를 사용해 추가 권한을 부여하는 명령이 포함되어야 한다.

privilieged 플래그를 사용하면 Host\_container가 Host\_machine에서 할 수 있는 모든 작업을 할 수 있게 된다.

```
# docker run --privileged --name jadenpark_dind -d docker:19-dind
```

DinD DooD
---------

Jenkins CI 를 구성하는 중 Docker-compose를 실행하기 위해서는 Jenkins container 내부에 Docker를 다시한번 설치해야 한다는 것을 알았다.

도커가 컨테이너를 구성하기 위해서는 크게 2가지가 있음을 알았고 이를 정리한다.

DinD
----

![](/assets/img/jenkins/attachments/24903735/26607657.png)

도커 컨테이너 내부에서 도커를 실행하는 방식이다.

*   저체적인 캐시를 사용하게 되기 때문에 처음에는 빌드가 느리고 자신의 이미지 전체를 다시 끌어와야한다.

*   컨테이너가 특별한 권한을 가진 모드(`--privilige`)에서 실행되어야 하기 때문에 `DooD` 방법보다 안전하지 않다.

*   DinD는 `/var/lib/docker` 디렉토리를 위해 볼륨을 사용하는데 컨테이너를 제거할 경우 같이 제거하지 않으면 빠르게 사용 가능한 디스크 공간이 줄어들 수 있다.


### [Jenkins + DInD - Docker Hub](https://hub.docker.com/r/jpetazzo/dind)

DooD
----

> docker.sock은 클라이언트 데몬 간의 통신을 위한 엔드포인트를 말한다.

![](/assets/img/jenkins/attachments/24903735/26607663.png)

호스트 Docker 계층에서 실행하는 방식으로 `docker.sock`을 통해 데이터가 호스트 Docker로 전달된어 형제(sibling) 컨테이너로 구성되어진다.

```
docker run -it -p 8080:8080 --name <container_name> \ 
 * -v /var/run/docker.sock:/var/run/docker.sock
-v <your worksspace> : /var/jenkins_home
<image_name>:tag
```

*   **호스트 OS와 이미지 공유 가능**

*   이미지를 여러 번 저장하지 않아도 됩니다.

*   Jenkins가 로컬 이미지 생성을 자동화할 수 있도록 합니다.

*   감독자의 필요성 제거(여러 프로세스를 의미함)

*   가상화 계층(lxc) 제거

*   런타임에 더 큰 유연성을 허용합니다.

*   **젠킨스(sudo) 사용자가 접두사 docker없이 실행되도록 허용한다.**


여기서 핵심은 `docker.sock` `Volume`을 공유하는 것으로 컨테이너 내부에서도 저장된 Host 환경을 공유 할 수 구성한다는 점이다.

기본적으로 `/var/run/docker.sock` 파일을 통해 접근되는 IPC 소켓이지만, 도커는 네크워크 주소와 systemd 방식의 소켓으로 사용되는 TCP 소켓도 지원한다.

### [Jenkins + DooD - Docker Hub](https://hub.docker.com/r/psharkey/jenkins-dood)

DinD vs DooD
------------

그림에서 알 수 있듯이 사용자가 `Container`를 어디로 올리는 지에 따라 방향성이 다르다.

`Jenkins`의 `Execute Shell`로 Docker를 실행한다면 Jenkins Container 내부에 실행되고 있는 것이다.

`DinD`를 사용하는 주된 장점은 **애플리케이션 실행을 위한 격리된 환경을 제공**한다는 점 이지만 단점으로 `보안성`과 `디스크 용량`의 문제를 가지고 있어  
사용자가 신경써야할 부분이 많다.

DinD 사용지 발생하는 Error Log
-----------------------

1.  Docker 실행 및 연결 문제

    ```
    cannot connect to the docker daemon at unix:///var/run/docker.sock. is the docker daemon running?
    해결 -> sudo /etc/init.d/docker start
    
    system has not been booted with systemd as init system (pid 1). can't operate.
      해결 -> sudo /etc/init.d/docker start
    ```

2.  jenkins - Docker 권한 문제

    ```
    #  cd /etc/sudoers
    
    ## Allow root to run any commands anywhere
    root    ALL=(ALL)       ALL
    # 추가
    jenkins ALL=(ALL)       NOPASSWD: ALL
    ```


## Reference


*   [Cannot connect to the Docker daemon at unix:/var/run/docker.sock. Is the docker daemon running? - StackOverFlow](https://stackoverflow.com/questions/44678725/cannot-connect-to-the-docker-daemon-at-unix-var-run-docker-sock-is-the-docker)

*   [Execute Shell 명령어에서 sudo를 사용하기 위한 설정](https://velog.io/@livenow/Jenkins-Execute-Shell-%EB%AA%85%EB%A0%B9%EC%96%B4%EC%97%90%EC%84%9C-sudo%EB%A5%BC-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0-%EC%9C%84%ED%95%9C-%EC%84%A4%EC%A0%95)


## 어플리케이션 서버


젠킨스를 로컬에서 구동하여 진행하다가 실습이 완료되면 홈 서버에 젠킨스를 띄울 예정이다.

애플리케이션을 배포할 서버는 홈서버로 진행한다.

현재 홈 서버는 Docker가 설치되어 있으며, 디스코드 봇이 돌아가고 있다.

따라서, 실습 진행은 아래와 같이 할 예정이다.

1.  로컬 젠킨스를 통해 홈 서버에 스프링부트 애플리케이션 배포

2.  로컬 젠킨스를 통해 홈 서버 도커에 스프링 부트 애플리케이션 배포 및 실행

3.  홈 서버 도커 젠킨스 구동 및 1,2번 다시 수행
