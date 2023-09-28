---
title: 2. Jenkins CI/CD 사전학습
categories: [Project, Jenkins CI/CD]
tags: [Personal Project, Jenkins, pipeline, blueocean, cicd]
---

CI/CD란 무엇인가?
============

CI(Continuous Integration; 지속적 통합)
----------------------------------

*   코드의 통합을 말한다.

*   여러 베이스의 개발자 코드들을 하나로 모은다.


CD(Continuous Delivery/Deployment; 지속적 배달,배포)
---------------------------------------------

*   서비스의 배포를 의미한다.

*   끊김 없이 서비스에 개발된 코드를 배포할 수 있도록 하는 것이다.

    ![image](/assets/img/jenkins/attachments/24903681/25362433.png)

Jenkins 란 무엇인가?
===============

오늘날 젠킨스는 온갖 종류의 개발 작업을 지원하기 위한 약 1,400가지의 플러그인을 가지고 있는 선두적인 오픈소스 자동화 서버다.  
지속적인 통합과 지속적인 자바 코드 전달, 즉 프로젝트 빌드, 테스트 실행, 정적 코드 분석 시행, 그리고 배포 작업은 사람들이 젠킨스를 사용해 자동화하고 있는 여러 가지 프로세스들 가운데 한가지일 뿐이다.  
이 1,400개의 플러그인은 5가지 영역을 포괄하고 있다(플랫폼, UI, 관리, 소스코드 관리, 그리고 가장 많이 사용되는 빌드 관리).

기본 개념
-----

*   Java Runtime Environment에서 동작

*   다양한 플러그인들을 활용해서 각종 자동화 작업을 처리할 수 있다.

*   AWS 배포, 테스트, 도커 빌드 등 할게 너무 많으니 각각의 컴포넌트들을 하나의 플러그인으로 모듈화를 해놓았는데 이를 활용하여 사용하면 된다.

*   가장 핵심적인 파이프라인, 시크릿 키마저도 플러그인으로 동작시킬 수 있다.

*   즉 일련의 자동화 작업의 순서들의 집합인 Pipeline을 통해 CI/CD 파이프라인을 구축한다.

*   플러그인들을 잘 조합해서 돌아가게 하는 게 Pipeline이라고 할 수 있다.


Pipeline
--------

*   파이프라인이란 CI/CD 파이프라인을 젠킨스에 구현하기 위한 일련의 플러그인들의 집합이자 구성

*   즉 여러 플러그인들을 이 파이프라인에서 용도에 맞게 사용하고 정의함으로써 파이프라인을 통한 서비스가 배포된다.

*   Pipeline DSL(Domain Specific Langage)로 작성됨.

*   젠킨스가 동작되기 위해서는 여러 플러그인들이 파이프라인을 통해 흘러가는 과정이라고 할 수 있음


### Pipeline의 구성 요소

*   파이프라인이란 CI/CD 파이프라인을 젠킨스에 구현하기 위한 일련의 플러그인들의 집합이자 구성.

*   즉 여러 플러그인들을 이 파이프라인에서 용도에 맞게 사용하고 정의함으로써 파이프라인을 통해 서비스가 배포됨.

*   두 가지 형태의 Pipeline Syntax가 존재

  *   Declarative (더 최신이고 가독성이 좋음)

  *   Scripted Pipeline


### Pipeline의 Section

#### Agent section

*   젠킨스는 많을 일을 해야 하기 때문에 혼자 하기 버겁다.

*   여러 slave node를 두고 일을 시킬 수 있는데, 이처럼 어떤 젠킨스가 일을 하게 할 것인지를 지정한다.

*   젠킨스 노드 관리에서 새로 노드를 띄우거나 혹은 docker이미지를 통해 처리할 수 있다.

*   쉽게 말하면 젠킨스를 이용하여 시종을 여러 명 둘 수 있는데 어떤 시종에게 일을 시킬 것이냐 하는 것을 결정하는 것이다.

*   예를 들어 젠킨스 인스턴스가 서버 2대에 각각 떠있는 경우, 마스터에서 시킬 것인지 slave에서 시킬 것인지를 결정할 수 있다.

*   젠킨스 노드만 넣을 수 있는 것이 아니라 젠킨스 안에 있는 docker container에 들어가서 일을 시킬 수도 있다.

*   "nodejs안에서 뭔가를 해"라고도 명령을 시킬 수 있다.


#### Post section

*   스테이지가 끝난 이후의 결과에 따라서 후속 조치를 취할 수 있다.

*   각각의 단계별로 구별하면 다음과 같다.

*   성공 시에 성공 이메일, 실패하면 중단 혹은 건너뛰기 등등, 작업 결과에 따른 행동을 취할 수 있다.


#### Stage Section

*   어떤 일들을 처리할 것인지 일련의 stage를 정의한다.

*   일종의 카테고리라고 보면 됨.

*   ex) 프론트엔드 배포를 위한 스테이지, 등


#### Steps Section

*   한 스테이지 안에서의 단계로 일련의 스텝을 보여줌.

*   Steps 내부는 여러 가지 스텝들로 구성되며 여러 작업들을 실행 가능

