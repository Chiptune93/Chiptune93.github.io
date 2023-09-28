---
title: 11. CD - Jenkins Docker 이미지 빌드 및 자동 배포
categories: [Project, Jenkins CI/CD]
tags: [Personal Project, Jenkins, pipeline, blueocean, jenkins docker, jenkins github]
---


## 필요한 플러그인 설치


Blue Ocean, SSH Agent, Docker Pipeline 플러그인을 설치한다.

*   Blue Ocean

  *   파이프라인 시각화 도구

*   SSH Agent

  *   배포 서버에서 명령어 실행 시, 사용

*   Docker Pipeline

  *   Docker 문법을 이용하여 파이프라인 내에서 사용하기 위함


![](/assets/img/jenkins/attachments/26411178/26411193.png?width=340)

## 파이프라인 등록


등록한 프로젝트에서 ‘블루 오션 열기’ 를 통해 들어간다.

![](/assets/img/jenkins/attachments/26411178/26411201.png?width=340)

우측 상단의 ‘새로운 파이프라인’ 클릭.

![](/assets/img/jenkins/attachments/26411178/26411207.png?width=340)

파이프라인에서 깃헙 레파지토리를 연결한다.

연결할때는 액세스 토큰이 필요하며, 경고 문구와 같이 repos 와 user 권한이 필요하다.

![](/assets/img/jenkins/attachments/26411178/26476760.png?width=340)

권한 입력 후, 액세스가 완료되면 레파지토리를 선택한다.

![](/assets/img/jenkins/attachments/26411178/26411220.png?width=340)![](/assets/img/jenkins/attachments/26411178/26411214.png?width=340)

레파지토리 연결 후, 파이프라인 생성을 하면 jenkinsfile이 있는 경우에는 자동으로 해당 브랜치로 연결이 되고  
파일이 없는 경우에는 아래와 같이 설정 페이지로 이동하게 된다.

![](/assets/img/jenkins/attachments/26411178/26476754.png?width=340)

jenkinsfile의 경우, 브랜치에 직접 업로드 해도 되고 이 페이지에서 작성해도 상관 없다.  
어차피 브랜치에 올라가면 자동으로 인식하고 import 한다.

### Pipeline 구축하기


어차피 현재 환경은 홈 서버에 젠킨스가 존재하고 배포도 홈 서버에 할 것이기 때문에  
아래와 같이 절차를 가져가기로 했다.

### Jenkins 파일 이용한 빌드 과정 구축


*   Git Push를 트리거로 실행

*   소스 가져오기

*   빌드된 압축 파일(jar), dockerfile, docker-compose.yml 파일들을 배포 서버에 옮기기

*   배포 서버 내에서 docker run을 통해 배포하기


위 과정을 갖는 Jenkinsfile 및 dockerfile, docker-compose.yml 파일을 프로젝트 내부에 생성하고 그대로 푸시하면  
어차피 Git Push 트리거를 이용하기 때문에 자동 감지 후, 파이프라인을 실행할 것이다.

### 추가 플러그인 설치(선택)

파이프라인 내에서 내장 sshCommand → `sshCommand remote: remoteServer, command: command, returnStatus: true` 를 사용하려면  
**SSH Pipeline Steps 플러그인**이 필요하다.

![](/assets/img/jenkins/attachments/26411178/26836993.png?width=340)

