---

title: Notion Database를 활용한 Discord Bot
description: >
  노션 데이터베이스를 활용한 디스코드 봇을 만드는 과정을 기술합니다.


categories: [Project]
tags: [Personal Project, Discord, Discord Bot, Notion, Notion API]
---




# 프로젝트 개요
디스코드 봇을 만들어보고자 하였다.
다만, 기존의 많은 봇들은 외부 사이트에서 요청한 데이터를 보여 주는 형식을 주로 띄고 있다.
예를 들면, 전적 검색 혹은 유튜브 재생 등 별도의 봇 데이터베이스를 활용하는 것은 많이 경험하지 못했다.

따라서, 자체 데이터베이스를 가지고 뭔가를 보여줄 수 있는 봇을 만들고자 하였다.
현재 정리 용도로 활용하고 있는 노션(Notion) 에서 제공되는 API를 통해 노션에 정리된 데이터를 액세스 할 수 있다는 것을 알게되면서 이를 활용해 봇을 만들어보고자 하였다.

## 사용기술

크게 사용된 외부 API는 다음과 같다.

1. Discord Bot API
2. Notion API

## 개발환경

개발 환경은 다음과 같다.

1. Mac OS (M1)
2. Python 3.9 +
3. VS Code


# 디스코드 봇 개요

만들고자 하는 봇은 이직 준비를 위한 과정에서 한가지 생각한 것이 있었다.
물론 서비스 성은 거의 없지만 아래와 같다.

- 사용자는 봇을 추가하여 제공되는 예상 기술 면접(인터뷰) 문제를 제공받고 이를 답변하는 연습을 한다.
- 사용자는 명령어를 통해 봇에게 인터뷰 시작 및 다음, 중지와 같은 상호작용을 한다.
- 봇은 이를 통해 인터뷰 문제를 제공하고, 답변을 제공하며 몇 개의 질의응답을 했는지 출력해준다.

## 봇의 기능

1. ! help 명령어를 통해 도움말을 제공한다.
2. ! start 명령어를 통해 인터뷰를 시작한다
    - 인터뷰를 시작하면 인터뷰 시작 안내 멘트와 함께 n초 후 노션 데이터베이스에서 데이터를 가져와 1번 문제부터 출력한다.
3. ! ans 명령어를 통해 현재 제공된 문제에 대한 답을 조회한다.
    - 현재 문제에 대한 답변을 가져와 채널에 출력한다.
4. ! next 명령어를 통해 다음 문제로 넘어간다.
5. ! fin 명령어를 통해 인터뷰를 종료하고 결과를 조회한다.
    - 결과는 총 몇 문항이고, 몇개의 질의응답을 진행했는지 출력한다.

## 봇 서비스 시 알고 있어야 하는 점

디스코드 봇은 파이썬으로 코딩하면, 해당 파이썬 파일을 실행 하고 있어야만
봇이 온라인 상태가 되며, 명령 및 기타 처리가 가능하다.

즉, 특정 서버에 해당 봇을 계속 실행하고 있어야 서비스가 가능하다
(웹 서비스 처럼)

따라서, 해당 파이썬 파일을 상시로 실행하고 있어야 하는 서버가 필요하다.
나의 경우, 홈 서버가 있어 해당 서버에 Docker를 통해 파일을 실행시켜놓고 서비스 할 생각이다.

# 1차 개발 진행

1차 개발 진행의 목표는 핵심 기능 개발이다.
핵심 기능 개발의 목표는 다음과 같다.

1. 이벤트 기반의 상시 대기 과정
2. 최초 사용자 UI
3. 요청에 따른 응답 보내기

우선 이를 개발하기에 앞서 파이썬을 통해 디스코드 봇을 어떻게 만들고 테스트 하는지
채널에 메시지 전달 같은 기본 기능들을 어떻게 사용하는지 테스트 하였다.

이는 정리하여 파이썬 파트에 올려놓았다.

