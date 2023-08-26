---
title: ControllerAdvice, ExceptionHandler Annotation
categories: [Backend, Spring]
tags: [Spring, SpringBoot, ControllerAdvice, ExceptionHandler]
---

## **ControllerAdvice && ExceptionHandler**

### @ExceptionHandler

예를 들어, 서비스에서 발생하는 예외를 처리하기 위해 UserServiceException 클래스를 정의하고, UserController 클래스에서 이 예외를 처리하고자 할 때 다음과 같이 코드를 작성할 수 있습니다.

```java
public class UserServiceException extends RuntimeException {
    public UserServiceException(String message) {
        super(message);
    }
}
```


```java
@RestController
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("/{userId}")
    public ResponseEntity<UserDto> getUserById(@PathVariable("userId") String userId) {
        UserDto userDto = userService.getUserById(userId);
        return ResponseEntity.ok(userDto);
    }

    @PostMapping
    public ResponseEntity<UserDto> createUser(@RequestBody UserDto userDto) {
        UserDto createdUserDto = userService.createUser(userDto);
        return ResponseEntity.created(URI.create("/users/" + createdUserDto.getId())).body(createdUserDto);
    }

    @ExceptionHandler(value = {UserServiceException.class})
    public ResponseEntity<String> handleUserServiceExceptions(UserServiceException ex) {
        return ResponseEntity.badRequest().body("An error occurred: " + ex.getMessage());
    }
}
```

위의 예제에서는 @ExceptionHandler 어노테이션을 이용하여 UserServiceException을 처리하는 handleUserServiceExceptions 메서드를 정의하였습니다. 이렇게 각 컨트롤러에서 예외 처리를 정의하면 코드의 중복이 발생할 수 있습니다.

### @ContollerAdvice
Spring Framework에서는 @ControllerAdvice와 @ExceptionHandler 어노테이션을 이용하여 예외 처리를 분리하고 통합할 수 있습니다.

@ControllerAdvice 어노테이션은 전역적으로 예외 처리를 담당하는 클래스를 정의할 때 사용됩니다. 즉, 해당 클래스에서 예외 발생 시 처리할 수 있습니다. 

이 어노테이션을 사용하면 여러 개의 컨트롤러에서 발생하는 예외를 하나의 클래스에서 처리할 수 있어서 코드의 중복을 줄일 수 있습니다.

이전 예제를 @ControllerAdvice를 이용하여 수정하면 다음과 같습니다.

```java
@ControllerAdvice
public class ExceptionHandlerAdvice {
    @ExceptionHandler(value = {UserServiceException.class})
    public ResponseEntity<String> handleUserServiceExceptions(UserServiceException ex) {
        return ResponseEntity.badRequest().body("An error occurred: " + ex.getMessage());
    }
}

@RestController
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("/{userId}")
    public ResponseEntity<UserDto> getUserById(@PathVariable("userId") String userId) {
        UserDto userDto = userService.getUserById(userId);
        return ResponseEntity.ok(userDto);
    }

    @PostMapping
    public ResponseEntity<UserDto> createUser(@RequestBody UserDto userDto) {
        UserDto createdUserDto = userService.createUser(userDto);
        return ResponseEntity.created(URI.create("/users/" + createdUserDto.getId())).body(createdUserDto);
    }
}

@Service
public class UserService {

    private List<User> users = new ArrayList<>();

    public void addUser(User user) {
        users.add(user);
    }

    public User getUserById(int id) throws UserNotFoundException {
        for (User user : users) {
            if (user.getId() == id) {
                return user;
            }
        }
        throw new UserNotFoundException("User with id " + id + " not found");
    }

}

```
위의 예제에서는 @ControllerAdvice 어노테이션을 사용하여 ExceptionHandlerAdvice 클래스를 전역 예외 처리 클래스로 정의하였습니다. 

이 클래스에서는 @ExceptionHandler 어노테이션을 이용하여 UserServiceException을 처리하도록 정의하였습니다. 이렇게 하면 UserController에서 UserServiceException을 처리하는 코드가 제거되어 코드의 중복을 줄일 수 있습니다.