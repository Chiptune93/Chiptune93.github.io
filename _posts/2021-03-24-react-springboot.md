---

title: React - Spring boot + React 연계 프로젝트 생성하기
description: >
  Spring boot + React 연계 프로젝트 생성하기


categories: [Frontend]
tags: [React, springboot]
---



본 게시글은 다음 링크 게시글 참조를 통해 시도한 결과를 공유하는 글입니다 :D

[sundries-in-myidea.tistory.com/71﻿](sundries-in-myidea.tistory.com/71)

# 1. 개발환경 세팅

- STS 4 설치.

[spring.io/tools](spring.io/tools)

- node js 설치. ( react 및 npm 패키지 사용 )

[nodejs.org/ko/](nodejs.org/ko/)

- 본 글에서는 LTS 버전 설치.

## 2. 프로젝트 생성

- Spring Initializer 에서 프로젝트 생성 및 다운로드

dependency 에는 Spring Web 만 추가.

![react-spring1](/assets/img/React/react-spring1.png)

- 위 프로젝트 다운 시, JAVA 에 선택한 버전이 현재 윈도우에 환경 변수로 잡혀있어야 함. ( STS jre 버전 또한 동일하게 되어야 함 )

* 다운로드받은 프로젝트를 STS 에 프로젝트 import 하기.

![react-spring2](/assets/img/React/react-spring2.png)

# 3. Spring Boot 샘플 페이지 작성

- Spring Boot 내 테스트용 컨트롤러 작성.

![react-spring3](/assets/img/React/react-spring3.png)

이후, 해당 프로젝트를 런 시키고 매핑된 경로로 이동하면 http://localhost:8080/api/hello 접속 시 다음과 같이 보여짐.

![react-spring4](/assets/img/React/react-spring4.png)

# 4. React 설치

node.js 를 설치했다면 , cmd 창을 통해 workspace 경로로 가서 react 설치.

```
npx create-react-app {react프로젝트명}
```

이후, 다음 명령어를 통해 run 시키면 http://localhost:3000 으로 실행됨.

![react-spring5](/assets/img/React/react-spring5.png)

현재까지 구조는 다음의 형태를 가지고 로컬에서 동작 중임. 각자 다른 포트에서 실행중이기 때문에 localhost 에서 요청 시 CORS (cross-origin requests) 이슈가 발생함.

![react-spring6](/assets/img/React/react-spring6.png)

현재 목표는 해당 두 서비스를 연동시키는 것.

CROS 이슈를 해결하기 위해서는 front 쪽에서 proxy 설정을 잡아주어야 한다.

# 5. Spring Boot 와 React 연동하기

- React 내 package.json 에 다음 구문 추가.

![react-spring7](/assets/img/React/react-spring7.png)

- backend 의 컨트롤러를 통해 값을 받아오기 위한 React 코딩. ( App.js 내 수정 )

```js
import React, { useState, useEffect } from "react";
import logo from "./logo.svg";
import "./App.css";

function App() {
  const [message, setMessage] = useState("");

  useEffect(() => {
    fetch("/api/hello")
      .then((response) => response.text())
      .then((message) => {
        setMessage(message);
      });
  }, []);
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h1 className="App-title">{message}</h1>
      </header>
      <p className="App-intro">
        To get started, edit <code>src/App.js</code> and save to reload.
      </p>
    </div>
  );
}

export default App;
```

# 6. Spring Boot 와 React 앱을 함께 패키징 처리

- spring boot 프로젝트 pom.xml 내 plugins 태그 내 다음 추가

```xml
<plugin>
				<groupId>com.github.eirslett</groupId>
				<artifactId>frontend-maven-plugin</artifactId>
				<version>1.11.2</version>
				<configuration>
					<workingDirectory>worksheetfrontend</workingDirectory>
					<installDirectory>target</installDirectory>
				</configuration>
				<executions>
					<execution>
						<id>install node and npm</id>
						<goals>
							<goal>install-node-and-npm</goal>
						</goals>
						<configuration>
							<nodeVersion>v14.16.0</nodeVersion>
							<npmVersion>6.14.11</npmVersion>
						</configuration>
					</execution>
					<execution>
						<id>npm install</id>
						<goals>
							<goal>npm</goal>
						</goals>
						<configuration>
							<arguments>install</arguments>
						</configuration>
					</execution>
					<execution>
						<id>npm run build</id>
						<goals>
							<goal>npm</goal>
						</goals>
						<configuration>
							<arguments>run build</arguments>
						</configuration>
					</execution>
				</executions>
			</plugin>
```

- 여기서 node 의 버전과 npm 의 버전을 본인이 설치한 것과 동일하게 맞춰주어야 한다.
  버전 확인은 cmd 창을 열어 , npm version 으로 확인가능하다.

이후, cmd 창을 열어 프로젝트 경로로 이동한 후, 다음 명령어 실행하여 프로젝트 빌드.

```
mvnw clean install
```

실행 후에 react 폴더로 가보면 다음과 같이 build 폴더가 생성된다.

![react-spring8](/assets/img/React/react-spring8.png)

# 7. Spring Boot JAR 파일에 React Build 파일 포함 시키키

- Spring boot 프로젝트 내 pom.xml 의 plugins 태그 하위에 다음을 추가한다.

```xml
<plugin>
				<artifactId>maven-antrun-plugin</artifactId>
				<executions>
					<execution>
						<phase>generate-resources</phase>
						<configuration>
							<target>
								<copy todir="${project.build.directory}/classes/public">
									<fileset
										dir="${project.basedir}/{react프로젝트명}/build" />
								</copy>
							</target>
						</configuration>
						<goals>
							<goal>run</goal>
						</goals>
					</execution>
				</executions>
			</plugin>
```

- 이 상태에서 react 앱 폴더의 위치는 {springBoot프로젝트폴더}/{react프로젝트폴더} 이다. 즉, 프로젝트 폴더 하위에 포함되어있다.

이후, cmd 창을 열어 프로젝트 경로로 이동한 후, 다음 명령어 실행하여 다시 프로젝트 빌드.

```
mvnw clean install
```

# 8. 완료!

다 완료 되면, Spring boot 프로젝트 내 target 에 생성된 jar 파일을 실행하여 잘 돌아가는지 확인한다.

cmd 를 통하여 프로젝트 target 폴더 접근 후, 다음 명령어 실행하여 정상 실행되는 지 확인.

![react-spring9](/assets/img/React/react-spring9.png)

http://localhost:8080 에서 정상 실행되는지 확인!

![react-spring10](/assets/img/React/react-spring10.png)

성공!

이렇게 하면, 프론트는 react 로 개발하고, 백엔드는 Spring Boot 로 개발하면 따로따로 개발하여 하나의 서비스로 연동이 가능하다.
