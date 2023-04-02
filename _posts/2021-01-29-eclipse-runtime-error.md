---
title: Eclipse - 이클립스 세팅 시, Java Runtime Error 해결방법
categories: [IDE]
tags: [ide, eclipse, runtime error]
---


이클립스 실행 시 발생하는 Java Runtime Error 에 대한 해결방법이다.

외부 또는 공유 목적으로 이클립스를 세팅 후 배포 시 발생할 수 있는 문제이다.

기본적으로 이클립스 실행 시, runtime 은 PC에 설치되고 환경변수가 잡힌 경로로 잡는게 기본인데

포맷한 컴퓨터나 새로 세팅한 PC에서 실행시 이와 같은 오류가 많이 발생한다.

> 따라서, 환경변수를 잡아주는 방식으로 해결도 가능하나 여기에선 공유 목적으로 구성하는 이클립스에서 편하게 해당 에러를 잡을 수 있도록 해결 방법을 공유한다.

1. 이클립스 내 eclipse.ini 파일을 메모장으로 연다.
2. 이후 -vmargs 위에 다음과 같이 추가한다.

```
-vm

{jre경로}
```

eclipse.ini 에 추가하는 내용

![eclipse1](/assets/img/IDE/eclipse1.png)

해당 경로는 jre 의 bin 경로를 잡아놓으면 된다, 공유 목적이라면 아마 jdk 도 추가가 될텐데 해당 폴더의 jre / bin 경로를 잡아서 넣어주면 된다. 이렇게 하면 jdk 가 같이 공유되기 때문에 어느 PC에 옮겨도 실행이 잘 된다.
