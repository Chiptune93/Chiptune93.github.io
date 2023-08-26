---
title: 사내 SMS Api Service
categories: [Etc, Project]
tags: [docker, springboot, Personal Project]
---

## 1. 개요

최근 사내 SMS 서비스 개발에 대한 필요성이 생겨서 해당 작업을 맡아서 하게 되었다. 물론 혼자 하는 것은 아니지만, 전반적인 계획과 어떻게 구성할지에 대해서는 다같이 고민을 하고 있어서 여기에다가도 올리면서 작업해보려고 한다.

서비스의 구성은 기본적으로 외부로 나가있는 자사 서비스에서 사내 SMS Service 쪽으로 전송 Request를 인증된 키와 함께 보내게 되고, 이를 서비스에서 받아 처리하는 구조이다.

따라서, Restful Api 기반으로 구조를 설계할 예정이며, 해당 서비스는 Docker 기반으로 가상화 하여 올려놓고 사용하고자 하는 큰 목표가 있다. SMS전송은 외부에서 도입한 에이전트가 담당하며 이와는 별개로 SMS 전송 이력이나 키 관리 등은 자체적으로 관리할 예정이다.

러프하게 그려본 구성도는 아래와 같다.

![2-1](/assets/img/Project/2-1.png)

구성 이외에도, 도커로 올릴 이미지 구성을 어떻게 할 지 또한 고민해봐야 하는 부분도 있어서 차근차근 진행해 볼 예정이다. 업무량도 많아서 제대로 진행 될리는 모르겠지만, 개인 프로젝트 겸 구성해보면 나중에 다른 작업에서도 참고가 되지 않을까 한다.

## 2. docker base 이미지 구축하기

SMS 서비스를 Docker 서버에 올릴 것이기 때문에 아래와 같이 구축 방향을 잡았다.

1. Docker centos7 버전 베이스 이미지를 받는다.
2. 해당 베이스에 SMS 에이전트 모듈을 옮긴다.
3. 세팅을 모두 마친 상태에서 해당 이미지를 다시 이미지화 하여 저장한다.
4. Spring Boot 프로젝트를 Jar 형식으로 빌드하여 Dockerfile을 통해 centos7 이미지를 베이스로 하는 이미지를 재가공 한다.
5. docker가 올라가 있는 서버에 해당 이미지를 넣고 운영한다.

Docker 이미지 구성 예시.

![2-2](/assets/img/Project/2-2.png)

SMS 에이전트가 들어간 서비스 이미지 구성 예시
centos7 베이스 이미지 작업.

docker pull 명령을 통해 이미지를 받고, sms 에이전트를 공유하여 서버에 세팅했다.

```
## centos 이미지 pull
$ docker pull centos:centos7

## sms 에이전트 경로를 공유하여 파일을 옮길 수 있도록 running 한다
$ docker run centos:centos7 -v {path}:/var/lib/smsagent --name centos7-with-agent

## 공유 볼륨의 경우, 실제 경로에서 변경이 일어나거나 삭제되는 경우
## 바로 컨테이너에 적용 되므로 실제 옮기는 용도로만 사용한다.

## 도커 내부 접속
$ docker exec -it centos7-with-agent /bin/bash
> cd /var/lib/
> cp -r smsagent /var/lib/smsAgent
```

버전관리를 위해 여기까지 작업한 OS 이미지를 이미지화 하였다.

```
## 실행 중인 컨테이너 상태 그대로 다시 이미지화 하기
$ docker commit {container-name}
sha256:6b2ec9b792e26a7c442176bd6c92b5061589d54d5a9f15a8831a89f38e2966e8

## 이미지 리스트에서 방금 만든 이미지에 대해 태그 지정
$ docker images -a
REPOSITORY              TAG       IMAGE ID       CREATED          SIZE
<none>                  <none>    6b2ec9b792e2   20 seconds ago   209MB

## 이미지 네임은 name:tag 형식으로 지정 및 다른 형식 가능.
$ docker tag 6b2ec9b792e2 {image-name}
```

이제, 이 이미지에다 Spring Boot를 올려야 한다.

