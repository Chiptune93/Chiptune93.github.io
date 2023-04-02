---

title: Docker 자습서 정리
description: >
  MS : Docker 자습서 정리


categories: [Docker]
tags: [Docker, MS docker self study]
---



# 1부 : 시작

> 컨테이너?

컨테이너는 앱을 빌드하고 실행하기 위한 플랫폼을 제공하지만 전체 운영 체제의 전체 크기와 오버헤드가 없는 VM(가상 머신)과 같은 소규모 가상화 환경입니다.
간단히 말하면 컨테이너는 호스트 머신의 다른 모든 프로세스로부터 격리된, 사용자 머신의 또 다른 프로세스입니다.

> 컨테이너 이미지?

컨테이너를 실행하는 경우 컨테이너는 격리된 파일시스템을 사용합니다. 이 사용자 지정 파일시스템은 컨테이너 이미지 에서 제공됩니다. 이미지에는 컨테이너 파일 시스템이 포함되어 있으므로 애플리케이션을 실행하는 데 필요한 모든 것(모든 종속성, 구성, 스크립트, 이진 파일 등)이 있어야 합니다. 또한 이미지에는 환경 변수, 실행할 기본 명령, 기타 메타데이터와 같은 컨테이너의 다른 구성도 포함되어 있습니다.

> docker 실행명령

```
docker run -d -p 80:80 docker/getting-started
```

- -d : 백그라운드에서 분리 모드로 컨테이너를 실행.
- -p : 호스트의 포트 80을 컨테이너 포트 80에 연결

# 2부 : 애플리케이션

앱 컨테이너 이미지 빌드, 빌드를 위해선 Dockerfile 이란게 필요하다.

> Dockerfile?

Dockerfile은 컨테이너 이미지를 만드는 데 사용되는 텍스트 기반 명령 스크립트

```dockerfile
FROM node:12-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "/app/src/index.js"]
```

- Apple M1 환경에서는 python 문제가 있어 아래 내용으로 빌드하였다.

```dockerfile
FROM node:12-alpine
RUN apk add --no-cache python2 g++ make
WORKDIR /app
COPY . .
RUN apk --no-cache --virtual build-dependencies add \
  python2 \
  make \
  g++
RUN yarn install --production
CMD ["node", "src/index.js"]
```

> Docker Image 빌드 명령

```
docker build -t getting-started .
```

-t : 태그 네임 지정, 사람이 읽을 수 있도록 하는 최종 이미지 이름을 지정한다.

> Docker Image Run 명령

```
docker run -dp 3000:3000 getting-started
```

# 3부 : 앱 업데이트

CLI를 사용한 컨테이너 제거

> Docker 조회

```
docker ps
```

> Docker Stop

```
# Swap out <the-container-id> with the ID from docker ps
docker stop <the-container-id>
```

> Docker 제거

```
docker rm <the-container-id>
```

docker rm 명령에 “force” 플래그를 추가하면 단일 명령으로 컨테이너를 중지하고 제거할 수 있습니다.
예: docker rm -f <the-container-id>

# 4부 : 앱 공유

> 이미지 푸시 - Docker Hub

Docker Hub 에 Docker 계정으로 로그인하여 레파지토리 생성.

빈 상태의 레파지토리가 만들어지며, 이 곳에 이미지를 푸시 할 수 있음.

```
$ docker push docker/getting-started
The push refers to repository [docker.io/docker/getting-started]
An image does not exist locally with the tag: docker/getting-started
```

첫 이미지를 푸시하게 되면, 다음과 같은 문구가 뜨는데 이는 이미지에 이름이 지정되지 않아 발생하는 문제. 따라서 빌드한 이미지를 레파지토리에 올리기 위해서는 레파지토리와 동일하게 네이밍을 해주어야 한다.

> CLI - Docker Login

```
docker login -u <username>
```

> Image Name 지정하기

```
docker tag getting-started <username>/getting-started:<tagname>
```

> Image Push

