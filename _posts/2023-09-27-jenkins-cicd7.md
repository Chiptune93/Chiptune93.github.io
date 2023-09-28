---
title: 7. Jenkins와 Github 연동
categories: [Project, Jenkins CI/CD]
tags: [Personal Project, Jenkins, pipeline, blueocean, jenkins docker, jenkins github, cicd, github jenkins, git jenkins]
---

## Github 에서 액세스 토큰 생성


‘Settings’ → ‘Developer Setting’ → ‘Personal access tokens’ 에서 토큰 생성

![](/assets/img/jenkins/attachments/26476632/26443882.png?width=340)

아래 2개의 권한을 추가한 토큰을 생성

![](/assets/img/jenkins/attachments/26476632/26443889.png?width=340)

생성된 토큰을 기억해 놓자.

Jenkins 에 Github 서버 추가하기
------------------------

‘Jenkins 관리’ → ‘System’ 에 들어간다.

![](/assets/img/jenkins/attachments/26476632/26443895.png?width=340)

내리다보면 Github 섹션이 있다. ‘Add Github Server’ 를 추가한다.

![](/assets/img/jenkins/attachments/26476632/26411070.png?width=340)

정보를 입력 후, ‘Credentials’ 의 ‘Add’ 버튼을 클릭한다.

그리고 아래와 가이 정보를 입력하고, Secret 에는 아까 발급받은 토큰 값을 입력한다.

![](/assets/img/jenkins/attachments/26476632/26607752.png?width=340)

해당 인증을 추가한 후, 밖에서 ‘Test Connection’ 을 클릭해서 연결을 테스트하면 문제가 없는 경우 아래와 같이 나온다.

![](/assets/img/jenkins/attachments/26476632/26607758.png?width=340)

이렇게 하면 Jenkins와 Github의 연동이 완료되었다.
