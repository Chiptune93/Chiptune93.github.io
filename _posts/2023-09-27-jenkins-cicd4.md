---
title: 4. 실습 구상하기
categories: [Project, Jenkins CI/CD]
tags: [Personal Project, Jenkins, pipeline, blueocean]
---

구현 목표 1
-------

![](/assets/img/jenkins/attachments/25460737/25460752.png?width=224)

1.  IDE에서 작성된 코드를 깃에 올린다.

2.  깃에서는 젠킨스로 웹훅을 통해 요청한다.

3.  젠킨스에서 빌드 및 테스트를 실시 한다.

4.  ssh 통신을 통해 홈 서버에 JAR 파일을 복사하고, 실행한다.


작업해야 할 연동 구간
------------

1.  깃헙과 젠킨스

2.  젠킨스와 홈 서버


젠킨스에서 구성하고 싶은 파이프라인
-------------------

1.  빌드

2.  코드 검증(SonarLint)

3.  테스트

4.  무중단 배포(Rolling, Canary)


구현 목표 2
-------

![](/assets/img/jenkins/attachments/25460737/25493527.png?width=226)

1.  IDE에서 작성된 코드를 깃에 올린다.

2.  깃에서는 **홈서버 내 Docker 젠킨스**로 웹훅을 통해 요청한다.

3.  젠킨스에서 Docker 빌드 및 테스트를 실시 한다.

4.  Docker 이미지를 기반으로 홈 서버 Docker 에서 어플리케이션 컨테이러는 실행 시킨다.


작업해야 할 연동 구간
------------

1.  깃헙과 홈 서버 간의 통신

2.  Docker 내부 통신