```
docker push <username>/getting-started:<tagname>
```

tagname은 지정하지 않으면 latest 로 올라간다.

> 새 인스턴스에서 이미지 실행하기

새로운 환경에서 이미지를 pull 받아 실행해본다.

Play With Docker 라는 사이트에서 새로운 환경을 구성하여 테스트.

![dockerself1](/assets/img/Docker/dockerself1.png)

위 처럼 3000배지가 뜨면 running이 성공적으로 이루어 진 것. 이후 해당 배지 클릭을 통해 구동 중인 모습을 확인 가능하다.
\*\* Apple M1 칩을 사용하는 모델의 경우 Docker 이미지 빌드 시, 해당 호스트의 환경인 linux/arm64/v8 로 빌드되게 된다. 따라서 위 사이트에서 이미지를 구동하기 위해서는 Docker build 명령 시 "--platform linux/amd64" 키워드를 추가하여 빌드하면 해당 환경으로 빌드된다.

# 5부 : 데이터 유지

> 컨테이너 파일 시스템

컨테이너는 실행 시 이미지의 다양한 계층을 파일 시스템에 사용합니다. 또한 각 컨테이너에는 파일을 만들거나 업데이트하거나 제거할 수 있는 자체 “스크래치 공간”이 할당됩니다. 같은 이미지를 사용하는 ‘경우에도’ 다른 컨테이너에는 변경 내용이 표시되지 않습니다.

> 컨테이너 볼륨

컨테이너의 특정 파일 시스템 경로를 호스트 머신에 다시 연결하는 기능.
다른 컨테이너 혹은 재시작 후에도 동일한 경로로 탑재하면 똑같이 표시된다.

> Named Volume(명명된 볼륨)

명명된 볼륨은 단순히 데이터 버킷으로 생각하면 됩니다.
Docker에서 디스크 상의 실제 위치를 유지 관리하므로 볼륨 이름만 기억하면 됩니다.

> 볼륨 생성

```
docker volume create <volume-name>
```

> 컨테이너 시작 시, 볼륨 탑재

```
docker run -dp 3000:3000 -v <volume-name>:<탑재할 데이터 경로> <image-name>
```

이런 식으로, 볼륨을 사용하여 컨테이너가 종료되어도 데이터가 유지되게끔 설정할 수 있습니다.

- 기본 Docker 엔진 설치에서 지원되는 두 가지 기본 볼륨 유형이지만 NFS, SFTP, NetApp 등을 지원하는 데 사용할 수 있는 많은 볼륨 드라이버 플러그 인이 있습니다.

> 볼륨 확인하기

```
docker volume inspect <volume-name>
```

Mountpoint가 디스크에서 데이터가 저장되는 실제 위치입니다.

\*\* Docker Desktop에서 실행되는 동안 Docker Desktop의 볼륨 데이터에 직접 액세스 하는 Docker 명령은 실제로 머신의 작은 VM 내에서 실행됩니다. Mountpoint 디렉터리의 실제 내용을 확인하려면 먼저 VM 내부에 액세스해야 합니다. WSL 2에서는 WSL 2 배포판 내에 있으며, 파일 탐색기를 통해 액세스할 수 있습니다.

# 6부 : 바인드 탑재 사용

바인드 탑재 를 사용하면 호스트의 탑재 지점을 정확하게 제어할 수 있습니다. 이 유형은 데이터 유지뿐 아니라 컨테이너에 추가 데이터를 제공하는 데에도 사용됩니다. 애플리케이션 작업 시 바인드 탑재를 사용하여 소스 코드를 컨테이너에 탑재하면 변경 내용을 즉시 확인할 수 있으며, 컨테이너가 코드 변경을 확인하고 응답하게 할 수 있습니다.

예시로 확인.

```
docker run -dp 3000:3000 -w /app -v ${PWD}:/app node:12-alpine sh -c "apk add --no-cache python2 g++ make && apk --no-cache --virtual build-dependencies add python2 make g++ && yarn install && yarn run dev"
```

