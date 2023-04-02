---
layout: post
title: Docker Application build Python 에러 해결
description: >
  [MS 자습서] Docker Application build Python 에러 해결

hide_last_modified: true
categories: [Docker]
tags: [Docker, python, docker build]
---

- Table of Contents
{:toc .large-only}

https://docs.microsoft.com/ko-kr/visualstudio/docker/tutorials/your-application

Docker 자습서를 통해 공부하던 도중 2장 애플리케이션 만들기에서 에러가 발생하였다.

docker 빌드 도중 에러가 발생하였으며, 에러 내용은 다음과 같았다.

```
Can't find Python executable "python", you can set the PYTHON env variable.
```

파이썬 내부 경로 혹은 지정된 변수를 찾지 못하는 에러 같은데. 기존에 맥북에 깔려있던 것은 기본으로 설치되어있던 2.7 버전 이었다. 하지만 조금 검색하다보니 맥에서 현재 2.7 버전을 권장하지 않으며 버전을 업그레이드 하라는 내용이 있어 3.10으로 업그레이드 후, 기본 파이썬 알리아스를 3.10 대로 잡아놓은 상황이었다.

이 상황에서 Docker 빌드 시, 에러가 발생하여 구글링을 하여 다음과 같은 내용의 글을 찾았다.

https://github.com/docker/getting-started/issues/124

```
docker build command fails on yarn install step with error "gyp ERR! find Python" · Issue #124 · docker/getting-started

I'm trying to follow the getting-started tutorial on a Raspberry Pi 4 with Debian 10 installed, but I'm running into some issues. I think they might be related to using the arm architecture...

github.com
```

아마 M1 프로세서로 올라오면서 무언가 변경점이 생긴 듯 했다. 그리고, 자습서에서 제공하는 기본 코드의 경우에 파이썬이 포함되지 않아? 발생하는 문제 같아보인다. apk add 구문이 추가된 것으로 볼 때, 그럴 가능성이 있다고 생각했다.

하여 기존에 설치한 파이썬 3.10버전을 제거하고 다시 2.7버전 대로 내려와 빌드 하니 정상 동작 했다. 구문 상에서 3.10버전 대로 진행하면 이상하게 또 안된다...

> 2022.01.10 빌드 성공 코드

- Dockerfile

```dockerfile
FROM node:12-alpine
RUN apk add --no-cache python2 g++ make
WORKDIR /app
COPY . .
RUN apk --no-cache --virtual build-dependencies add \
  python2 \
  make \
  g++
RUN yarn install --production
CMD ["node", "src/index.js"]
```
