---
title: 5. 로컬에서 Jenkins 실습
categories: [Project, Jenkins CI/CD]
tags: [Personal Project, Jenkins, pipeline, blueocean, cicd]
---

## 젠킨스에서 프로젝트 생성


![](/assets/img/jenkins/attachments/26476559/26443802.png?width=340)

아이템 이름을 적고 ‘Freestyle project’ 선택 후, ‘OK’

![](/assets/img/jenkins/attachments/26476559/26607692.png?width=340)

프로젝트 설정을 아래와 같이 진행한다.

![](/assets/img/jenkins/attachments/26476559/26411027.png?width=340)![](/assets/img/jenkins/attachments/26476559/26476575.png?width=340)![](/assets/img/jenkins/attachments/26476559/26476581.png?width=340)

잠시 멈춘 후, Jenkins 에서 ssh 키를 발급 받는다.

`docker exec -it {컨테이너명} ssh-keygen` 명령을 사용하여 외부에서 생성 요청한다.

```
dk@Chiptune ~ % docker exec -it jenkins-docker /bin/bash
OCI runtime exec failed: exec failed: unable to start container process: exec: "/bin/bash": stat /bin/bash: no such file or directory: unknown
dk@Chiptune ~ % docker exec -it jenkins-blueocean ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/var/jenkins_home/.ssh/id_rsa): 
Created directory '/var/jenkins_home/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /var/jenkins_home/.ssh/id_rsa
Your public key has been saved in /var/jenkins_home/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:1586et6pQw5f0CsvcVIa1YLdlMqW0bGz9h0hWRQZ81o jenkins@76a028822060
The key's randomart image is:
+---[RSA 3072]----+
|             oo@B|
|            ..*+*|
|            .=+=E|
|           .o=+o+|
|        S . o=.= |
|         .. *.=.+|
|           = Bo o|
|            Bo.. |
|          .++=o  |
+----[SHA256]-----+
```

공개키가 생성된 것을 확인한다.

`docker exec -it {컨테이너명} cat /var/jenkins_home/.ssh/id_rsa.pub` 명령을 사용하여 외부에서 확인한다.

```
dk@Chiptune ~ % docker exec -it jenkins-blueocean cat /var/jenkins_home/.ssh/id_rsa.pub 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCNrHrH3erqR6RJChq5JwydAOreKri35GlG0hQKPQaKRf3vXkrpJDRRgMK2AgCAivb8aMMxI7vhIPyqT6TMILP3pzpqS9AUBGrGfSv43Rd7zjp3riq6q6igRWwU+0/Y9USRmr/mw/n+aBkkya/fhVRZHMVYtGtvXnZktYqz/e2/4+DETFQLXDyiPBdlawZLq3efuH7wn0GObgXsx9RdslKqnmO5KGWFzjZl1eKDQvLfQblpdu9+X+jfPCJ2eo3C6SO0RsJWjxCzXYqu7VtFLqQcaB8PrGospLAaXx4R5wDlkf/3tDsQZ2Z4BLNtcRiZ/gD+pMq8pWLBDUvuRQDQMX9IIu78KFf6+OY6/RJeGQZxVrOFmpeIgOeupKtKiAmWbehlgUnDEz0QS3uLWkmrt9k7YqdCM1/oUgOVU2xOhQhNJDrPfs122JnxwGVas4nntDY5snu1FHpQuUiyUvq0J3T3V825eMA2B8b/U9HEx7ZHp30PWKKnj5fLOY8KE+Ws/CE= jenkins@76a028822060
```

개인키 생성을 확인한다.

`docker exec -it {컨테이너명} cat /var/jenkins_home/.ssh/id_rsa` 명령을 사용한다.

```
dk@Chiptune ~ % docker exec -it jenkins-blueocean cat /var/jenkins_home/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
...
```

## github 사이트에서 Jenkins에서 생성한 Public 키 값을 등록


레파지토리에서 ‘Settings’ → ‘Deploy Keys’ → ‘Add Deploy Key’ 를 통해 키 값을 등록한다.

![](/assets/img/jenkins/attachments/26476559/26411034.png?width=340)

아까 생성 했던 공개키 값을 등록 한다.

![](/assets/img/jenkins/attachments/26476559/26411040.png?width=340)

젠킨스에서 Credentials 를 등록한다. ‘Dashboard’ → ‘Jenkins 관리’ → ‘Credentials’ 로 접근한다.

![](/assets/img/jenkins/attachments/26476559/26443812.png?width=340)

전체 도메인에 적용하기 위해 ‘Global’을 클릭한다.

![](/assets/img/jenkins/attachments/26476559/26607702.png?width=340)

‘Add Credentials’ 을 클릭한다.

![](/assets/img/jenkins/attachments/26476559/26411048.png?width=340)

‘SSH Username with private key’ 를 선택하고, 아까 생성한 개인키를 직접 입력한다.

![](/assets/img/jenkins/attachments/26476559/26476593.png?width=340)

이전에 생성했던 프로젝트 아이템으로 들어가서, 왼쪽의 ‘구성’ 클릭.

아래와 같이 Credentials 옵션을 수정한다. 방금 생성한 인증을 적용하면 된다.

![](/assets/img/jenkins/attachments/26476559/26411055.png?width=340)
