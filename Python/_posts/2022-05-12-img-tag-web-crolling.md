---
layout: post
title: Python - 구글 이미지 검색 크롤링하는 소스
description: >
  구글 이미지 검색 크롤링하는 소스

hide_last_modified: true
categories: [Python]
tags: [Python, Google Crolling, Crolling]
---

- Table of Contents
{:toc .large-only}

이전에 진행한 특정 사이트에서 이미지 다운로드 시켜주는 예제 진행 후,

구글 검색도 가능하다고 하여 찾아서 작성해보았다.

파이썬은 처음 접해보는데, 라이브러리가 되게 잘되어있어서 기본적인 문법만 알면

얼마든지 응용, 작성할 수 있을 것 같다.

이 언어로 도대체 어디까지 가능한지 계속 찾아볼 계획이다.

```py
import os
import sys
from tkinter.tix import INTEGER
import urllib.request
from selenium import webdriver
from time import sleep
from bs4 import BeautifulSoup
import uuid
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import datetime

# 저장할 이미지 폴더
path = "E:/"

# 수용할 확장자
acceptExt = ['jpg','jpeg','png','gif','webp']

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

# 검색어 입력 받기
keyword = input('검색어를 입력하세요 ▶ ')
# 최대 개수 입력 받기
imageCount = input('몇 개까지 가져오시겠습니까? (최대 1000장) ▶ ')
# 개수 예외 처리
if imageCount < 0 and imageCount > 1000 :
    imageCount = 1000

# 구글 접속
driver.get('https://www.google.co.kr/imghp?hl=ko')
# 검색어 요소 찾음
elem = driver.find_element(By.NAME, "q")  # 구글 검색창 선택
# 검색어 전달
elem.send_keys(keyword)
# 검색 시작
elem.send_keys(Keys.RETURN)

# response 대기를 위한 2초 슬립
sleep(2)

last_height = driver.execute_script(
    "return document.body.scrollHeight")  # 브라우저의 높이를 자바스크립트로 찾음
while True:
    # Scroll down to bottom
    driver.execute_script(
        "window.scrollTo(0, document.body.scrollHeight);")  # 브라우저 끝까지 스크롤을 내림
    # Wait to load page
    sleep(1)
    # Calculate new scroll height and compare with last scroll height
    new_height = driver.execute_script("return document.body.scrollHeight")
    if new_height == last_height:
        try:
            # 스크롤을 내리다 보면 "결과 더보기"가 뜨는 경우 이를 클릭해준다
            driver.find_element(".mye4qd").click()
        except:
            break
    last_height = new_height

# 이미지 요소 리스트 가져오기
imgs = driver.find_elements(By.CSS_SELECTOR, 'img.rg_i.Q4LuWd')

# 이미지 다운로드 주소 담을 배열
links = []
# 요소만큼 반복
if len(imgs) > 0:
    for i, img in imgs:
        if i <= imageCount:
            # 이미지 미리보기 클릭
            try:
                img.click()
            except:
                continue
            # 응답 대기
            sleep(0.5)

            # 다운로드 주소에 원본 이미지 주소 저장
            links.append(driver.find_element(
                By.XPATH, '//*[@id="Sva75c"]/div[1]/div[1]/div[3]/div[2]/c-wiz/div[1]/div[1]/div[1]/div[3]/div[1]/a/img').get_attribute('src'))

            # 미리보기 닫아줌
            driver.find_element(
                By.XPATH, '//*[@id="Sva75c"]/div/div/div[2]/a').click()

for link in links:
    try:
        # 확장자 추출, 파라미터 존재 시, 제거.
        print("link : " + link)
        if link.find('?') > 0:
            link = link[0:link.index('?')]
        ext = link.split('.')[-1]
        # 확장자 수용여부 판단
        if ext.lower() in acceptExt:
            # 파일 저장 이름(랜덤) 및 경로 생성
            saveUrl = path + '/' + str(uuid.uuid4()) + '.' + ext
            # 파일 다운로드 요청 및 저장
            urllib.request.urlretrieve(link, saveUrl)
    except:
        print('error ! link : ' + link)
        continue
```
