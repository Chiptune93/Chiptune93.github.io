---
title: 8. CI - Springboot Project 빌드하기
categories: [Project, Jenkins CI/CD]
tags: [Personal Project, Jenkins, pipeline, blueocean, jenkins docker, jenkins github]
---

## Jenkins 프로젝트 생성


‘Freestyle Project’ 로 생성

![](/assets/img/jenkins/attachments/26476651/26607765.png?width=340)

설정 내, Github Project 선택 및 주소 입력.

![](/assets/img/jenkins/attachments/26476651/26476672.png?width=340)

‘Git’ 섹션에서 레파지토리 주소 입력.

이후, ‘Credentials’ 항목에서 ‘Add’ 선택.

![](/assets/img/jenkins/attachments/26476651/26411108.png?width=340)

Credentials 팝업에서 아래와 같이 입력, 깃 계정을 통해 접근하는 권한을 획득하도록 한다.

![](/assets/img/jenkins/attachments/26476651/26411102.png?width=340)

이후, 아래 브랜치 설정(가져올 브랜치) 를 선택한다.

![](/assets/img/jenkins/attachments/26476651/26476684.png?width=340)

빌드 유발에서는 Github hook trigger 를 설정한다.

이후, 아래의 ‘Build Steps' 에서 단계를 추가한다. 해당 단계는 소스를 가지고 온 뒤 어떤 작업을 할지 정의하는 것이다.

![](/assets/img/jenkins/attachments/26476651/26607772.png?width=340)

빌드 스텝 추가 후, ‘invoke Gradle’ 클릭 후, 아래 Tasks 에서 `build`를 입력한다.

해당 Tasks 에는 어떤 작업을 할 것인지를 지정하는 것이다.

![](/assets/img/jenkins/attachments/26476651/26476690.png?width=340)

이후, 해당 프로젝트에서 ‘지금 빌드’ 를 클릭하면 방금 등록한 Step이 동작하게 된다.

해당 빌드가 성공/실패 하는지 지켜보고 실패한 경우 로그를 확인한다.

![](/assets/img/jenkins/attachments/26476651/26443904.png?width=340)

해당 빌드가 돌아간 후, 작업 결과물은 `jenkins_home/{projectName}/build/libs/` 내부에 위치하고 있다.

![](/assets/img/jenkins/attachments/26476651/26476666.png)

간혹 빌드에러가 나는 경우, 그래들 버전이 안맞는 것일 수 있다. 이런 경우

‘Dashboard’ → ‘Jenkins 관리’ → ‘Tools’ → ‘Gradle installations’ 에서 그래들 관련 설정을 할 수 있다.

여기서 알맞은 그래들 버전을 골라 설정 한 뒤에 해당 프로젝트로 가서 다시 지정해준다.

![](/assets/img/jenkins/attachments/26476651/26476678.png?width=340)

Gradle script 에서 방금 저장한 그래들을 추가해준다.

![](/assets/img/jenkins/attachments/26476651/26411096.png?width=340)

Github 레파지토리와의 연결이 완료되었다.
