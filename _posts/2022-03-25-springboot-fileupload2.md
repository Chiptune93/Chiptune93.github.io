---

title: Spring Boot - 파일 업로드 만들기 -2-
description: >
    [Spring Boot] 파일 업로드 만들기 -2-


categories: [Spring]
tags: [fileupload, springboot, springboot fileupload]
---



## 진행내역
이번에 진행한 것은 간단하게, 업로드 된 파일의 정보를 DB에 저장하는 기능을 구현했다.

별다른 로직은 없고 단순 정보를 가져와 DB에 저장한다.


> build.gradle : DB관련 라이브러리 추가 (DB는 Docker 베이스의 Postgres 사용)

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

	// DB관련 라이브러리. log4j로 추후 로그 사용 고려
	// mybatis-spring-boot
	implementation group: 'org.mybatis.spring.boot', name: 'mybatis-spring-boot-starter', version: '2.1.4'

	// jdbc ( postgresql - jdbc driver )
	implementation group: 'org.postgresql', name: 'postgresql', version: '42.3.1'

	// log4j2
	implementation group: 'org.bgee.log4jdbc-log4j2', name: 'log4jdbc-log4j2-jdbc4.1', version: '1.16'   
}

tasks.named('test') {
	useJUnitPlatform()
}
```

>application.yml : DB설정 추가

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
    # DB 추가.
    datasource:
        hikari:
            jdbc-url: jdbc:log4jdbc:postgresql://localhost:5432/postgres
            driver-class-name: net.sf.log4jdbc.sql.jdbcapi.DriverSpy
            username: postgres
            password: postgres
            maximum-pool-size: 5
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

    /**
     * 파일업로드1 - 단순 파일 서버 경로(프로젝트 경로) 업로드
     * 
     * @param req
     */
    @PostMapping("/upload.do")
    public void upload(MultipartRequest req) {
        System.out.println("＃＃＃＃＃＃＃＃＃＃＃ [LOG] : " + req + "＃＃＃＃＃＃＃＃＃＃＃");
        fsvc.save(req);
    }

    /**
     * 파일업로드2 - 서버에 업로드 후, 파일 정보 DB 저장
     * 
     * @param req
     */
    @PostMapping("/upload2.do")
    public void upload2(MultipartRequest req) {
        System.out.println("＃＃＃＃＃＃＃＃＃＃＃ [LOG] : " + req + "＃＃＃＃＃＃＃＃＃＃＃");
        fsvc.save2(req);
    }
}
```

>FileUploadService.java

```java
package com.file.example.service;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;

import com.file.example.ifc.FileStorageService;
import com.file.example.repository.FileUploadRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

@Service
public class FileUploadService implements FileStorageService {

    @Value("${spring.servlet.multipart.location}")
    private String uploadPath;

    @Autowired
    FileUploadRepository rpt;

    @Override
    public void init() {

    }

    /**
     * 파일업로드1
     */
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

    /**
     * 파일업로드2
     */
    @Override
    public void save2(MultipartRequest req) {
        MultipartFile file = req.getFile("singleFile2");
        try {
            if (file.isEmpty()) {
                throw new Exception("ERROR : file is empty");
            }
            Path root = Paths.get(uploadPath);
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
            // 파일정보 저장
            String fileName = file.getOriginalFilename();
            String fileSize = Long.toString(file.getSize());
            String fileType = file.getContentType();
            String filePath = uploadPath + "/" + fileName;

            HashMap<String,String> fileMap = new HashMap<String,String>();
            fileMap.put("fileName", fileName);
            fileMap.put("fileSize", fileSize);
            fileMap.put("fileType", fileType);
            fileMap.put("filePath", filePath);

            rpt.insertFile(fileMap);

        } catch (Exception e) {
            throw new RuntimeException("ERROR : can't save file !");
        }
    }

}
```

>FileUploadRepository.xml (Repository는 인터페이스로 잡아서 생략)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.file.example.repository.FileUploadRepository">
    <insert id="insertFile" parameterType="HashMap">
        insert into file (
            seq
            ,file_name
            ,file_path
            ,file_type
            ,file_size
        ) values (
            nextval('seq')
            ,#{fileName}
            ,#{filePath}
            ,#{fileType}
            ,#{fileSize}
        )
    </insert>
</mapper>
```

>FileStorageService.java

```java
package com.file.example.ifc;

import org.springframework.web.multipart.MultipartRequest;

public interface FileStorageService {
    void init();
    
    /**
     * Basic File Upload
     * jsp form --> multipartRequest
     * Server File Dir upload 
     * @param req
     */
    void save(MultipartRequest req);

    /**
     * File Upload 2
     * upload 1 + file information + insert DB
     */
    void save2(MultipartRequest req);

}
```

- 업로드 화면

![fileupload1](/assets/img/Spring/fileupload1.png)


- DB에 저장된 모습

![fileupload2](/assets/img/Spring/fileupload2.png)


DB에 파일 저장하는 것까지 했으니, 다음번에는 아래 내용을 진행할 예정이다.

1. 서버 사이드에서 예외처리 (확장자 등)

2. 파일 이름 무작위로 변경 (특정랜덤문자열)

3. 파일 업로드 함수 공통 처리(모듈화)

이후, 다중 업로드 및 기타 처리를 하면 될 것 같다.


사용된 소스는 아래에서 사용 가능하다.

https://github.com/Chiptune93/Library/tree/main/Spring/FileUpload/SpringBoot/example