*   플러그인을 깔면 사용할 수 있는 스텝들이 생겨남

*   빌드를 할 때 디렉터리를 옮겨서 빌드를 한다던가, 다른 플러그인을 깔아서 해당 플러그인의 메서드를 활용해서 일을 처리한다던지 하는 작업들을 할 수 있다.

*   플러그인을 설치하면 쓸 수 있는 Steps들이 많아진다.


### **파이프라인 구문 개요**

다음 파이프라인 코드 뼈대는 Declarative와 Scripted의 근본적인 차이를 설명한다.

"stage"와 "steps"는 Declarative와 Scripted에서 모두 공통적임을 유의하자.

#### **Declarative 파이프라인 기본**

선언적 파이프라인 구문에서, pipeline 블록은 전체 파이프라인 내내 완료된 모든 작업을 정의한다. 

```
Jenkinsfile (Declarative Pipeline)
pipeline {
    agent any //1
    stages {
        stage('Build') { //2
            steps {
                // 3
            }
        }
        stage('Test') { //4
            steps {
                // 5
            }
        }
        stage('Deploy') { //6
            steps {
                // 7
            }
        }
    }
}
```

1.  이용가능한 agent가 이 파이프라인 또는 파이프라인의 어느 스테이지를 실행한다.

2.  "Bulid" 스테이지를 정의한다.

3.  빌드와 관련된 몇가지 스텝을 수행한다.

4.  "Test" 스테이지를 정의한다.

5.  테스트와 관련된 몇 가지 스텝을 수행한다.

6.  "Deploy" 스테이지를 정의한다.

7.  배포와 관련된 몇 가지 스텝을 수행한다.


#### **Scripted 파이프라인 기초**

스크립트 파이프라인 구문에서, 하나이상의 node 블럭이 핵심 작업을 파이프라인 내내 수행한다. 비록 스크립트 파이프라인 구문의 의무적인 요구는 아니지만, 파이프라인의 작업을 node 블록 내부로 제한하면 두 가지 작업이 수행된다.

*   Jenkins 대기열에 항목을 추가하여 실행할 블록에 포함된 단계를 예약한다. 실행기가 노드에서 사용가능하게 되면 단계가 실행된다.

*   소스 제어에서 체크 아웃된파일에서 작업을 수행할 수 있는 작업공간을 만든다.


```
Jenkinsfile(스크립트된 파이프라인)
node {  //1
    stage('Build') { //2
        // 3
    }
    stage('Test') { //4
        // 5
    }
    stage('Deploy') { //6
        // 7
    }
}
```

1.  사용 가능한 에이전트에서 이 파이프라인 또는 해당 단계를 실행합니다.

2.  빌드 단계를 정의한다. stage 블록은 스크립트 파이프라인 구문에서 선택 사항이다. 그러나 stage 스크립팅된 파이프라인에서 블록을 구현하면 Jenkins UI에서 각 단계의 작업/단계 하위 집합을 더 명확하게 시각화할 수 있다.

3.  빌드와 관련된 몇 가지 단계를 수행한다.

4.  "테스트" 단계를 정의한다.

5.  테스트와 관련된 몇 가지 단계를 수행한다.

6.  "배포" 단계를 정의한다.

7.  배포와 관련된 ~


#### **선언적 파이프라인 예시**

```
Jenkinsfile(선언적 파이프라인)
pipeline { 
    agent any 
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build') { 
            steps { 
                sh 'make' 
            }
        }
        stage('Test'){
            steps {
                sh 'make check'
                junit 'reports/**/*.xml' 
            }
        }
        stage('Deploy') {
            steps {
                sh 'make publish'
            }
        }
    }
}
```

**Jenkinsfile (Declarative)**
-----------------------------

파이프라인은 젠킨스 Web UI나 젠킨스 파일로 정의해 사용할 수 있다.

젠킨스파일은 파이프라인의 정의를 포함하고 소스 제어에 체크인되는 Text 파일이다. 다음 예시 코드는 기본 3단계 지속적 전달(Continous Delivery) 파이프라인을 구현한다.

```
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
```

모든 파이프라인에 위의 3단계가 있는 것은 아니지만, 이를 정의하는 것이 좋다. 위의 Declarative(선언적) 파이프라인 예제에는 CD 파이프라인을 구현하는데 필요한 최소한의 구조가 포함되어 있다.

**agent**

"agent" 키워드는 반드시 있어야 하며, 파이프라인에 대한 수행 및 작업 공간을 할당한다. agent가 없으면 선언적 파이프라인이 유효하지 않으며, 어떠한 작업도 수행할 수 없다. 기본적으로 이 지시문은 소스 Repository가 체크아웃되고 후속 단계에서 사용할 수 있도록 한다.

### **Build**

일반적으로 프로젝트에서 파이프라인의 작업 시작은 "빌드"단계이다.

파이프라인의 이 단계는 소스코드가 어셈블, 컴파일, 또는 패키징 되는 곳이다. 젠킨스파일은 GNU/Make, 메이븐, 그래들같은 존재하는 빌드 툴 대체재가 아니다.  그러나 많은 구문 프로젝트의 개발 생명주기와 함께 (빌드, 테스트, 배포 등) 접착제 층처럼 보여질 수 있다 .

