---

title: Apple M1 Docker Build Error
description: >
  Apple M1 Docker Build Error


categories: [Error]
tags: [apple m1, apple docker, docker error, m1 docker error]
---



## 문제

Apple M1 칩을 사용하는 환경에서 Docker 이미지 빌드 시, 문제 발생. 리눅스 환경에서 해당 이미지가 구동이 안되며 환경이 맞지 않다는 에러를 뱉어내었다.

## 해결

조금만 구글링 해보니 바로 나왔는데, 해결 방법은 이미지 빌드 시, 특정 키워드를 추가하면 된다.

- as-is : docker build -t <username>/<imagename>
- to-be : docker build --platform linux/amd64 -t <username>/<imagename>

```bash
--platform {환경명}
```

[https://stackoverflow.com/questions/66662820/m1-docker-preview-and-keycloak-images-platform-linux-amd64-does-not-match-th](https://stackoverflow.com/questions/66662820/m1-docker-preview-and-keycloak-images-platform-linux-amd64-does-not-match-th)