- -w /app - 컨테이너 내의 작업 디렉터리
- -v ${PWD}:/app" - 컨테이너에 있는 호스트의 현재 디렉터리를 /app 디렉터리로 바인드 탑재합니다.
  바인드 탑재 사용은 로컬 개발 설정에서 ‘매우’ 일반적입니다. 개발 머신에 모든 빌드 도구와 환경을 설치할 필요가 없다는 이점이 있기 때문입니다. 단일 docker run 명령을 사용하면 개발 환경이 풀되어 바로 사용할 수 있습니다.

> 바인드 마운트 vs 볼륨

- 바인드 마운트의 경우, 호스트의 디렉터리를 러닝 시, 마운트하여 바로 사용하게끔 함. 따라서, 수정이 일어나도 바로바로 반영됨
  ( 외부 리소스를 추가하여 바로 확인이 가능 )

- 볼륨의 경우, 호스트의 디렉터리를 도커의 볼륨 영역으로 가지고 와 볼륨을 생성하여 해당 볼륨을 컨테이너에 마운트한다.
  ( 도커의 볼륨 영역에서 제어가 되기 때문에 외부에서 바로 추가할 수 없다 )
  --> 그러면 추가해야 하는 경우에는 어떻게?

> 볼륨이 바인드 마운트보다 좋은 장점 From Docker Docs

1. 백업하거나 이동시키기 쉽다.

2. docker CLI 명령어로 볼륨을 관리할 수 있다.

3. 볼륨은 리눅스, 윈도우 컨테이너에서 모두 동작한다.

4. 컨테이너간에 볼륨을 안전하게 공유할 수 있다.

5. 볼륨드라이버를 사용하면 볼륨의 내용을 암호화하거나 다른 기능을 추가 할 수 있다.

6. 새로운 볼륨은 컨테이너로 내용을 미리 채울 수 있다.

# 7부 : 다중 컨테이너 앱

> 컨테이너 네트워킹

같은 네트워크 대역에 있는 컨테이너 앱 끼리는 상호간 통신 규약에 따라 통신이 가능하다.

> MySQL 연결하기

Docker Network 생성

```
docker network create <network-name>
```

> MySQL 컨테이너 실행 및 Network 연결

```dockerfile
docker run --platform linux/x86_64 -d \
--network <network-name> --network-alias mysql \
-v todo-mysql-data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=secret \
-e MYSQL_DATABASE=todos \
```

mysql:5.7

- 여기서는 todo-mysql-data라는 볼륨 이름을 사용하고, MySQL에서 데이터를 저장하는 위치인 /var/lib/mysql에 볼륨을 탑재합니다. 그러나 docker volume create 명령을 실행한 적은 없습니다. Docker에서 명명된 볼륨을 사용하려는 의도를 인식하고 자동으로 볼륨을 만듭니다.

> MySQL 컨테이너 상태 확인

```
docker exec -it <mysql-container-id> mysql -p
```

> 실행 중인 컨테이너와 MySQL에 연결하기

네트워킹 문제 해결 또는 디버그에 유용한 ‘많은’ 도구가 포함된 nicolaka/netshoot 컨테이너를 사용

netshoot 컨테이너 실행

```
docker run -it --network todo-app nicolaka/netshoot
```

> MySQL 컨테이너 주소 확인

```
dig mysql
```

“ANSWER SECTION”에서 mysql에 대해 A 레코드가 표시되며, 172.23.0.2로 확인됩니다(사용자 IP 주소는 다른 값일 가능성이 높음). mysql는 일반적으로 유효한 호스트 이름이 아니지만, Docker에서 해당 네트워크 별칭을 가진 컨테이너의 IP 주소로 확인할 수 있었습니다(앞에서 사용한 --network-alias 플래그 참조).

따라서 앱이 mysql이라는 호스트에 연결하기만 하면 데이터베이스와 통신할 수 있습니다.

