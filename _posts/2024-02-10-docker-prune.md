---
title: Yaml Value to List Object
categories: [Backend, Docker]
tags: [docker, docker prune, prune]
---

# Docker에서 사용하지 않는 리소스 정리하기

Docker를 사용하다 보면 시스템에 사용하지 않는 리소스가 쌓이게 된다. 이러한 리소스는 시스템의 공간을 불필요하게 차지하며, `prune` 옵션을 통해 간단히 정리할 수 있다. `prune` 옵션은 컨테이너, 이미지, 볼륨, 네트워크 등 다양한 리소스에 적용될 수 있다.

## 컨테이너 정리

사용하지 않는 컨테이너를 정리하려면 다음 명령어를 사용한다:

```sh
docker container prune
```

이 명령은 실행 중이지 않은 모든 컨테이너를 제거한다.

## 이미지 정리

사용 중이지 않은 이미지를 정리하는 명령어는 다음과 같다:

```sh
docker image prune
```

모든 사용하지 않는 이미지를 삭제하려면 `-a` 옵션을 추가한다:

```sh
docker image prune -a
```

## 볼륨 정리

참조되지 않는 볼륨을 정리하려면 다음 명령을 실행한다:

```sh
docker volume prune
```

이 명령은 사용 중인 볼륨을 제외한 모든 볼륨을 제거한다.

## 네트워크 정리

사용하지 않는 네트워크를 정리하고 싶다면 다음 명령어를 사용한다:

```sh
docker network prune
```

이 명령은 사용 중이지 않은 네트워크를 제거한다.

## 시스템 전체 정리

Docker 시스템에서 사용하지 않는 모든 리소스를 한 번에 정리하려면, 다음과 같이 실행한다:

```sh
docker system prune
```

보다 광범위한 정리를 원한다면 `-a` 옵션을 추가한다:

```sh
docker system prune -a
```

