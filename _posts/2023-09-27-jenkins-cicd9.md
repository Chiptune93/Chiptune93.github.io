---
title: 9. CD - 빌드 후, 배포하기
categories: [Project, Jenkins CI/CD]
tags: [Personal Project, Jenkins, pipeline, blueocean, jenkins docker, jenkins github]
---

## 플러그인 설치 및 설정하기


특정 서버에 배포하기 위한 ‘Publish Over SSH’ 플러그인을 설치한다.

‘Dashboard’ → ‘Jenkins 관리’ → ‘Plugins’ 에서 검색하여 설치한다.

![](/assets/img/jenkins/attachments/26476703/26607805.png?width=340)

이후, Jenkins 관리 내 ‘System’ 설정으로 이동 후, 아래를 보면 SSH Server를 추가하는 설정이 있다.

![](/assets/img/jenkins/attachments/26476703/26411119.png?width=340)

여기에 ‘추가’ 를 눌러 아래와 같이 추가해준다.

*   Name: 자유롭게 지정

*   Hostname: 웹 서비스와 ssh가 세팅되어 있는 서버의 주소 (localhost는 젠킨스의 주소를 가리키므로 서버의 IP를 입력해주어야 한다.)

*   Username: ssh 접속 계정의 ID


이후, 아래의 ‘고급’ 을 눌러 확장 후에 **Use password authentication, or use a diffrent key**를 체크하면 추가 입력창이 나타난다.  
배포할 서버의 아이디/패스워드를 입력한다.

![](/assets/img/jenkins/attachments/26476703/26476718.png?width=340)

이후, 오른쪽 아래의 ‘Test Configuration’을 클릭하면 연결 테스트를 한다.

‘Success’ 가 뜨면 성공, 아니면 문제가 있는 것이다. (접근가능 여부를 파악해보자)

![](/assets/img/jenkins/attachments/26476703/26476724.png?width=340)

## 젠킨스 프로젝트에 배포 설정하기


배포하고자 하는 프로젝트의 설정에 들어가서 ‘Build Steps’를 보면, ‘빌드 후 조치’ 가 있다.

여기서 추가를 눌러 진행한다.

![](/assets/img/jenkins/attachments/26476703/26443921.png?width=340)

추가를 클릭하면 아래와 같이 콤보박스가 뜨는데, 여기서 ‘Send build artifats over SSH’ 를 클릭한다.

![](/assets/img/jenkins/attachments/26476703/26607798.png)

이후, 아래와 같이 입력한다. Name은 아까 생성한 서버를 선택하고

Transfers에서 상세 작업을 설정한다.

*   Source files

  *   젠킨스 프로젝트 이름까지의 경로가 기본으로 잡혀있다.

  *   (/var/jenkins\_home/workspace/\[프로젝트이름\]) 이후 build/libs 아래 생성되는 jar파일을 지정해준다. 와일드카드를 활용할 수 도 있다.(\*.jar)

*   Remove prefix

  *   위의 경로에서 소스 파일의 앞 경로를 입력해준다.

*   Remote directory

  *   젠킨스에서 SSH로 접속한 이후 소스 파일을 업로드할 경로를 지정한다. 기본으로 ssh 계정의 home 디렉토리를 본다. 아래 /deploy는 /home/jenkins-ssh/deploy와 같다.

*   Exec command

  *   Remote directory로 이동 후 여기에 입력되어있는 명령어를 실행한다. 입력창이 textarea로 되어있어 대각선 아래를 드래그하면 입력 창을 늘릴 수 있다.


![](/assets/img/jenkins/attachments/26476703/26607816.png?width=340)

여기서는 미리 작성한 빌드 스크립트 파일을 이용했다. 참고로 남기면 아래와 같다.

```bash
echo '> now running app find!'
CURRENT_PID=$(pgrep -f example)

echo "$CURRENT_PID"
if [ -z $CURRENT_PID ]; then
        echo '> no running app.'
else
        echo '> kill -9 $CURRENT_PID'
        kill -9 $CURRENT_PID
        sleep 3
fi

echo '> new app deploy'

JAR_NAME=$(ls |grep 'example' | tail -n 1)
echo "> JAR Name: $JAR_NAME"

echo '> run java'
nohup java -jar $JAR_NAME 1>log.out 2>err.out &
```

저장 후, 빌드를 해본다.

빌드 과정이 지나가고 마지막에 아래와 같은 로그에서 SUCCESS가 뜬다면 성공이다.

![](/assets/img/jenkins/attachments/26476703/26411125.png)