> MySQL 과 앱 컨테이너 연결

해당 정보를 바탕으로 환경변수에 MySQL 정보를 지정하여 연결 실행

```bash
docker run -dp 3000:3000 \
  -w /app -v ${PWD}:/app \
  --network todo-app \
  -e MYSQL_HOST=mysql \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=secret \
  -e MYSQL_DB=todos \
  node:12-alpine \
  sh -c "apk add --no-cache python2 g++ make && apk --no-cache --virtual build-dependencies add python2 make g++ && yarn install && yarn run dev"
```

앱 러닝 후, 접속하여 몇개의 아이템을 저장합니다. 이후, 다시 MySQL을 실행하여 데이터 베이스를 확인하면 todo에서 입력한 데이터들이 저장되는 것을 확인할 수 있습니다.

# 8부 : Docker Compose 사용

Docker Compose는 다중 컨테이너 애플리케이션을 정의하고 공유할 수 있도록 개발된 도구입니다. Compose에서 서비스를 정의하는 YAML 파일을 만들고, 단일 명령을 사용하여 모두 실행하거나 모두 종료할 수 있습니다.

Compose를 사용할 경우의 ‘중요한’ 이점은 파일에서 애플리케이션 스택을 정의하고 프로젝트 리포지토리 루트에 파일을 저장하여(이제 버전 제어 사용) 다른 사용자가 프로젝트에 참여하기 쉽게 만들 수 있다는 것입니다.

- mac용 docker desktop을 설치하였다면, 별도로 설치할 필요가 없다.

```
docker-compose version
```

위 명령어를 실행하여 버전이 보인다면 설치가 되어 있는 것이다.

> Docker Compose 파일 만들기

프로젝트 루트에 docker-compose.yml 이라는 파일 생성하여 다음과 같이 지정

```yml
# 스키마 버전 정의. 최신을 사용하는 것이 가장 좋다.
version: "3.7"

# 서비스 목록 정의
services:
  # 앱 서비스 정의
  app:
    # 컨테이너 이미지 이름 정의
    image: node:12-alpine
    # 실행하고자 하는 명령어
    command: sh -c "apk add --no-cache python2 g++ make && apk --no-cache --virtual build-dependencies add python2 make g++ && yarn install && yarn run dev"
    # 포트 정의 ( host 3000 을 container 3000으로 마이그레이션 )
    ports:
      - 3000:3000
    # 작업 디렉토리와 볼륨 매핑을 마이그레이션
    # 파일이 위치한 곳 기준으로 상대경로를 사용할 수 있다.
    working_dir: /app
    volumes:
      - ./:/app
    # 환경변수를 이용한 DB 세팅.
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: secret
      MYSQL_DB: todos
  # MySQL 서비스 정의
  mysql:
    # 이미지 이름 정의
    image: mysql:5.7
    # docker run 으로 실행할 때는 자동으로 volume 이 설정되었지만
    # 여기서는 자동이 아니므로 경로를 지정해준다.
    # 이름 : 경로 로 지정해주며, 여기서 지정된 이름을 바깥 volumes 에서 탑재하여 사용한다.
    volumes:
      - todo-mysql-data:/var/lib/mysql
    # 환경변수 지정
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: todos
volumes:
  todo-mysql-data:
```

> 애플리케이션 스택 실행

위와 같이 설정을 끝냈으면, 이제 실행을 하면 된다.

docker-compose.yml 파일이 있는 경로에서 실행.

```
docker-compose up -d
```

아래와 같은 내용이 뜨면 성공한 것이다.

```
Creating network "app_default" with the default driver
Creating volume "app_todo-mysql-data" with default driver
Creating app_app_1 ... done
Creating app_mysql_1 ... done
```

해당 러닝 로그를 아래 명령어로 확인.

```
docker-compose logs -f
```

아래와 같이 표기가 된다면 러닝에 성공한 것이다.

