---
title: Spring Boot - 파일 업로드 만들기 -1-
categories: [Spring]
tags: [fileupload, SpringBoot, springboot fileupload]
---

## 작업환경
늘 사용하지만, 직접 만들어 보지는 못했던 파일 업로드 만들기를 해 볼 생각이다.

작업 환경은 다음과 같다.

1. Java 11

2. Spring Boot 2.6.4

3. Gradle 7.2 

4. War 배포 사용


## 정의
FileUpload / Download 서비스는 다음을 전제로 개발하기로 한다.



1. Front에서 MultipartRequest로 파일 요청을 받는다. 폼 태그 내에서 Submit하는 방식을 우선적으로 구현한다.

2. Back에서는 이를 받아 서버에 저장하고, 관련 정보를 DB에 저장한다.

3. 서버 경로에 저장하는 과정에는 확장자 등에 대해 예외처리는 실시 한다.

4. 파일 업로드는 다중 업로드를 지원해야 하며, 필요 시 외부 라이브러리를 사용하여 업로드 한다.

5. 추후, 1-4 구현 시 Form Submit 외에 Axios 등을 이용한 ajax 호출로도 구현을 실시한다. 
그리하며, 두 가지 방식을 전부 지원하도록 하여 최종적으로는 모듈로 분리하여 사용가능하도록 한다.



## 작업
우선 기본적으로 프로젝트 세팅 및 기본 기능 테스트 부터 진행한다.

프로젝트는 vs code에서 initailize gradle project를 이용해 생성했고 아래와 같은 내용을 추가 했다.

>build.gradle

```gradle
plugins {
	id 'org.springframework.boot' version '2.6.4'
	id 'io.spring.dependency-management' version '1.0.11.RELEASE'
	id 'java'
	id 'war'
}

group = 'com.file'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '11'

repositories {
	mavenCentral()
}

dependencies {
	implementation 'org.springframework.boot:spring-boot-starter-web'
	providedRuntime 'org.springframework.boot:spring-boot-starter-tomcat'
	testImplementation 'org.springframework.boot:spring-boot-starter-test'
	
	// dev tool ( 정적 리소스 재시작없이 적용 )
	implementation group: 'org.springframework.boot', name: 'spring-boot-devtools'

	// jstl 
	implementation group: 'javax.servlet', name: 'jstl', version: '1.2'

	// jasper
	implementation group: 'org.apache.tomcat', name: 'tomcat-jasper', version: '9.0.56'
}

tasks.named('test') {
	useJUnitPlatform()
}
```

>application.yml

```yml
spring:
    application:
        name: file-upload-test
    servlet:
        multipart:
            location: /Users/dk/Documents/GitHub/Library/Spring/FileUpload/SpringBoot/example/src/main/resources/upload
    mvc:
        view:
            prefix: /WEB-INF/views/
            suffix: .jsp
```

>indexController.java

```java
package com.file.example.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class IndexController {

    /*
     * @GetMapping("/")
     * public ModelAndView index() {
     * return new ModelAndView("/index.html");
     * }
     */

    @GetMapping("/")
    public ModelAndView index2() {
        return new ModelAndView("/index");
    }

}
```

>FileUploadController.java

```java
package com.file.example.controller;

import com.file.example.service.FileUploadService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartRequest;

@RestController
public class FileUploadController {

    @Autowired
    FileUploadService fsvc;

    @PostMapping("/upload.do")
    public void upload(MultipartRequest req) {
        System.out.println("＃＃＃＃＃＃＃＃＃＃＃ [LOG] : " + req + "＃＃＃＃＃＃＃＃＃＃＃");
        fsvc.save(req);
    }
}
```

>FileUploadService.java - FileStorageService 상속.

```java
package com.file.example.service;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import com.file.example.ifc.FileStorageService;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

@Service
public class FileUploadService implements FileStorageService {

    @Value("${spring.servlet.multipart.location}")
    private String uploadPath;

    @Override
    public void init() {

    }

    @Override
    public void save(MultipartRequest req) {
        MultipartFile file = req.getFile("singleFile");
        try {
            if (file.isEmpty()) {
                throw new Exception("ERROR : file is empty");
            }
            Path root = Paths.get(uploadPath);
            System.out.println("＃＃＃＃＃＃＃＃＃＃＃ [LOG] : " + root + "＃＃＃＃＃＃＃＃＃＃＃");
            System.out.println("＃＃＃＃＃＃＃＃＃＃＃ [LOG] : " + uploadPath + "＃＃＃＃＃＃＃＃＃＃＃");
            if (!Files.exists(root)) {
                try {
                    Files.createDirectories(Paths.get(uploadPath));
                } catch (Exception e) {
                    throw new Exception("ERROR : can't makr dir");
                }
            }
            try {
                InputStream is = file.getInputStream();
                Files.copy(is, root.resolve(file.getOriginalFilename()), StandardCopyOption.REPLACE_EXISTING);
            } catch (Exception e) {
                throw new Exception("ERROR : can't makr dir");
            }
        } catch (Exception e) {
            throw new RuntimeException("ERROR : can't save file !");
        }
    }

}
```

>FileStorageService.java

```java
package com.file.example.ifc;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

public interface FileStorageService {
    void init();

    void save(MultipartRequest req);

}
```

우선 이 정도까지만 작성하고 테스트 해보았을 때는, 정상적으로 동작했다. application.yml 의 경로는 해당 프로젝트 내부 경로로 임시로 잡았다. 만약 해당 환경이 운영으로 넘어간다면, 업로드 하고자 하는 곳의 경로를 절대경로로 삽입하면 될 것이다. 



베이스만 잡아놓고, 천천히 스텝 바이 스텝으로 진행할 예정이다.

