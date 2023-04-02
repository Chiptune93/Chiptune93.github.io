---

title: npm 설치 후, start 시 에러 해결
description: >
  npm 설치 후, start 시 에러 해결


categories: [Error]
tags: [npm, npm start error]
---



```
npm missing file 'package.json'
npm missing script start
```

등과 같이 경로를 못찾는 듯한 에러가 발생하였다.

검색 결과, "생활코딩" 강의에서는 npm 을 C에 깔고, create-react-app 프로젝트 또한 바탕화면에 세팅했기 때문에
VS Code 에서 터미널 접속 시, 기본으로 바탕화면을 잡아주어서 'npm start' 명령어가 먹혔다.

하지만 위 명령어가 제대로 실행되려면, create-react-app 을 통해 만들 react 프로젝트의 경로 내에서 해당 명령어를 실행해야 제대로 실행되고, 자동으로 창이 열리게 된다.

> npm start 실행은 , create-react-app 을 통해 만든 프로젝트 경로에서 실행한다.
