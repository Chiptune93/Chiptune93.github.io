ㅖ---
title: Git - Pull Request(PR)
categories: [Etc, git]
tags: [git, PR, Pull Request]
---

참고 : [Git 입문](https://backlog.com/git-tutorial/kr/)

## 1. Fork와 Pull Request

다른 사람의 프로젝트에 참여해 기여자로써 공헌 또는 프로젝트를 수정하고 싶다면
해당 레파지토리를 수정할 수 있는 권한을 가져야 한다.
하지만 모두가 권한을 가질 수 없고, 마음대로 수정할 수 있어서도 안된다.

이 때, 사용하는 것이 'Fork' 이다.

포크는 다른 사람의 저장소에 있는 레파지토리를 내 원격저장소에 가져오는 것이다.

- Fork 

  특정 레파지토리를 내 원격저장소로 복사 

- Clone

  특정 레파지토리를 내 로컬저장소에 복사

![이미지](/assets/img/Git/pr1.png)

이제 가져온 소스코드를 수정하여 커밋을 하면 내 저장소에만 반영이 될 뿐 
원래 저장소에는 영향을 끼칠 수 없다. 

이 때, 사용하는 것이 'Pull Request(PR)' 이다.

변경점 또는 수정이 된 브랜치를 원래 레파지토리에 반영을 하기 위해(= 메인 브랜치에 반영하기 위해)
원래 레파지토리 권한을 가진 사람에게 PR을 보낸다. 그러면 권한이 있는 사람이 해당 PR을 보고(= 리뷰를 하고)
승인을 하면 메인 브랜치에 반영이 되는 식으로 기여가 가능하다.

> Fork 없이 Pull Request 하는 방법? <br/> > 해당 오리진 레파지토리에 브랜치를 생성할 수 있는 액세스 권한이 있는 경우에는 fork 없이 브랜치 pull request가 가능하다. 


## 2. PR

위의 사례에서 보듯, Pull Request는 쉽게 말해 내가 로컬에서 수정한 브랜치를 원본 레파지토리에 적용하고 싶으니 검토 후에 괜찮으면 적용해 달라 라는 것으로 정의할 수 있습니다.

코드 충돌을 방지하고, 오픈소스 프로젝트에 기여할 때 많이 사용하는 방식이며 기업에서도 기업의 소스 코드를 관리하는 방식으로도 많이 사용하고 있습니다.

- PR 단계 도식화


![이미지](/assets/img/Git/pr2.png)

1. 내 원격 레파지토리에 Fork
2. 로컬 레파지토리에 Clone
3. remote 설정
4. branch 생성
5. 수정 작업 후, add, commit, push (원래 레파지토리에 수정사항이 있다면 fetch로 가져옴)
6. pull request 생성
7. 승인되어 pr을 master 브랜치에 merge
8. merge 이후 동기화 및 브랜치 삭제

## 3. PR 실습

### 3.1. 특정 원본 저장소를 Fork
![이미지](/assets/img/Git/pr3.png)

![이미지](/assets/img/Git/pr4.png)

fork가 완료되면 내 저장소에 해당 레파지토리가 복사되며
이름 밑에 Fork From 으로 원래 저장소가 표기된다.

![이미지](/assets/img/Git/pr5.png)

### 3.2. Fork 한 저장소를 로컬에 Clone

![이미지](/assets/img/Git/pr6.png)

- 저장소 clone

```bash
$ git clone {url} # 저장소 복사
```

![이미지](/assets/img/Git/pr7.png)

- 리모트 설정

```bash
$ git remote add {name} {원본저장소 주소} # remote에 원본 저장소 주소 설정
$ git remote -v # 원격저장소 주소확인 
```

![이미지](/assets/img/Git/pr8.png)

### 3.2. 브랜치 생성 후 작업하기

- branch 생성하기

```bash
## 브랜치 생성
$ git branch dev-test

## 브랜치 이동
$ git checkout dev-test

## 브랜치 생성 후 이동
$ git checkout -b dev-test

## 브랜치 조회
$ git bracnch
```

![이미지](/assets/img/Git/pr9.png)

- 해당 브랜치에서 소스 작업

![이미지](/assets/img/Git/pr10.png)

- 작업 후, commit & push

```bash
## add
$ git add .

## commit
$ git commit -m "msg"

## push
$ git push origin dev-test
```

![이미지](/assets/img/Git/pr11.png)
![이미지](/assets/img/Git/pr12.png)

### 3.3. 작업 후, PR 하기.

- push가 완료 되면, 원격 저장소에서 PR 가능.

![이미지](/assets/img/Git/pr13.png)

- 상세 창에서 내용 및 메세지 등을 입력하고 PR 보냄.

![이미지](/assets/img/Git/pr14.png)

- 원본 저장소에서 관리자가 해당 PR을 보고 판단 및 승인 가능

![이미지](/assets/img/Git/pr15.png)

- 해당 PR이 승인됨을 확인.

![이미지](/assets/img/Git/pr16.png)

- PR merge 이후, 동기화 및 브랜치를 삭제하여 작업을 완료.

```bash
## 원본저장소와 동기화
$ git pull forkedRepo

## 브랜치 삭제
$git branch -d dev-test
```


