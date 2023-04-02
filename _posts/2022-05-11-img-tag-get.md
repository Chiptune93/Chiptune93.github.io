---
layout: post
title: Python - 웹 사이트 IMG 태그 소스 파일 가져오기
description: >
  웹 사이트 IMG 태그 소스 파일 가져오기

hide_last_modified: true
categories: [Python]
tags: [python, img, web img, crolling]
---

- Table of Contents
{:toc .large-only}

실습 겸, 테스트로 특정 웹 페이지 내에 특정 영역을 입력받아

해당 영역 내에 있는 img 또는 video 요소의 src 파일을 가져오는 코드를 작성해서 테스트 해보았다.

```python
import os
import sys
import urllib.request
from selenium import webdriver
from time import sleep
from bs4 import BeautifulSoup
import uuid

# 저장할 이미지 폴더
path = "E:/이미지"

# 크롬 드라이버 설정
# (크롤링할 때 웹 페이지 띄우지 않음, gpu 사용 안함, 한글 지원, user-agent 헤더 추가)
chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('headless')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('lang=ko_KR')
chrome_options.add_argument(
    "user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36")
driver = webdriver.Chrome(
    'C:\chromedriver.exe', chrome_options=chrome_options)

url = input('insert url :: ')
selector = input('insert selector :: ')

if selector == '':
    selector = 'div.item-post-inner'

# 페이지 가져오기
driver.get(url)
# response 대기를 위한 2초 슬립
sleep(2)

# html로 파싱
soup = BeautifulSoup(driver.page_source, "html.parser")

# 이미지 요소 리스트 가져오기
imgs = soup.select(selector + ' img')

# 비디오 요소 리스트 가져오기
vids = soup.select(selector + ' video > source')

# 요소만큼 반복
if len(imgs) > 0:
    for img in imgs:
        # 이미지 소스 주소 추출
        src = img.get('src')
        # 확장자 추출
        ext = src.split('.')[-1]
        # 파일 저장 이름(랜덤) 및 경로 생성
        saveUrl = path + '/' + str(uuid.uuid4()) + '.' + ext
        # 해당 이미지 소스로 다운로드 요청 보내기
        req = urllib.request.Request(src, headers={'User-Agent': 'Mozilla/5.0'})

        try:
            imgUrl = urllib.request.urlopen(req).read()
            with open(saveUrl, "wb") as f:  # 디렉토리 오픈
                        f.write(imgUrl)  # 파일 저장
        except urllib.error.HTTPError:
            print('에러')
            sys.exit(0)

# 요소만큼 반복
if len(vids) > 0:
    for vid in vids:
        # 이미지 소스 주소 추출
        src = vid.get('src')
        # 확장자 추출
        ext = src.split('.')[-1]
        # 파일 저장 이름(랜덤) 및 경로 생성
        saveUrl = path + '/' + str(uuid.uuid4()) + '.' + ext
        # 해당 이미지 소스로 다운로드 요청 보내기
        req = urllib.request.Request(src, headers={'User-Agent': 'Mozilla/5.0'})

        try:
            imgUrl = urllib.request.urlopen(req).read()
            with open(saveUrl, "wb") as f:  # 디렉토리 오픈
                        f.write(imgUrl)  # 파일 저장
        except urllib.error.HTTPError:
            print('에러')
            sys.exit(0)
```
