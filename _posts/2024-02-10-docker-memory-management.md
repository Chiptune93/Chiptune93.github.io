---
title: Docker 용량 관리
categories: [Backend, Docker]
tags: [docker, docker log, 도커, 도커 로그]
---

# Docker에서 공간 확보하기

Docker를 사용하면서 `docker/containers` 경로의 용량이 과도하게 증가하여
문제가 발생했다. 이를 해결 하면서 찾은 내용을 간략히 기록한다.

## 1. 불필요한 컨테이너 삭제

Docker의 공간을 정리하는 가장 기본적인 방법은 사용하지 않는 컨테이너를 삭제하는 것이다. 다음 명령어를 사용하여 모든 컨테이너를 확인한 후, 필요 없는 컨테이너를 제거할 수 있다:

```sh
docker ps -a
docker rm <container_id_or_name>
```

더욱 간편하게, `docker container prune` 명령어를 사용하여 모든 정지된 컨테이너를 한 번에 삭제할 수도 있다.

## 2. 컨테이너 로그 파일 크기 제한 설정

컨테이너의 로그 파일 크기가 커지는 것을 방지하기 위해, 로그 파일의 크기와 개수를 제한할 수 있다. 이는 컨테이너를 생성할 때 로그 옵션을 설정하여 수행할 수 있으며, 다음과 같이 설정할 수 있다:

```sh
docker run -d --name <container_name> --log-opt max-size=10m --log-opt max-file=3 <image>
```

## 3. 실행 중인 컨테이너의 로그 파일 크기 제한 설정 변경

이미 실행 중인 컨테이너의 로그 설정을 변경하려면, 해당 컨테이너를 중지하고 삭제한 뒤, 변경된 로그 설정을 적용하여 컨테이너를 재생성해야 한다. 이 과정은 다소 번거로울 수 있으나, 로그 파일 관리를 위해 필요한 경우가 있다.

## 4. Docker Compose를 사용한 로그 파일 크기 제한 설정

Docker Compose를 사용하는 환경에서는 `docker-compose.yml` 파일에 로그 설정을 추가하여 컨테이너 로그 파일의 크기와 개수를 제한할 수 있다. 예를 들어, 다음 설정은 로그 파일의 최대 크기를 10MB로, 최대 개수를 3개로 제한한다:

```yaml
version: '3.8'
services:
  your-service-name:
    image: your-image-name
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
```

`docker-compose up -d` 명령을 사용하여 이 설정을 적용하면, 새로운 로그 설정이 적용된 컨테이너가 생성된다.