1. [디스코드 봇 만들기](https://chiptune93.github.io/python/discord-bot/)

2. [디스코드 채널에 메세지 전달하기](https://chiptune93.github.io/python/discord-bot-message/)

## discord.py 를 통한 봇 만들기

처음에 진행할 때, 많이 사용하는 discord.py 라이브러리를 통한 개발을 진행했다.
전체적인 코딩 스타일은 아래와 같았다.

```python
# bot.py
import os

import discord
from dotenv import load_dotenv

import requests
import asyncio

load_dotenv()
TOKEN = os.getenv('DISCORD_BOT_TOKEN')
print(TOKEN)

intents = discord.Intents.default()
intents.message_content = True

client = discord.Client(intents=intents)


@client.event
async def on_guild_join(guild):
    print("on guild join event")
    print(guild)


@client.event
async def on_ready():
    print("bot is ready!")
    guild = discord.utils.get(client.guilds)

    connectedServer = '[연결된 서버 목록]'
    print(connectedServer)
    print('-------------------------')
    for guild in client.guilds:
        print(guild)

    print('-------------------------')


@client.event
async def on_message(message):
    print("---------------------------")
    print("message all -> ", message)
    print("---------------------------")
    print("guild name           -> ", message.guild.name)
    print("channel name         -> ", message.channel.name)
    print("message type         -> ", message.type)
    print("message sender       -> ", message.author.name)
    print("message bot y/n      -> ", message.author.bot)
    print("message content      -> ", message.content)
    print("---------------------------")
    
    # 새로운 서버에 봇이 추가되었을 때, welcome message
    if message.type == discord.MessageType.new_member and message.author.name == 'Interview-Bot' and message.author.bot == True:
        await message.channel.send(
            '```'
            + '\n안녕하세요! 추가해주셔서 감사합니다.'
            + '```'
        )
        
    elif message.author.bot == False and message.content.startswith('! help'):
        # help message
        await send_help_message(message)
    elif message.author.bot == False and message.content.startswith('! start'):
        # start
        # 현재 인터뷰 중인지 체크
        if chk_interview_now():
            # 인터뷰 중이면 명령 실행 X
            return
        else:
            # 인터뷰 시작.
            interview_start()
    elif message.author.bot == False and message.content.startswith('! stop'):
        # stop
        # 현재 인터뷰 중인지 체크
        if chk_interview_now():
            # 인터뷰 중이면 중지.
            interview_stop()
        else:
            # 인터뷰 중이 아니면 명령 실행 X
            return
    elif message.author.bot == False and message.content.startswith('! pause'):
        # pause
        # 현재 인터뷰 중인지 체크
        if chk_interview_now():
            # 인터뷰 중이면 일시 정지
            interview_pause()
        else:
            # 인터뷰 중이 아니면 명령 실행 X
            return
    elif message.author.bot == False and message.content.startswith('! set time'):
        # set time
        # 현재 인터뷰 중인지 체크
        if chk_interview_now():
            # 인터뷰 중이면 명령 실행
            interview_set_time()
        else:
            # 인터뷰 중이 아니면 명령 실행 X
            return

    # other message ignore!
    else:
        return


async def send_help_message(message):
    print("send help message")

def chk_interview_now():
    print("chk interview now")


def interview_start():
    print("interview start")


def interview_stop():
    print("interview stop")


def interview_pause():
    print("interview pause")


def interview_set_time():
    print("interview set time")

client.run(TOKEN)

```

전체적인 환성본은 아니지만 이정도 까지 개발했을 때 약간의 문제가 있음을 직감했다.

우선, @client.event 기반으로 작성되어 직관성이 떨어지고 하나의 이벤트 대기 코드에
순차적으로 작성해야 했다. 사용자가 입력하는 커맨드에 대한 처리도 해당 함수 하나에 작성해야 해서
가독성도 떨어질 뿐더러 함수 사용하기가 너무 불편했다.

그래서 다른 방법이 없나 찾아보던 도중 다른 방식이 있는 것을 알게 되었다.

## bot command pattern

아래의 링크에서 도움을 얻었다.

1. [나무위키 디스코드 봇 제작](https://namu.wiki/w/Discord/%EB%B4%87/%EC%A0%9C%EC%9E%91%EB%B2%95)

2. [discord command ext](https://discordpy.readthedocs.io/en/stable/ext/commands/index.html)

해당 커맨드 패턴을 통해 개발하면 코드가 아래와 같이 편하게 변경된다.

```python
# bot.py
import os

import discord
from discord.ext import commands
from dotenv import load_dotenv
import requests
import random
import time

intents = discord.Intents.all()
# 사용자가 입력하는 명령어의 프리픽스를 설정한다.
# 여기서 '! '가 되어있으면 사용자는 '! 명령어' 를 입력해야 봇이 반응한다.
prefix = "! "
# 봇 초기화
bot = commands.Bot(command_prefix=prefix, intents=intents)
# 봇에는 기본적으로 헬프 명령어가 잡혀져 있어 따로 'help' 명령어를 구현하고자 한다면
# 봇에서 제거를 해주어야 한다.
bot.remove_command('help')

@bot.event
async def on_ready():
    print("bot is ready!")
    print(bot)
    connectedServer = '[연결된 서버 목록]'
    print(connectedServer)
    print('-------------------------')
    for guild in bot.guilds:
        print(guild)

    print('-------------------------')


@bot.event
async def on_message(message):
    print("---------------------------")
    print("message all -> ", message)
    print("---------------------------")
    print("guild name           -> ", message.guild.name)
    print("channel name         -> ", message.channel.name)
    print("message type         -> ", message.type)
    print("message sender       -> ", message.author.name)
    print("message bot y/n      -> ", message.author.bot)
    print("message content      -> ", message.content)
    print("---------------------------")

    # 새로운 서버에 봇이 추가되었을 때, welcome message
    if message.type == discord.MessageType.new_member and message.author.name == 'Interview-Bot' and message.author.bot == True:
        await message.channel.send(
            '```'
            + '\n안녕하세요! 추가해주셔서 감사합니다.'
            + '```'
        )
    elif message.author.bot == True:
        return
    else:
        await bot.process_commands(message)


@bot.event
async def on_guild_join(guild):
    print("on guild join event")
    print(guild)


@bot.command()
async def help(message):
    print("send help message")
    await message.channel.send(
        '```'
        + '\n안녕하세요! 추가해주셔서 감사합니다.'
        + '```'
    )


@bot.command()
async def start(message):
    print(message)
    # 명령자 아이디
    member_id = message.author.id

@bot.command()
async def next(message):
    # 명령자 아이디
    member_id = message.author.id

@bot.command()
async def ans(message):
    # 명령자 아이디
    member_id = message.author.id

@bot.command()
async def fin(message):
    # 명령자 아이디
    member_id = message.author.id

load_dotenv()
bot.run(os.getenv('DISCORD_BOT_TOKEN'))

```

이러한 패턴을 통해 원하는 서비스 구성을 구현하고, 봇 내부 핵심 로직을 구현하였다.
구현한 핵심 과제는 다음과 같다.

1. 이벤트 기반의 상시 대기 과정
2. 최초 사용자 UI
3. 요청에 따른 응답 보내기


# 2차 개발 진행 및 마무리

## 마무리 소스 정리 및 문서 작성

- [소스 전체 레파지토리](https://github.com/Chiptune93/Interview-Discord-Bot) 

- [실제 동작하는 봇 소스 파일(파이썬)](https://github.com/Chiptune93/Interview-Discord-Bot/blob/main/DIscord-Interview-Bot/interview-bot-2.0.py)



