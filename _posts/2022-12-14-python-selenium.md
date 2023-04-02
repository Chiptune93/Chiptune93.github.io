---
title: Python - Selenium 설치(웹크롤링)
categories: [Python]
tags: [Selenium, Webdriver, Python]
---

## Selenium 설치

- Python 3.X 버전 기준

```bash
pip3 install selenium
```

## Webdriver 설치 (homebrew)

```bash
brew install --cask chromedriver
```

## 셀레니움 사용한 웹 브라우저 탐색
- homebrew 를 이용하여 webdriver를 설치한 경우, /opt/homebrew/ 에 위치.
- 권한 등 기타 문제 있을 시, /usr/local/ 쪽 경로로 이동 후 아래 소스 수정하여 사용.

```python
import os
import sys
from selenium import webdriver

# 크롬 드라이버 설정
chrome_options.add_argument('headless') # 웹 페이지를 띄우지 않음.
chrome_options.add_argument('--disable-gpu') # GPU 사용 안함 설정.
chrome_options.add_argument('lang=ko_KR') # 언어 설정
chrome_options.add_argument(
    "user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36")

# Window 
# driver = webdriver.Chrome('C:\chromedriver.exe', chrome_options=chrome_options)
# Mac
driver = webdriver.Chrome('/opt/homebrew/chromedriver', chrome_options=chrome_options)

# 인터넷 접속
driver.get('https://google.com')

```