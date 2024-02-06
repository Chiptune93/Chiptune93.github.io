---
title: "fatal: could not read Username for 'https://github.com': Device not configured"
categories: [Etc, Error]
tags: [git, credential, git error]
---

## 에러 내용

```bash
fatal: could not read Username for 'https://github.com': Device not configured
```

적절한 자격증명 헬퍼가 구성되지 않은 로컬 상황에서 Git 을 Push 하려는 경우, 계정 정보를 요청하게 되는데
자격 증명에 대한 구성이 존재하지 않거나, 요청할 수 없는 상황인 경우 일반적으로 발생하는 문제.

깃에서는 https://git-scm.com/docs/gitcredentials 를 통해서, 자격증명을 로컬에 하드코딩 할 수 있게 안내 하고 있다.

## 해결 방법

1. 자격증명방식 조회

```bash
$ git config credential.helper
osxkeychain
```

- 위 명령 실행 후, 위와 같이 osxkeychain 이 뜨지 않는다면 아래 명령을 통해 설정.

```bash
$ git config credential.helper osxkeychain
```

2. 키 체인에 인증 정보 등록

```bash
$ git credential-osxkeychain store
```

- 위 명령어 실행 시, 터미널에 아무 반응이 없는 것 처럼 보이는데 입력 상태로 들어간 것이다. 이 상태에서 아래의 정보를 입력한다.

```bash
host=github.com  
protocol=https  
username={github Id}
password={github Personal Access Token}
```

다 입력하면 Enter 2번을 입력하여 빠져나온다. 이후, push를 시도한다.
