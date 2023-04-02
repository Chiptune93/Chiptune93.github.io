---
title: Docker CentOS7 locale language ko_KR 설정
categories: [Docker]
tags: [Docker, Centos7, locale, lang]
---

docker에서 centos7 이미지를 받아 작업 진행 중 발생한 상황에 대한 기록이다.

1. Docker CentOS7 이미지를 pull 받아 실행.

2. char-set 을 euc-kr 로 설정해야되는 상황 발생

3. locale -a | grep ko 로 세팅 가능한 캐릭터 셋 조회 시 ko 관련 값이 없음.

centos7 이미지

https://hub.docker.com/_/centos

## 해결

- docker centos7 이미지 내 경로 중, /etc/yum.conf 파일 내 아래 구문 존재.

> override_install_langs=en_US.utf8
> 이 라인의 의미는 기본적으로 설치되는 언어 팩을 제한하는 듯한 느낌을 받음.

해당 라인을 주석 처리 하고 아래 라인을 실행.

```
# 재설치
yum reinstall glibc-common
```

그러면 기본적으로 대부분의 언어팩이 자동으로 깔리며, ko_KR.utf8 과 ko_KR.eucKR 또한 포함된다.
