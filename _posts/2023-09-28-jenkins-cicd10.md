---
title: 10. CI - Git Push 시, 자동 Jenkins 빌드 수행하기
categories: [Project, Jenkins CI/CD]
tags: [Personal Project, Jenkins, pipeline, blueocean, jenkins docker, jenkins github]
---

## Github Repository에 Webhooks 추가하기


프로젝트 레파지토리 접속 → ‘Settings’ → ‘Webhooks’ 에 들어가 추가한다.

![](/assets/img/jenkins/attachments/26443933/26443948.png?width=340)

*   Payload URL : "[http://본인의Jenkins주소/github-webhook/](http://본인의Jenkins주소/github-webhook/)"

*   당연히 외부에서 접근 가능하도록 방화벽 설정 등이 열려 있어야 한다. 방화벽이나 기타 설정으로 인해 접근 제한이 걸려져 있다면 다음 IP를 허용 하면 된다.


```
"192.30.252.0/22"
"185.199.108.0/22"
"140.82.112.0/20"
```

참고 : [https://api.github.com/meta](https://api.github.com/meta)

![](/assets/img/jenkins/attachments/26443933/26443958.png?width=340)

이후 나머지는 그대로 두고 추가한다.

## Jenkins 플러그인 Github Intergration 설치


젠킨스 플러그인 중 Github Intergration을 설치한다.

![](/assets/img/jenkins/attachments/26443933/26411139.png?width=340)

## 프로젝트에 빌드 유발 항목 설정하기


프로젝트에 구성 설정으로 이동하여 ‘빌드 유발’ 항목에 ‘Github hook trigger for GITScm polling’ 항목에 체크한다.

![](/assets/img/jenkins/attachments/26443933/26411145.png?width=340)

적용 설정 테스트 하기
------------

테스트로 코드를 수정 후, Git에 Push 해본다.

![](/assets/img/jenkins/attachments/26443933/26443964.png?width=340)

에러가 발생했을 때, 웹훅에 가서 트러블 슈팅이 가능하다.

나같은 경우, 홈 서버에 접근 설정이 되어있지 않아서 iptime에서 방화벽 허용 및 포트 포워딩 등을 해주었다.

![](/assets/img/jenkins/attachments/26443933/26443971.png?width=340)

이후, 다시 푸시한 결과 빌드가 자동으로 되는 것을 확인할 수 있었다!

![](/assets/img/jenkins/attachments/26443933/26411152.png?width=340)
