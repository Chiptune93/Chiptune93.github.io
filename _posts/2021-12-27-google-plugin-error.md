---
title: In plugin 'com.google.cloud.tools.jib' type 'com.google.cloud.tools.jib.gradle.BuildImageTask' property 'jib.allowInsecureRegistries' of type boolean shouldn't be annotated with @Optional.
categories: [Error]
tags: [google cloud error, jib error, jib]
---

## 문제

```bash
> Task :project_name:jib FAILED
:project_name:jib (Thread[Execution worker for ':' Thread 3,5,main]) completed. Took 0.001 secs.

FAILURE: Build failed with an exception.

* What went wrong:
Some problems were found with the configuration of task ':project_name:jib' (type 'BuildImageTask').
  - In plugin 'com.google.cloud.tools.jib' type 'com.google.cloud.tools.jib.gradle.BuildImageTask' property 'jib.allowInsecureRegistries' of type boolean shouldn't be annotated with @Optional.

    Reason: Properties of primitive type cannot be optional.

    Possible solutions:
      1. Remove the @Optional annotation.
      2. Use the java.lang.Boolean type instead.

    Please refer to https://docs.gradle.org/7.2/userguide/validation_problems.html#cannot_use_optional_on_primitive_types for more details about this problem.
  - In plugin 'com.google.cloud.tools.jib' type 'com.google.cloud.tools.jib.gradle.BuildImageTask' property 'jib.container.useCurrentTimestamp' of type boolean shouldn't be annotated with @Optional.

    Reason: Properties of primitive type cannot be optional.

    Possible solutions:
      1. Remove the @Optional annotation.
      2. Use the java.lang.Boolean type instead.

    Please refer to https://docs.gradle.org/7.2/userguide/validation_problems.html#cannot_use_optional_on_primitive_types for more details about this problem.

* Try:
Run with --stacktrace option to get the stack trace. Run with --debug option to get more log output. Run with --scan to get full insights.

* Get more help at https://help.gradle.org

BUILD FAILED in 2s
7 actionable tasks: 1 executed, 6 up-to-date
```

## 현상

jib 플러그인을 통한 이미지 업로드 실행 중 발생한 에러

## 해결

jib 버전을 1.4.0 에서 1.8.0 으로 업그레이드. gradle 6.9 였을 때는 문제 없었는데, 7버전 대로 올라오면서 버전 호환이 안맞는 듯 하다.
