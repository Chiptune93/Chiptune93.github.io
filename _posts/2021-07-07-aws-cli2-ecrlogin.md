---

title: AWS CLI 2.0 ECR get-login-password 인증 문제
description: >
  AWS CLI 2.0 ECR get-login-password 인증 문제


categories: [AWS]
tags: [AWS, ECR, ECR Login, get login password]
---



## 문제

AWS CLI 2.0 버전에서 aws ecr get-login-password 사용 시, 인증 구간에서 401 권한 없음 에러 발생.

## 해결

AWS CLI 계정이 MFA 인증 ( 구글 인증기 등 ) 을 사용 중이라면, 해당 인증 토큰 세션이 있어야 권한 에러가 발생하지 않음.

> 기본적으로 사용하려는 계정에 명령에 대한 권한이 있는지는 확인하여야 함. 그래도 안되서 아래와 같은 해결방법을 발견.

cli 에서 다음과 같이 명령 실행.

```bash
aws sts get-session-token --serial-number {AWS 계정} --token-code {인증기 발급 코드}
```

실행하면 Access Key / Secret Access Key / Session Token 이 발급된다.
해당 토큰은 12시간동안 유효하며 위 값을 가지고 aws credential profile 을 생성한다.

credential 파일 ( C:\Users\{user명}\.aws 내) 을 편집기로 열어 다음을 추가한다.

```credential
[default]
...

[{profile명}]
AWS_ACCESS_KEY_ID = {발급받은 액세스 키 값}
AWS_SECRET_ACCESS_KEY = {발급받은 시크릿 액세스 키 값}
AWS_SESSION_TOKEN = {발급받은 세션 토큰 값}
```

해당 profile 추가 후 명령을 실행한다.

```bash
aws ecr get-login-password --profile {입력한 profile명} --region {리전명} | docker login --username {AWS계정} --password-stdin {AWS패스워드}
```
