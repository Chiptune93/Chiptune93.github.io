---
layout: post
title: Python - Discord Bot 만들기
description: >
    디스코드 봇을 생성하고 연결하는 과정을 기록합니다.

hide_last_modified: true
categories: [Python]
tags: [Discord, Python]
---

- Table of Contents
{:toc .large-only}


# Discord Bot 샘플 생성하기.

## 개발 환경

1. Mac OS Monterey (12.5)
2. Python 3.10.7
3. VS Code

## Discord 어플리케이션 생성

1. Discord Developers 접속 (https://discord.com/developers/applications)

    ![이미지](/assets/img/Python/discord1/1.png)

2. New Application 을 클릭하여 이름을 입력 후, 새 어플리케이션 생성

    ![이미지](/assets/img/Python/discord1/2.png)

3. Bot 영역을 클릭 후, 'Add Bot' 을 클릭 후, 'Yes, Do it!' 을 클릭하여 봇을 생성.

    ![이미지](/assets/img/Python/discord1/3.png)

4. INTENT 와 Permission 을 'Administrator' 로 활성화

- 추후 목적에 따라 비활성화/활성화 조정 가능. 
- 현재는 테스트 목적으로 활성화

    ![이미지](/assets/img/Python/discord1/4.png)

    ![이미지](/assets/img/Python/discord1/5.png)

5. OAuth2 탭으로 이동하여, 아래와 같이 변경

- 서버에 봇을 추가할 때 요구하는 권한 등을 설정하는 과정.

    ![이미지](/assets/img/Python/discord1/6.png)

6. OAuth2 > URL Generator 로 이동하여, 아래와 같이 세팅하면 맨 아래에 URL 하나를 리턴해준다. 해당 URL을 복사하여 가지고 있는다.

    ![이미지](/assets/img/Python/discord1/7.png)

    ![이미지](/assets/img/Python/discord1/8.png)

7. 해당 URL을 웹 브라우저에서 복사하여 접속하면 아래와 같이 디스코드 봇 추가 승인 화면이 나온다.

    ![이미지](/assets/img/Python/discord1/9.png)

    - 여기서 추가하고자 하는 서버 (테스트 용으로 서버를 하나 만들어 두는 것을 추천)를 선택 후, 계속하기를 클릭한다.

    ![이미지](/assets/img/Python/discord1/10.png)

    - 그럼 여기서, URL 생성 시 체크했던 권한을 요구하게 되고 다음 단계로 진행하여 서버에 봇을 추가한다.

    - 그러면 아래 사진처럼 서버에 추가된 봇을 확인할 수 있다.

    ![이미지](/assets/img/Python/discord1/11.png)

## Discord Bot 에 연결하는 파이썬 코드 작성하기.

### Discord Python Library 설치.
```bash
$ pip install -U discord.py # 디스코드 패키지
$ pip install -U python-dotenv # env 파일로 환경 변수 세팅하기 위해 설치.
```

- discord.py 는 디스코드에서 제공하는 라이브러리이다. 이를 이용하여 디스코드 봇과 연결 및 다양한 기능을 사용한다.
- python-dotenv 는 env 파일을 이용하여 토큰 값 혹은 민감 정보들을 포함시키기 위해 사용한다.

### 샘플 소스 코드 작성

- 방금 생성한 봇과 연결하기 위한 샘플 코드를 작성한다.

1. 어플리케이션 봇 탭에서 토큰을 생성 및 복사한다.

    ![이미지](/assets/img/Python/discord1/12.png)
    ![이미지](/assets/img/Python/discord1/13.png)

2. 작업 경로 내에 '.env' 파일을 생성 후, 값을 복사해놓는다.

    ![이미지](/assets/img/Python/discord1/14.png)

3. 'bot.py' 라는 파일을 생성 후 아래 소스 코드를 사용한다. 

    ```python
    # bot.py
    import os

    import discord
    from dotenv import load_dotenv

    load_dotenv()
    TOKEN = os.getenv('DISCORD_TOKEN')

    intents = discord.Intents.default()
    intents.message_content = True

    client = discord.Client(intents=intents)


    @client.event
    async def on_ready():
        print(f'{client.user} has connected to Discord!')

    client.run(TOKEN)

    ```

    이후, 터미널에서 파이썬 명령을 통해 실행

    ```bash
    $ python3 bot.py
    ```

    간혹 가다 아래의 문제가 발생하는 경우가 존재.
    
    ```bash
    Cannot connect to host discord.com:443 ssl:True [SSLCertVerificationError: (1, '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:997)')]
    ```

    이는 디스코드 https 통신 내 인증 관련 문제로 아래 방법을 통해 해결함.

    1. 파이썬 설치 폴더의 'install Certificates.command' 실행.
    2. 폴더가 없는 경우, 파이썬 공식 홈페이지에서 새로 설치하여 진행.

    참고 - [문제관련링크](https://stackoverflow.com/questions/62108183/discord-py-bot-dont-have-certificate)


4. 터미널 실행 시, 정상적이라면 아래와 같이 동작함.

    ![이미지](/assets/img/Python/discord1/15.png)

    위와 같이, 메세지가 뜨게 되었을 때 디스코드 서버에서 해당 봇을 살펴보면
    온라인으로 변경된 것을 볼 수 있음.

    ![이미지](/assets/img/Python/discord1/16.png)



## 마치며

해당 포스트에서는 다음을 알아보았다.

1. 디스코드 봇을 생성 및 권한 부여 - 서버 권한 부여
2. 파이썬 코드를 통해 디스코드 봇과 연결

기본적으로 디스코드 라이브러리가 잘 구성되어있어
공식 홈페이지 가이드 및 도큐먼트를 통해 원하는 기능들을 구성하여
봇을 만들 수 있다.

또한, 기본적으로 OAuth2가 구성되어 있고 봇과의 통신또한 https 기반
웹 소켓 통신이기 때문에 왠만한 기능들을 다 구현가능하다고 본다.

기본적으로 전적 검색 봇이나 유튜브 노래 검색 봇 등, 많은 사례가 있으니
하나를 잡아서 시도해보는 것도 나쁘지 않다.


참고
- https://realpython.com/how-to-make-a-discord-bot-python/#creating-an-application 
- https://discordpy.readthedocs.io/en/stable/quickstart.html



