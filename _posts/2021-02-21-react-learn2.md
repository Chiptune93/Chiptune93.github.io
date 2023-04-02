---
title: 2회차 - CSS 코딩 ~ 배포하기
categories: [Frontend]
tags: [React]
---

![react2-1](/assets/img/React/react2-1.png)

## Task

1. 각 컴포넌트 별로 src 경로 아래에 작성. 이후 html > js > css 순으로 import 되어 구조를 이룸.

2. 빌드 및 배포

3. npm run build : 빌드 명령 > 소스들을 압축하여 build 라는 폴더로 리턴해줌.

4. 로컬 상황에서 배포하기 ( serve 라는 로컬 서버 )

   - react-project 경로) npm(npx) install -g serve : serve 설치.

   - react-project 경로) npx serve -s build : serve 설치 및 기동 , build 폴더를 root 디렉토리로 지정후 실행.

> 로컬 주소를 리턴 > 접속하면 배포된 것 확인 가능.

실제 운영상황에서도 빌드 폴더 내 있는 내용을 웹 루트 디렉토리에 위치시키고 기동하면된다.

> 2회차 끝.
