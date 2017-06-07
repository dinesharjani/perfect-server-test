
# Perfect-based Swift Test Server Project

## Description

This repository holds a test Swift server using the Perfect framework - you're free to clone or fork this project as long as Perfect License from which this project is derived are met.

The premise of this project is to prove that a Swift-based backend server is viable, using Docker as a container to allow deployment on any kind of system. This sample server has two endpoints on ports `8080` and `8081`: `/v1/calendar`and `/v1/calendar/status`. The first one reads a Property List file, parses it and returns it as a JSON - the second merely returns the last modified date of the aforementioned Property List file.

![Cover image.](https://github.com/the7thgoldrunner/perfect-server-test/blob/master/Postman.png)

## Swift Compatibility

The master branch of this project currently compiles with **Xcode 8.2** or the **Swift 3.0.2** toolchain on Ubuntu.

## Building & Running

You can build and run this project on MacOS or as a Docker container. For the first, just open the `.xcodeproj` file and perform a `Build and Run`. If you need to or want to generate a fresh `Xcode` project file, just type from the root project's folder:

```
swift package generate-xcodeproj
```

For the second, follow these steps:

```
docker build -t perfect-server-test .
docker run --dns=8.8.8.8 -p 8080:8080 -p 8181:8181 -d perfect-server-test
```

You will now be able to hit both endpoints at `localhost:8080/v1/calendar` and `localhost:8080/v1/calendar/status`. You can test this with your Browser, with a utility such as [Postman](https://www.getpostman.com/), or even from a mobile device connected to the same network:

![Browser test image.](https://github.com/the7thgoldrunner/perfect-server-test/blob/master/iPhone.png)

## Further Information on the Perfect project
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
