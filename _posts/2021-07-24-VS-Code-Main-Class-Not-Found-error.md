---
title: VS Code Main Class Not Found Exception 해결
categories: [Etc, Error]
tags: [VsCode, Main Class Not Found]
---

### 문제

VS Code 에서 Spring Boot Gradle Project 를 개발하는 도중, 작업 환경을 데스크탑에서 노트북으로 옮겼는데, 이상하게도 데스크탑 환경에서 잘만 돌아가는 소스들이, 노트북 환경에서는 돌아가지 않았다.

### 오류 현상

현상은 VS Code 내 Spring DashBoard 에서 프로젝트 실행 시, Main Class 를 찾지 못하는 현상이었다. 검색해서 아래와 같은 시도를 해보았다.

1. Clean Java Language Server Workspace
2. launch.json 삭제
3. VsCode 종료 후 재실행하기 - 의외로 이 부분에서 해결되는 문제들이 많음.
4. 재부팅

위 방법으로도 안되서 찾던 중, 다음과 같은 내용의 글을 찾았다.

> "main class not found 에러는, 지정된 경로 혹은 작업 환경 내 모든 경로 상에서 해당 클래스 파일을 찾지 못했다는 의미이다. 따라서, 해당 파일이 있는 경로 상에 해당 클래스가 있는지 또는 기본 클래스 네임으로 생성되어 있는지를 확인하여야 하며, 경로 상에 띄어쓰기나 한글 등이 있는지를 확인해야 한다"

여기서 불현듯 머리에 스쳐지나간건 ... 노트북에 윈도우를 깔고 구성 시에 "One Drive" 설정을 해놓았던 것이다.

OneDrive 백업 설정을 하게되면 바탕화면의 경로가 기존

- "C:\user\{user명}\desktop\" 에서
- "C:\user\{user명}\One Drive\바탕 화면\ 으로 되어버린다.

해당 경로 상에 띄어쓰기와 한글이 존재해버린다는 것... 따라서 바로 아래 글을 따라 One Drive 백업 설정 및 로그인 해제를 진행했다.

[https://kakao777.tistory.com/3930﻿](https://kakao777.tistory.com/3930)

그렇게 하니까.. 너무너무 잘 실행된다.

저와 똑같은 삽질을 하고 계신 분들에게 도움이 되기를 바랍니다.
