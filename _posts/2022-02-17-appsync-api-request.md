---
layout: post
title: App Sync - Java 에서 AppSync Api Request 보내는 예제.
description: >
  [App Sync] Java 에서 AppSync Api Request 보내는 예제.

hide_last_modified: true
categories: [AWS]
tags: [AWS, AppSync, api request]
---

- Table of Contents
{:toc .large-only}

## 소스 주소

https://github.com/Chiptune93/Library/blob/main/AWS/AppSync/Java/AppSync.java

참고
https://www.baeldung.com/aws-appsync-spring

## 소스 내용

```java
package package;

import java.net.URISyntaxException;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.client.WebClient;

/**
 * @since 2022.02.15
 * @author DK
 * @apiNote AppSyncTest JAVA --> AppSync request Query
 */
public class AppSyncTest {

    // AppAync Api Arn
    String url = "{your api url}";

    // AppSync Api Key
    String apiKey = "{your api key}";

    /**
     *
     * @param id   아이디
     * @param name 이름
     * @return response string
     * @throws URISyntaxException
     */
    public String monitoringAppSyncCall(String id, String name) throws URISyntaxException {

        WebClient client = WebClient.builder().baseUrl(url).build();

        // Do not miss this data form
        // if this query return 400 , your query string wrong 100%
        String queryString = "{\"query\":\"mutation MyMutation { createAppSyncTest"
                + "( input: { "
                + "id:\\\"" + id + "\\\", "
                + "name:\\\"" + name + "\\\", "
                + "})"
                + "{ "
                + "id "
                + "name "
                + "}}\"}";

        System.out.println("＃＃＃＃＃＃＃＃＃＃＃ [LOG] APP AYNC QUERY : " + queryString + "＃＃＃＃＃＃＃＃＃＃＃");

        String response = client
                .post()
                .uri("/graphql")
                .header("x-api-key", apiKey)
                .header("Content-Type", "application/json")
                .header("Content-Type", "application/graphql")
                .contentType(MediaType.APPLICATION_JSON)
                .accept(MediaType.APPLICATION_JSON)
                .bodyValue(queryString)
                .retrieve()
                .bodyToMono(String.class)
                .block();

        System.out.println("＃＃＃＃＃＃＃＃＃＃＃ [LOG] APP SYNC RESPONSE : " + response + "＃＃＃＃＃＃＃＃＃＃＃");
        return response;

    }

}
```
