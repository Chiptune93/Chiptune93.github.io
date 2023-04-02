---

title: Oracle - 쿼리 내 조건 변수 또는 하드코딩 사이 속도 이슈 해결 (ojdbc7,8 download)
description: >
  Oracle - 쿼리 내 조건 변수 또는 하드코딩 사이 속도 이슈 해결 (ojdbc7,8 download)


categories: [Error]
tags: [Oracle, ojdbc, Error]
---



## 문제

1. 복잡한 쿼리 내 조건문에서 MyBatis #{변수} 처리된 구문이 존재.

2. 해당 쿼리가 SQL Developer 에서 실행하면 10분이상 소요, 하지만 Dbeaver 에서 실행 시, 1.13초 걸림.

3. 이는 프로젝트가 구동되는 서버에서도 동일하였음.

## 해결과정

1. 해당 변수를 하드코딩으로 바꾸자, 두 툴에서 전부 1초대 실행 시간이 나옴.

2. 변수로 실행 시, developer 에서만 느리다는걸 재확인.

3. 프로젝트 jdbc 드라이버 확인 결과 , ojdbc6 으로 확인됨.

4. developer jdbc 드라이버 확인 결과, ojdbc6 으로 확인됨.

5. Dbeaver 내 jdbc 드라이버 확인 결과, ojdbc8 로 확인됨.

## 해결

1. 프로젝트가 jdk 1.7 이어서, ojdbc7 로 드라이버를 바꾼 결과 구동 서버에서도 지연없이 잘 돌아가는 것을 확인.

## 결론

- 아무리 봐도 문제 없어 보이는데 변수처리된 조건문이 느리다면 JDBC 드라이버 버전을 높여보자!

( \* 정확한 원인을 몰라, 문제 원인을 설명하기가 어렵습니다. 다만 이렇게 해결하였으니 공유 하고자 올립니다 )

## ojdbc Download

[ojdbc7 download](/assets/file/Error/ojdbc7.jar)

[ojdbc8 download](/assets/file/Error/ojdbc8.jar)
