---
title: ERR_INCOMPLETE_CHUNKED_ENCODING 200
categories: [Etc, Issue & Info]
tags: [encoding error, browser]
---


### 크롬/엣지 ERR_INCOMPLETE_CHUNKED_ENCODING 200 에러

`<img src="" />`처럼 태그안이 비어있는지 확인.

`<img src="/download.do?fileNm=${fileNm}" />`과 같은 다운로드 URL을 사용하는 경우

해당 URL에 넘어가는 파라미터로 조회 시, 실제 파일이 넘어오는지 확인.

결국 저런 태그가 비어있어서 발생하는 문제.

> 최초에 문제 발생 후, 해당 태그들을 보여주는 부분을 주석 처리하여, 페이지에 한 번 접속이 가능 하자 그 후에는 주석처리 된 부분을 살려도 다시 에러가 발생하지 않는 상황도 발생.