올리기에 앞서 부트 환경에서 사용한 jdk 11을 해당 OS에 설치 한다.

```
## JDK11 설치
> yum install java-11-openjdk-devel.x86_64

> java -version
java-11-openjdk-devel
```

이제 OS 이미지는 준비가 끝났고, dockerfile을 작성하여 부트 프로젝트를 올릴 준비를 한다.

```dockerfile
FROM centos-with-agent:1.0 # 아까 만든 베이스 이미지 이름
EXPOSE 8080:8080 # 포트 설정
ARG JAR_FILE=build/libs/sms.jar # 부트 프로젝트 jar 파일
COPY ${JAR_FILE} sms.jar # 루트 경로로 옮김
CMD /var/lib/lguplus/bin/uagent.sh start && java -jar /sms.jar # 에이전트 실행 및 프로젝트 실행
## 본적으로 jar 파일 실행하여 돌리는 경우 아래와 같이 엔트리 포인트로
## 수를 주었지만, 여기서는 에이전트를 실행한 후, 돌려야 하기 때문에
## MD를 사용했다.
## NTRYPOINT [ "java", "-jar", "/sms.jar" ]
```

dockerfile 준비가 끝났으면 해당 파일 기준으로 이미지를 빌드한다.

```
$ docker build -t sms-service:1.0 .(도커파일있는경로)
```

그러면 이미지가 빌드되어 나오고 해당 이미지를 서버 도커로 옮겨서 실행하면 완료다.

생각보다 금방끝났다. 사실 중간에 에이전트를 세팅하면서 발생한 문자열 문제나 방화벽 허용 등과 같은 이슈는 제외하고 간략히 기술했다. 실제로 그런 부분이 문제가 되지 않았다는 가정하에 위 작업만 하면 사실 끝이기 때문에...

작업 중, 해당 서비스가 급하게 필요하다는 요청을 받아서 반나절을 거의 여기에 신경을 썼던것 같다. 근데 막상 막히는 부분만 넘고나니 생각보다 작업한게 많이 없어서 조금 아쉽다.

## 3. Swagger 를 활용한 API 가이드 공유

SMS 서비스 개발을 완료한 관계로 내부 공유 시에 문서 작성 및 기타 불편함을 덜기 위해 Swagger 로 공유하기로 하였다.

https://swagger.io/

해당 툴을 이용하면 API 공유를 쉽고 빠르게 할 수 있고 자체에서 테스트 또한 가능하기 때문에 무척 편리하다. 또한 yaml 형식 또는 json 형식으로 문서를 작성하면 변환하여 볼 수 있게끔 에디팅을 할 수 있는 툴을 제공한다.

https://editor.swagger.io/

내부 서비스의 공유 목적으로 작성된 Swagger 는 공유하지는 못하지만, 작성 후에 어떻게 하였는가에 대해 공유 한다.

Swagger 에서 작성한 문서들은 yaml 혹은 json 의 파일 형태로 공유가 가능하다. 따라서, 이 파일만 있으면 swagger를 구동시키거나 사이트에서 해당 문서를 로드하여 조회가 가능하다.

다만, 내부 공유 용으로 작성하는 문서인데 이를 일일히 파일을 받아서 열고 보라고 하기에는 불편한 상황이어서 다음과 같이 공유를 하였다.

1. 내부 Docker 서버에 swagger 를 구동 시킨다.
2. 구동 시, 작성한 파일을 물고 들어가 구동과 동시에 해당 파일을 로드한다.
   이렇게 하면 보는데 있어서 조금이나마 불편함을 덜 수 있을 것 같았다.

> Swagger Docker 구동 + 파일 같이 실행하기

```
docker run -d -p 5162:8080 -e SWAGGER_JSON=/tmp/syworks-sms-service.json -v /var/lib/docker-syworks-sms/:/tmp --name syworks-sms-swagger swaggerapi/swagger-ui
```

작성한 Swagger 파일을 서버내 경로로 옮긴 후, docker 쪽으로 옮기면서 파라미터로 실행 시키는 구동 스크립트이다.
이렇게 작성 후 , swagger 를 run 하면 접속만 해도 자동으로 해당 파일을 로드하여 조회 할 수 있다.