참고 사이트 : [https://www.jenkins.io/doc/pipeline/steps/ssh-steps/](https://www.jenkins.io/doc/pipeline/steps/ssh-steps/)

보통 아래와 같이 사용한다.

```
...
def remote = [:]
remote.name = 'test'
remote.host = 'test.domain.com'
remote.user = 'root'
remote.password = 'password'
remote.allowAnyHosts = true
stage('Remote SSH') {
  sshCommand remote: remote, command: "ls -lrt"
  sshCommand remote: remote, command: "for i in {1..5}; do echo -n \"Loop \$i \"; date ; sleep 1; done"
}
...
```

작업하다보니, 이 플러그인은 패스워드를 요구하기 때문에 그냥 쓰지 않기로 했다. (패스워드 노출하거나 숨겨야 하는데 그게 더 일이다.)

### 파이프라인 작업 과정 구상

*   Springboot 프로젝트를 빌드하여 JAR 파일을 만든다.

*   Springboot Jar 파일과 dockerfile, docker-compose.yml 파일을 배포대상 서버에 옮긴다.

*   dockerfile을 이용하여 이미지를 생성한다.

*   생성된 이미지를 통해 docker compose로 서비스를 구동한다.


### Jenkinsfile

```
pipeline {
    agent any

    environment {
        IMAGE_NAME = "spring-example"
        REMOTE_NAME = "PipelineRemoteServer"
        REMOTE_HOST =  "chiptune.iptime.org"
        REMOTE_CREDENTIAL_ID = "chiptune"
        SOURCE_FILES = "build/libs/example-0.0.1-SNAPSHOT.jar, dockerfile, docker-compose.yml"
        REMOTE_DIRECTORY = "/jenkins/jenkins_deploy/springboot_example"
    }

    stages {

        // 프로젝트 빌드 및 테스트
        stage("CI: Project Build") {
            steps {
                sh "./gradlew clean build test"
            }
        }

        // 배포 대상 서버에 dockerfile, docker-compose 파일, JAR 파일 전달
        stage("CI: Transfer Files") {
            steps {
                script {
                    // SSH 플러그인을 사용하여 명령 실행
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: "${REMOTE_NAME}",
                                verbose: true,
                                transfers: [
                                    sshTransfer(
                                        execCommand: '', // 원격 명령 (비워둘 수 있음)
                                        execTimeout: 120000, // 명령 실행 제한 시간 (밀리초)
                                        flatten: false, // true로 설정하면 원격 경로에서 파일이 복사됩니다.
                                        makeEmptyDirs: false, // true로 설정하면 원격 디렉토리에 빈 디렉토리가 생성됩니다.
                                        noDefaultExcludes: false,
                                        patternSeparator: '[, ]+',
                                        remoteDirectory: "${REMOTE_DIRECTORY}",
                                        remoteDirectorySDF: false,
                                        removePrefix: '', // 원본 파일 경로에서 제거할 접두사
                                        sourceFiles: "${SOURCE_FILES}"
                                    )
                                ]
                            )
                        ]
                    )
                }
            }
        }

        // docker image build
        stage("CI: Docker Build") {
            steps {
                script {
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: "${REMOTE_NAME}",
                                verbose: true,
                                transfers: [
                                    sshTransfer(
                                        execCommand: """cd ~${REMOTE_DIRECTORY} && pwd && docker build -t ${IMAGE_NAME} ."""
                                    )
                                ]
                            )
                        ]
                    )
                }
            }
        }

        // docker compose 이용한 배포
        stage("CD : Deploy") {
            steps {
                script {
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: "${REMOTE_NAME}",
                                verbose: true,
                                transfers: [
                                    sshTransfer(
                                        execCommand: """cd ~${REMOTE_DIRECTORY} && docker compose stop && docker compose up -d --build"""
                                    )
                                ]
                            )
                        ]
                    )
                }
            }
        }
    }
}
```

젠킨스 파일을 만들고 레파지토리에 푸시를 하면 ..?

![](/assets/img/jenkins/attachments/26411178/26804230.png?width=340)

원격 서버 배포에 성공했다!

## 참고


[https://devbksheen.tistory.com/entry/Jenkins%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9C-Docker-%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88-%EC%9E%90%EB%8F%99-%EB%B0%B0%ED%8F%AC%ED%95%98%EA%B8%B0Blue-Ocean-NCP](https://devbksheen.tistory.com/entry/Jenkins%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9C-Docker-%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88-%EC%9E%90%EB%8F%99-%EB%B0%B0%ED%8F%AC%ED%95%98%EA%B8%B0Blue-Ocean-NCP)

[https://gogoonbuntu.tistory.com/95](https://gogoonbuntu.tistory.com/95)