```
mysql_1  | 2019-10-03T03:07:16.083639Z 0 [Note] mysqld: ready for connections.
mysql_1  | Version: '5.7.27'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
app_1    | Connected to mysql db at host mysql
app_1    | Listening on port 3000
```

> 실행 중인 앱 스택 확인

vscode에서 docker 확장을 보면 스택 확인이 가능하다.

이로써 docker compose 를 통해 mysql과 앱을 네트워킹으로 연결하여 서비스를 올리는데 성공하였다.

> 종료하기

모두 종료할 준비가 되었으면 docker-compose down을 실행하거나 VS Code Docker 확장의 컨테이너 목록에서 애플리케이션을 마우스 오른쪽 단추로 클릭하고 Compose 종료 를 선택합니다. 컨테이너가 중지되고 네트워크가 제거됩니다.

# 9부 : 이미지 계층화

> 이미지 계층 확인

```
docker image history <image-name>
```

이미지에 쓰인 계층들을 확인할 수 있다. 맨 위가 최신 계층 이며 이를 통해 각 계층의 용량 등을 쉽게 파악 할 수 있다.

> 계층 캐싱

Dockerfile의 각 명령이 계층이 되는것 임을 확인 했으니, 계층이 변경 될 때 마다 종속성을 다시 설치하는 것은 비효율 적이므로, 이를 줄이기 위한 방법을 적용해야 함.

예제에서는 node에서 종속성을 갖는 package.json 파일을 복사하여 설치 한 후, 나머지를 그 이후에 복사하여 package.json만 변경 점이 있을 때 다시 설치하도록 변경함.

```dockerfile
FROM node:12-alpine
RUN apk add --no-cache python2 g++ make
WORKDIR /app
# 종속성 카피
COPY package.json yarn.lock ./
 COPY . .
RUN apk --no-cache --virtual build-dependencies add \
  python2 \
  make \
  g++
RUN yarn install --production
COPY . .
CMD ["node", "src/index.js"]
```

> 다단계 빌드

런타임 종속성과 빌드 시간 종속성 구분
앱을 실행하는 데 필요한 ‘항목’만 제공하여 전체 이미지 크기 축소

Maven/Tomcat 예제

```dockerfile
# 첫번째 단계. 빌드단계에서만 JDK 필요, 여기서 수행.
FROM maven AS build
WORKDIR /app
COPY . .
RUN mvn package

# 두번째 단계. 빌드된 결과물을 톰캣 디렉터리로 복사.
# 이 단계가 마지막이므로, 최종 빌드되는 이미지는 이 단계의 결과물임.
FROM tomcat
COPY --from=build /app/target/file.war /usr/local/tomcat/webapps
```

React 예제

```dockerfile
# 첫번째 단계. 이 단계에서 빌드 수행
FROM node:12 AS build
WORKDIR /app
COPY package* yarn.lock ./
RUN yarn install
COPY public ./public
COPY src ./src
RUN yarn run build

# 두번째 단계. 이 단계에서 nginx에 빌드된 결과물을 옮김.
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
```

즉, 빌드 단계에만 필요한 도구들을 전부 이미지에 포함시키지 않고, 빌드 수행 후 이미지에는 포함 시키지 않아 이미지의 용량을 크게 줄일 수 있다. 위 두가지 예제로 보면, 빌드 후의 결과물만 WAS에 옮기고 이미지를 생성하여 이미지 크기를 크게 줄인 것을 알 수 있다.

# 10부 : 클라우드에 배포

클라우드에 배포하기 위해서는 클라우드 컨텍스트가 필요. 현재까지 사용한 것은 기본 docker 컨텍스트임.

예제에서는 Azure(애저) 를 사용하며, 계정을 이용하여 애저 컨텍스트를 추가 할 수 있음.
해당 컨텍스트를 추가하게 되면 다음의 명령어로 해당 컨텍스트에서 이미지를 실행할 수 있음.

```
docker context use myacicontext
docker run  -dp 3000:3000 <username>/getting-started
```

끝.
