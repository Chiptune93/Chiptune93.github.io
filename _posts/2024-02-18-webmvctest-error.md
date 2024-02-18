---
title: JPA metamodel must not be empty
categories: [Etc, Error]
tags: [webmvctest, junit5]
---

## Webmvc 테스트 과정에서 에러 발생.

### 실행환경

- java17 + Kotlin
- Springboot 3.2.X
- 다음과 같이 테스트를 구성하고 실행했는데, 에러가 발생했다.

```kotlin
@WebMvcTest(FileController::class)
class FileControllerTest {

    @Autowired
    private lateinit var mockMvc: MockMvc

    @MockBean
    private lateinit var fileComponent: FileComponent

    @Test
    fun testFileUpload() {
        val fileContent = ClassPathResource("sample/image/SampleJPGImage_5mbmb.jpg").inputStream.readBytes()
        val multipartFile =
            MockMultipartFile("file", "SampleJPGImage_5mbmb.jpg", MediaType.IMAGE_JPEG_VALUE, fileContent)
        mockMvc.perform(
            MockMvcRequestBuilders.multipart("/file/upload")
                .file(multipartFile)
        )
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andDo(MockMvcResultHandlers.print())
    }

    @Test
    fun `test uploadFile with single file`() {
        val mockFile = MockMultipartFile("file", "test.txt", "text/plain", "Test content".toByteArray())

        // 수정된 부분: 적절한 인자 매처 사용
        `when`(fileComponent.upload(mockFile)).thenReturn(
            FileGroupDTO(
                1L, "N", 1024L, mutableListOf()
            )
        )

        mockMvc.perform(multipart("/file/upload").file(mockFile))
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.responseMessage").value("파일 업로드에 성공 하였습니다."))
    }

    @Test
    fun `test downloadFile`() {
        val downloadDto = FileDownloadDTO( // 가정: DownloadDto가 올바른 클래스라고 가정
            downloadFile = ByteArrayResource("Test content".toByteArray()),
            downloadFileName = "test.txt",
            downloadFileType = MediaType.TEXT_PLAIN,
            downloadFileUrl = ""
        )

        // 수정된 부분: 적절한 인자 매처 사용
        `when`(fileComponent.download(anyLong())).thenReturn(downloadDto)

        mockMvc.perform(MockMvcRequestBuilders.get("/file/download").param("fileGroupSeq", "1"))
            .andExpect(status().isOk)
            .andExpect(content().contentType("text/plain"))
            .andExpect(header().string(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=test.txt"))
    }
}

```

## 원인

해당 에러의 표면적 원인은 `@EnableJpaAuditing` 을 `main` 클래스에 추가한 것이다.
해당 어노테이션은 베이스 엔티티에서 생성 시간이나 업데이트 시간 같은 항목을 자동으로 입력하기 위해
사용하려고 선언 했던 것이다.

하지만, 단순히 선언 했기 때문에 문제가 되었던 것은 아니고, 테스트에서 사용했던 `@WebMvcTest` 에 
원인이 있었다.

## 알아보기

해당 어노테이션의 [인터페이스 설명](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/test/autoconfigure/web/servlet/WebMvcTest.html)에 가보면
다음과 같이 나온다.

> 이 주석을 사용하면 전체 자동 구성이 비활성화되고 대신 MVC 테스트와 관련된 구성만 적용됩니다(예: @Controller, @ControllerAdvice, @JsonComponent, Converter/ GenericConverter, Filter및 bean은 적용되지 않고 , 또는 bean은 적용 WebMvcConfigurer 되지 않음 ). HandlerMethodArgumentResolver@Component@Service@Repository
기본적으로 주석이 달린 테스트는 @WebMvcTestSpring Security를 ​​자동으로 구성하며 MockMvcHtmlUnit WebClient 및 Selenium WebDriver에 대한 지원도 포함합니다. MockMVC를 보다 세밀하게 제어하려면 @AutoConfigureMockMvc주석을 사용할 수 있습니다.
일반적으로 Bean 에 필요한 협력자를 생성하거나 조합 @WebMvcTest하여 사용됩니다 . @MockBean@Import@Controller
전체 애플리케이션 구성을 로드하고 MockMVC를 사용하려는 경우 이 주석보다는 @SpringBootTest결합을 고려해야 합니다

즉, 해당 어노테이션을 사용할 경우, 전체 빈이 로드되지 않고 MVC와 관련된 부분만 올라오기 때문에
해당 어노테이션의 설정이 자동 로드 되지 않았던 것이다.

## 해결 방법

1. Configuration 설정을 별도 분리하여 @EnableJpaAuditing를 추가한다.
2. JpaMetaModelMappingContext 클래스의 MockBean을 추가한다.


### 빈 분리

- 아래와 같이 설정 파일을 따로 생성하여 추가한다.

```kotlin
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

// 기본 Jpa Auditing Listener 사용을 허용.
@Configuration
@EnableJpaAuditing
public class JpaAuiditingConfig {}
```

### 테스트에 MockBean 추가

- 아래와 같이 테스트 클래스에 MockBean을 생성하여 추가한다.

```kotlin
@MockBean(JpaMetamodelMappingContext.class)
@WebMvcTest(FileController::class)
class FileControllerTest {
  //...
}
```
