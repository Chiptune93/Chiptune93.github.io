---
layout: post
title: Mac Ventura Duplicate Terminal.app
description: >
  M1 Mac Ventura OS 에서 intel 터미널을 활용하는 방법 소개

hide_last_modified: true
categories: [Etc]
tags: [Innosetup, Inno Setup Korean, Korean]
---

- Table of Contents
{:toc .large-only}




# 개요

- Mac이 Ventura 로 업데이트 되면서, 터미널 앱의 복사를 막아버림.
- 따라서, 기존에 인텔기반 터미널(로제타2)과 기존 터미널 2개를 사용하던 방법을 사용할 수 없게됨.

# 방법

- ~/.zshrc 에 아래의 내용을 추가함.

  ```bash
  # zsh shell을 arm64 환경으로 설정 후, 로그인
  alias arm="env /usr/bin/arch -arm64 /bin/zsh --login"
  # zsh shell을 x86_64 환경으로 설정 후, 로그인
  alias intel="env /usr/bin/arch -x86_64 /bin/zsh --login"
  ``` 

- 위 내용을 통해, 터미널을 접속 한 후 'arm' 을 입력하면 arm 환경으로 'intel' 을 입력하면 x86 환경으로 터미널을 실행할 수 있음.

- 따라서, 기존 처럼 2개의 터미널로써는 아니지만 환경을 왔다갔다 하면서 사용할 수 있게 됨.

- 관련 링크 : (https://stackoverflow.com/questions/74198234/duplication-of-terminal-in-macos-ventura)

# 트러블 슈팅

- 위 작업을 하고 나서 파이썬을 실행하려고 하니, 아래와 같은 에러 메세지와 마주함.

> xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun

- 해당 문제는 Command Line Tools 식별 문제로 아래 명령으로 Command Line Tools 를 설치하여 해결함.

  ```bash
  xcode-select --install
  ```

- 출처 페이지 : (https://www.hahwul.com/2019/11/18/how-to-fix-xcrun-error-after-macos-update/)