---
layout: post
title: Naver Cloud Outbound Mailer API 가이드 For Java
description: >
  Naver Cloud Outbound Mailer API 가이드 For Java
sitemap: false
hide_last_modified: true
categories: [Java]
tags: [Java, API, Cloud Mail]
---

- Table of Contents
{:toc .large-only}

## 네이버 아웃 바운드 메일 사용하기

네이버 아웃바운드 메일러를 사용할 일이 있어

JAVA 구현 예시를 찾다가 다음을 발견하였다.

[yoshinari.tistory.com/39](yoshinari.tistory.com/39)

위 게시글을 참고하여 진행했다.

네이버 API 가이드에서 SDK를 다운받는다.

[docs.gov-ncloud.com/ko/email/email-1-3.html](docs.gov-ncloud.com/ko/email/email-1-3.html)

## 소스 내 설정

다운 받은 소스 내

nes-client-1.6.0G.jar 를 라이브러리에 추가하고

generated-code\src\main\java\com 에 있는 nbp 소스 전체를 프로젝트에 추가한다.

이후 아래 목록의 jar 파일들을 전부 다운받거나 pom 에 추가하여 프로젝트로 가져온다.

### pom.xml

```xml
<!-- https://mvnrepository.com/artifact/commons-codec/commons-codec -->
		<dependency>
			<groupId>commons-codec</groupId>
			<artifactId>commons-codec</artifactId>
			<version>1.11</version>
		</dependency>
		<!-- https://mvnrepository.com/artifact/org.apache.commons/commons-lang3 -->
		<dependency>
			<groupId>org.apache.commons</groupId>
			<artifactId>commons-lang3</artifactId>
			<version>3.7</version>
		</dependency>
		<!-- https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations -->
		<dependency>
			<groupId>com.fasterxml.jackson.core</groupId>
			<artifactId>jackson-annotations</artifactId>
			<version>2.9.3</version>
		</dependency>
		<!-- https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind -->
		<dependency>
			<groupId>com.fasterxml.jackson.core</groupId>
			<artifactId>jackson-databind</artifactId>
			<version>2.9.3</version>
		</dependency>
		<!-- https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-xml -->
		<dependency>
			<groupId>com.fasterxml.jackson.dataformat</groupId>
			<artifactId>jackson-dataformat-xml</artifactId>
			<version>2.9.3</version>
		</dependency>
		<!-- https://mvnrepository.com/artifact/com.googlecode.json-simple/json-simple -->
		<dependency>
			<groupId>com.googlecode.json-simple</groupId>
			<artifactId>json-simple</artifactId>
			<version>1.1.1</version>
		</dependency>
		<!-- https://mvnrepository.com/artifact/com.squareup.okhttp3/logging-interceptor -->
		<dependency>
			<groupId>com.squareup.okhttp3</groupId>
			<artifactId>logging-interceptor</artifactId>
			<version>3.9.1</version>
		</dependency>
		<!-- https://mvnrepository.com/artifact/com.squareup.okhttp3/okhttp -->
		<dependency>
			<groupId>com.squareup.okhttp3</groupId>
			<artifactId>okhttp</artifactId>
			<version>3.9.1</version>
		</dependency>
		<!-- https://mvnrepository.com/artifact/com.squareup.okio/okio -->
		<dependency>
			<groupId>com.squareup.okio</groupId>
			<artifactId>okio</artifactId>
			<version>2.2.2</version>
		</dependency>
		<!-- https://mvnrepository.com/artifact/org.jetbrains.kotlin/kotlin-runtime -->
		<dependency>
			<groupId>org.jetbrains.kotlin</groupId>
			<artifactId>kotlin-runtime</artifactId>
			<version>1.1.1</version>
		</dependency>
```

이후, 소스 내에 있는 credentials.properties 에 발급받은 API 키와 Secret 키를 작성 후, 프로젝트에 추가한다.

그 후, 아래의 코드를 넣고 실행하면 된다.

프로퍼티 경로는 실제 프로젝트에 존재하는 경로를 삽입하면된다.

아래는 실제 예제 동작 시, 동작했던 코드이다.

### Java Code

```java
public static void createMailRequest() {
        String propertiesLocation = "{properties 파일 위치}"
		ApiClient apiClient = new ApiClient.ApiClientBuilder()
        	.addMarshaller(JsonMarshaller.getInstance())
            .addMarshaller(XmlMarshaller.getInstance())
            .addMarshaller(FormMarshaller.getInstance())
            .setCredentials(new PropertiesFileCredentialsProvider(propertiesLocation)
            .getCredentials()).setLogging(true).build();
		// API 객체 생성
		V1Api apiInstance = new V1Api(apiClient);
		// 메일 수신자 리스트 작성.
		List<EmailSendRequestRecipients> esrrList = new ArrayList<EmailSendRequestRecipients>();
		// 수신자 리스트 설정
		EmailSendRequestRecipients esrr = new EmailSendRequestRecipients();
		esrr.setAddress("수신자이메일");
		esrr.setName("수신자이름");
		esrr.setType("R"); // 타입 고정 : R ( 일반 수신자 )
		esrrList.add(esrr);
		EmailSendRequest requestBody = new EmailSendRequest();
		// 메일 본문 작성
        String body = "{메일 내용, html 코드 및 내용 등}"
		// 요청에 본문 및 수신자 리스트 설정
		requestBody.setBody(body);
		requestBody.setRecipients(esrrList);
		// requestBody.setTemplateSid({templateID}); 템플릿 아이디 추가.
		// 발신자 정보 설정
		requestBody.setSenderAddress("발신자이메일");
		requestBody.setSenderName("발신자명");
		// 메일 제목 설정
		requestBody.setTitle(title);
		// 전송 확인 기능 설정
		requestBody.setConfirmAndSend(false);
		// 전달 언어 설정
		String X_NCP_LANG = "ko-KR"; // String | 언어 (ko-KR, en-US, zh-CN), default:en-US
		try {
			// Handler Successful response
			ApiResponse<EmailSendResponse> res = apiInstance.mailsPost(requestBody, X_NCP_LANG);
		} catch (ApiException e) {
			// Handler Failed response
			int statusCode = e.getHttpStatusCode();
			Map<String, List<String>> responseHeaders = e.getHttpHeaders();
			InputStream byteStream = e.getByteStream();
			e.printStackTrace();
		} catch (SdkException e) {
			// Handle exceptions that occurred before communication with the server
			e.printStackTrace();
		}
 }
```
