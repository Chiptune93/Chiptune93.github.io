---
title: Java this vs this()
categories: [Etc, Issue & Info]
tags: [jekyll, chirpy, chirpy theme]
---


## Chirpy Theme 적용 시, 문제 사항

1. TOC 적용 불가 현상

2. 우측 상단 검색 불가 현상

3. 댓글 기능 추가

## 해결방법

### 1. TOC 적용 불가 및 검색 불가 현상 해결

- 테마 원작자인 cotes2020 깃헙에서 fork 받아 테마를 세팅하였음.
- 테마 세팅 후, 로컬 빌드 시 우측에 나와야 하는 목차와 우측 상단 검색기능이 동작 되지 않으며
post.min.js 파일이 404를 리턴함.

- 하여 원작자 깃헙을 살펴보던 중, 아래 글을 발견함
[#링크](https://github.com/cotes2020/jekyll-theme-chirpy/wiki/Upgrade-Guide)

- 링크 내 요약은 테마의 버전이 업그레이드 되면서 기존에 제공되던 js 파일이 포함되지 않고 빌드 후 깃으로 직접 경로 내 추가를 해야 한다는 것.

    - https://github.com/cotes2020/jekyll-theme-chirpy/tags 주소에 들어가
    최신 버전을 클릭한다. 그러면 소스 코드 압축 파일을 다운 받을 수 있는데, 그 파일 내에서 
    아래 파일을 기존 소스에 복사하여 넣는다.
        - Gemfile
        - jekyll-theme-chirpy.gemspec
        - package.json
        - rollup.config.js

    - 해당 파일을 옮긴 후, 기존 소스코드 루트에서 다음을 실행한다. (참고로, npm이 깔려있어야 한다.)
        
        ```bash
        $ npm install # 새로 덮어쓴 파일 기준으로 필요한 파일 재 설치
        $ npm run build # 설치 후, 재 빌드
        ```

    - 위 스크립트를 실행 후, 빌드가 끝나면 다시 로컬에서 확인한다.

        ```bash
        $ bundle exec jekyll serve 
        ```

### 2. 댓글 기능 추가

- 댓글 기능은 잘 정리해주신 분이 서드파티 앱까지 찾아 주셔서 감사히 따라했다.
- https://www.irgroup.org/posts/utternace-comments-system/


## 끝 :>