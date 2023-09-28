---
title: 12. Python Bot Jenkins 자동화 배포 구축
categories: [Project, Jenkins CI/CD]
tags: [Personal Project, Jenkins, pipeline, blueocean, jenkins docker, jenkins github, cicd, python jenkins, python jenkins pipeline]
---



## Jenkins와 Github 연동


[Jenkins와 Github 연동](https://Chiptune93.github.io/posts/jenkins-cicd7)

## 블루오션 파이프라인 생성


### Repository에 Jenkinsfile 추가


파이프라인 생성 전에 추가해주어야 함.

파이프라인에서 레파지토리 연동 시, Jenkinsfile이 있는 브랜치를 인식해야 하기 때문.  
(파이프라인 생성 후, 레파지토리에 추가한 뒤, 다시 스캔해도 무관함)

```
pipeline {
    agent any

    environment {
        IMAGE_NAME = "remind_bot"
        REMOTE_NAME = "PipelineRemoteServer"
        REMOTE_HOST =  "chiptune.iptime.org"
        REMOTE_CREDENTIAL_ID = "chiptune"
        SOURCE_FILES = "Cogs/**/*, main.py, dockerfile, docker-compose.yml, requirement.txt"
        REMOTE_DIRECTORY = "/service/remind_bot"
    }

    stages {

        // 프로젝트 빌드 및 테스트
        stage("CI: Project Build") {
            steps {
                sh 'echo python build skiped. it will be build in docker.'
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

관리 문제 때문에 `prod` 브랜치를 새로 생성하고 해당 파일에만 Jenkinsfile을 넣고 브랜치 보호 전략을 걸었다(나만 가능하게)

### 레파지토리에 웹훅 추가


레파지토리에 푸시에 반응하도록 웹 훅을 추가한다.

![](/assets/img/jenkins/attachments/27164673/27426817.png?width=340)

### BlueOcean Pipeline 생성


Jenkins → ‘블루 오션 열기’ → ‘파이프라인 생성’ 을 통해 파이프라인을 생성한다.

레파지토리를 선택하면 자동으로 파이프라인 생성 후, 브랜치 인덱싱을 실행한다.

![](/assets/img/jenkins/attachments/27164673/27361281.png?width=340)

파이프라인 생성 후, 깃헙에 push를 하게되면 자동으로 빌드가 실행된다.

![](/assets/img/jenkins/attachments/27164673/27525123.png?width=340)

Jenkinsfile 이 있어, 손쉽게 생성하고 완료되었다!
