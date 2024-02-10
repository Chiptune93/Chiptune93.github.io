---
title: Docker 로그 관리
categories: [Backend, Docker]
tags: [docker, docker log, 도커, 도커 로그]
---

# Docker 컨테이너 로그 용량 관리

Docker 컨테이너의 로그 용량 관리는 시스템의 성능과 안정성을 유지하는 데 필수적이다. 이번 글에서는 기존 방법에 더해 Docker Compose를 사용한 예시를 포함하여 컨테이너의 로그 용량을 확인하고 관리하는 방법을 자세히 살펴본다.

## 로그 파일 직접 접근하기

호스트 시스템의 `/var/lib/docker/containers/<container-id>/` 디렉토리 내에 저장된 `*.log` 파일을 통해 로그 파일의 용량을 직접 확인할 수 있다. Docker Compose 환경에서도 이 방법은 동일하게 적용된다:

```sh
sudo du -sh /var/lib/docker/containers/$(docker-compose ps -q <service_name>)/*-json.log
```

여기서 `<service_name>`은 Docker Compose 파일 내 정의된 서비스 이름이다. 이 명령은 해당 서비스의 컨테이너 로그 파일 용량을 확인하는 데 사용된다.

## `docker logs` 명령어 활용하기

`docker logs` 명령어로 로그를 출력한 후, 파일로 리다이렉트하여 로그의 용량을 확인할 수 있다. Docker Compose 환경에서는 다음과 같이 사용할 수 있다:

```sh
docker-compose logs <service_name> > temp_log.txt
du -sh temp_log.txt
```

이 방법은 Docker Compose를 사용하는 환경에서 특정 서비스의 로그 용량을 간접적으로 파악하는 데 유용하다.

## Docker Compose를 사용한 로그 설정 예시

Docker Compose를 사용할 때, `docker-compose.yml` 파일 내에서 로그 파일의 크기와 개수를 제한하는 설정을 추가할 수 있다. 이는 로그 용량 관리에 매우 효과적이다:

```yaml
version: '3'
services:
  web:
    image: nginx
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
```

이 설정은 `web` 서비스의 로그 파일 크기를 10MB로 제한하고, 로그 파일의 개수를 최대 3개로 유지한다.

## 로그 파일 크기 관리의 중요성

적절한 로그 파일 크기 관리는 Docker 환경의 성능과 안정성을 보장한다. 로그 로테이션(log rotation)과 로그 파일 크기 제한 설정은 필수적인 관리 방법 중 하나다. Docker Compose 환경에서도 이러한 로그 관리 전략을 쉽게 적용할 수 있다.

로그 파일을 직접 삭제하는 것은 권장되지 않으며, 가능한 Docker의 내장 기능을 통해 로그를 관리해야 한다. 이를 통해 Docker 환경을 더욱 깔끔하고 효율적으로 운영할 수 있다.
