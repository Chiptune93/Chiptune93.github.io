---
title: Discord Remind Bot
categories: [Etc, Project]
tags: [Personal Project, Discord, Discord Bot, Notion, Notion API]
---

## 프로젝트 개요

새벽에 개념정리 하다가, 하루에 몇 번 씩 알림으로 오면 좋겠다 싶어서 만든
리마인더 봇입니다.


### 사용기술

크게 사용된 외부 API는 다음과 같다.

1. Discord Bot API
2. Notion API

### 개발환경

개발 환경은 다음과 같다.

1. Mac OS (M1)
2. Python 3.9 +
3. intelliJ IDE


## 디스코드 봇 개요

- 특정 시간에 디스코드 채널로 리마인드 하고 싶은 내용을 보낸다.
- 리마인드의 내용은 노션에 등로된 데이터베이스에서 제공된다.
- 모든 데이터를 한 번에 보낼 수는 없으므로, 데이터를 가져온 후 랜덤으로 하나를 뽑아 전달한다.

### 이전 discord bot과 달라진 점.

- discord.py의 Cog를 적용했다. (https://discordpy.readthedocs.io/en/stable/ext/commands/cogs.html)
  - 기능을 모듈 별로 관리할 수 있어서 편하다.
  - 코드 가독성이 좋다.

- 원래는 Cron을 쓰려고 했으나, discord.ext Tasks가 더 좋아 보여서 그걸 적용했다.
- 크론과는 달리, 인수에 직접 시간을 지정하여 반복수행 할 수 있다.

## 소스

- main.py

```python
import asyncio
import os

import discord
from discord.ext import commands
from dotenv import load_dotenv

# 환경 변수 로딩
load_dotenv()

# 디스코드 봇 토큰 값 지정
token = os.getenv('DISCORD_BOT_TOKEN')

# 디스코드 봇 인텐트 및 봇 초기화
intents = discord.Intents.all()
bot = commands.Bot(intents=intents, command_prefix='!')


# Cogs 모듈 로딩을 위한 구문, 파일을 통해 구분하여 가져옴
# 이렇게 하면, 폴더 내부에 모듈 넣어서 관리할 수 있어 편함.
async def load_extensions():
    for filename in os.listdir("Cogs"):
        if filename.endswith(".py"):
            await bot.load_extension(f"Cogs.{filename[:-3]}")


# 메인 함수 호출
# 디스코드 특정 버전(12++) 부터 async를 적용해야 제대로 호출이 가능함.
async def main():
    async with bot:
        await load_extensions()
        await bot.start(token)


# asyncio를 통해 봇 구동.
asyncio.run(main())

```

- Cogs -> remind.py

```python
import os
from datetime import datetime
from discord.ext import tasks, commands
from dotenv import load_dotenv
import pytz
import requests
import random

# 채널 정보를 환경 변수에서 세팅
target_channel = os.getenv('DISCORD_REMIND_CHANNEL')


# Cog 클래스
class Remind(commands.Cog):
    # 생성자, 봇을 받아 초기화함.
    def __init__(self, bot):
        self.bot = bot
        self.channels = [target_channel]  # 채널 ID 리스트로 변경

    # 반복 작업 구문
    @tasks.loop(minutes=60)  # 매 1시간 마다 반복.
    async def send_messages_to_channels(self):
        # 날짜 체크.
        KST = pytz.timezone('Asia/Seoul')
        dt = datetime.now().astimezone(KST)

        # 오전 9시 ~ 오후 9시 사이에만 실행한다.
        print(f'현재 시간 : {dt} -> {dt.hour} : {dt.minute} : {dt.second}')
        if (dt.hour == 9 and dt.minute >= 0 and dt.second >= 0) and (
                dt.hour < 22 and dt.minute <= 59 and dt.second <= 59):

            for channel_id in self.channels:
                try:
                    # 채널에 메세지를 전송한다.
                    channel = self.bot.get_channel(channel_id)
                    await channel.send(make_message(get_notion_data()))
                except Exception as e:
                    print(f"채널 ID {channel_id}를 찾을 수 없습니다.")
                    print(e)
        else:
            print('Remind 시간이 아닙니다.')

    # 작업 실행 전, 봇 실행이 완료될 때 까지 기다린다.
    @send_messages_to_channels.before_loop
    async def before_send_messages_to_channels(self):
        await self.bot.wait_until_ready()

    # Cog Listener, 준비가 완료되면 작업을 시작한다.
    @commands.Cog.listener()
    async def on_ready(self):
        print(f'{self.bot.user} has connected to Discord!')
        self.send_messages_to_channels.start()

    def cog_unload(self):
        self.send_messages_to_channels.cancel()


# Cog 셋업 함수
async def setup(app):
    await app.add_cog(Remind(app))


# 데이터 -> 메세지 세팅 함수
def make_message(row):
    message = '**# ' + row['subject'] + '**'
    message += '\n>>> ' + row['info'] + '\n\n'
    print(message)
    return message


# 데이터를 노션에서 가져오는 함수
def get_notion_data():
    t = os.getenv('NOTION_CONNECTION_TOKEN')
    b = "https://api.notion.com/v1/databases/"
    d = os.getenv('NOTION_DB_ID')
    header = {"Authorization": t, "Notion-Version": "2022-06-28"}

    response = requests.post(b + d + "/query", headers=header, data="")

    # 데이터베이스 내용 중 랜덤으로 하나 뽑기.
    choice = random.choice(response.json()["results"])
    # 해당 데이터를 파싱하여 리턴.
    data = {'subject': choice["properties"]["subject"]["title"][0]["text"]["content"],
            'info': choice["properties"]["info"]["rich_text"][0]["text"]["content"]}

    return data


load_dotenv()

```

## 깃 허브

해당 봇 소스는 아래 링크에서 확인 가능합니다.

https://github.com/Chiptune93/discord.reminder.bot