```
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'make' //1
                archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true //2
            }
        }
    }
}
```

> 1) sh 단계는 make 명령을 호출하고 명령에 의해 0 종료 코드가 반환되는 경우에만 계속된다. 0이 아닌 종료 코드는 파이프라인에 실패한다.
>
> 2) archiveArtifacts포함 패턴 (\*\*/target/\*.jar)과 일치하여 빌드된 파일을 캡쳐하고 나중에 검색할 수 있도록 jenkins 컨트롤러에 저장한다.

### **Test**

자동화된 테스트를 실행하는 것은 성공적인 CD 프로세스의 중요한 구성 요소이다. 따라서 Jenkins에는 여러 플러그인에서 제공하는 테스트 기록, 보고 및 시각화 기능이 많이 있다. 기본적인 수준에서 테스트 실패 시, 웹 UI에서 보고 시각화를 위해 Jenkins가 실패를 기록하도록 하는 것이 좋다.

```
pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                /* `make check` returns non-zero on test failures,
                * using `true` to allow the Pipeline to continue nonetheless
                */
                sh 'make check || true' //1
                junit '**/target/*.xml' //2
            }
        }
    }
}
```

> 1) 인라인 셀 조건부(sh 'make check || true')를 사용하면 sh 단계에서 항상 0 종료 코드를 확인하여 Junit 단계에 테스트 보고서를 캡쳐하고 처리할 수 있는 기회를 제공한다.
>
> 2) Junit 포함 패턴(\*\*/target/\*.xml)과 일치하는 Junit XML 파일을 캡쳐하고 연결한다.

### **Deploy**

배포는 프로젝트 또는 팀 요구 사항에 따라 다양한 단계를 의미할 수 있으며 빌드된 아티팩트를 Artifactory 서버에 게시하는 것부터 코드를 Production에 넘기는 것 까지 될 수 있다.

```
pipeline {
    agent any

    stages {
        stage('Deploy') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' //1
              }
            }
            steps {
                sh 'make publish'
            }
        }
    }
}
```

> 1) currentBuild.result 변수에 access 하면 파이프라인에서 테스트 실패가 있는지 확인할 수 있다. 

**Jenkinsfile 작업**
------------------

*   젠킨스 파일 안의 특정 파이프라인 구문

*   어플리케이션 또는 파이프라인 프로젝트를 빌드하기 위한 필수 파이프라인의 특징과 기능


### **환경 변수 사용**

젠킨스 파이프라인은 전역 변수를 통해 환경 변수를 노출한다. 이 변수 **env**는 젠킨스파일 안에 어디서든 사용할 수 있다.

환경 변수의 전체 목록은 **${JENKINS\_URL}/pipeline-syntax/globals#env**에 문서화되어 있으며 다음을 포함한다.

*   **BUILD\_ID**

*   **BUILD NUMBER**

*   **BUILD TAG**

*   **BUILD URL**

*   **EXECUTOR\_NUMBER**

*   **JAVA\_HOME**

*   **JENKINS\_URL**

*   **작업 이름**

*   **NODE\_NAME**

*   **작업 공간의 절대 경로**


이러한 환경 변수를 참조하거나 사용하는 것은 Groovy Map의 키에 access하는 것처럼 수행될 수 있다.

```
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
            }
        }
    }
}
```

### **환경 변수 설정**

젠킨스 파이프라인 내에서 환경 변수를 설정하는 것은 Declarative / Scripted에 따라 다르게 수행된다.

```
pipeline {
    agent any
    environment { //1
        CC = 'clang'
    }
    stages {
        stage('Example') {
            environment { //2
                DEBUG_FLAGS = '-g'
            }
            steps {
                sh 'printenv'
            }
        }
    }
}
```

> 1) environment 최상위 pipeline 블록에 사용된 지시문은 파이프라인 모든 단계에 적용된다.
> 2) stage에 정의된 environment 지시문은 환경 변수를 주어진 stage내에서 사용할 수 있게 한다.

### **자격 증명 처리 (Handling Credentials)**

**※ Secret Text**

아래 예제에선 두 개의 보안 텍스트 자격 증명이 AWS에 액세스하기 위해 별도의 환경 변수에 할당된다.

```
pipeline {
    agent {
        // Define agent details here
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }
    stages {
        stage('Example stage 1') {
            steps {
                // 1
            }
        }
        stage('Example stage 2') {
            steps {
                // 2
            }
        }
    }
}
```

> 젠킨스는 비밀 정보가 공개될 위험을 줄이기 위해 "\*\*\*\*\*\*"만 반환한다. 콘솔 출력 및 모든 로그, 자격 증명 ID 자체의 모든 민감한 정보도 파이프라인 실행 출력에서 "\*\*\*\*\*"로 나간다.
>
> 신뢰할 수 없는 파이프라인 작업이 신뢰할 수 있는 자격 증명을 사용하도록 허용하지 말도록 한다.
