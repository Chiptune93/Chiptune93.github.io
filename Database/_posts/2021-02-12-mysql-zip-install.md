---
layout: post
title: MySQL - mysql-8.0.23-winx64.zip 설치 및 실행하기
description: >
    mysql-8.0.23-winx64.zip 설치 및 실행하기
sitemap: false
hide_last_modified: true
categories: [Database]
tags: [mysql, mysql install, mysql zip install]
---

- Table of Contents
{:toc .large-only}

## 1. MYSQL COMMUNITY SERVER ZIP 파일 다운로드
[dev.mysql.com/downloads/mysql/](dev.mysql.com/downloads/mysql/)

## 2. 다운받은 파일을 적당한 경로에 압축 해제 ( 이하 "경로" )
![mysqlzip1](/assets/img/Database/mysqlzip1.png)

## 3. cmd 창을 관리자 권한 실행 후, 설치 실행
![mysqlzip2](/assets/img/Database/mysqlzip2.png)

실행 후 "경로" 내 bin 폴더로 이동 ( 위 이미지 참고 ) 후

아래 명령어 순차 실행.

- mysql 초기화 실행 : mysqld --initialize ( 완료 시, "경로" 내 data 폴더가 생성됨 )
- mysql 설치 실행 : mysqld --install
- mysql demon 실행 : mysqld start 또는 net start mysql 

실행 후, 접속시 임시 발급된 루트 비밀번호를 사용하여야 함.

"경로" 내 data 폴더의 "컴퓨터이름.err" 내에 임시 비밀번호 사용.

![mysqlzip3](/assets/img/Database/mysqlzip3.png)


## 4. mysql 서비스 실행 후, root 접속 및 비밀번호 변경
임시비밀번호는 말그대로 임시이기 때문에 접속 후, root 패스워드를 변경해야 함.

- mysql 접속 : mysql -u root -p

발급된 임시비밀번호 입력하여 접속 후

alter user 'root'@'localhost' identified by '변경할비밀번호';

를 통해 비밀번호 변경.

## 5. 서비스 시작 및 종료 배치파일 생성
아래는 내 환경 기준의 배치파일 명령어.

관리자 권한으로 실행해야 함.

( 버전마다 다른건 지, 서비스 시작 할때 net start 명령어로 하여야 했음 )

- start
```bash
@echo off
D:
cd mysql-8.0.23-winx64\bin
net start mysql
```
- stop
```bash
@echo off
D:
cd mysql-8.0.23-winx64\bin
net stop mysql
```
