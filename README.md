
# Perfect-based Swift Test Server Project

## Description

This repository holds a test Swift server using the Perfect framework - you're free to clone or fork this project as long as Perfect License from which this project is derived are met.

The premise of this project is to prove that a Swift-based backend server is viable, using Docker as a container to allow deployment on any kind of system. This sample server has four endpoints on ports `8080` and `8081`: `/v1/calendar`, `/v1/calendar/status`, `/v1/users` and `/v1/users/status`. The first "non-status" endpoints read a Property List file, parse it and returns it as a JSON - the "status" endpoints return the last modified date of the aforementioned Property List files.

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

## Real-Time Statistics

Not happy with what we've achieved so far, we wanted to add a way to visualize what was going on behind the covers. Now, I know the "right way" of doing multiple services in Docker is through multiple containers - that said, since this is just an example, I thought I'd break the rules. The consequences are, of course, a 14-layer Dockerfile, but since you're not going to go through the pain of having to develop this, it'll all be straightforward to you.

For the real-time analytics we chose [GoAccess](http://goaccess.io/), which is free, and of course looks absolutely badass. There is, of course, a console view of all the data, but we thought the web solution lent itself better to our project.

What you need to do, is simply start the docker container providing a path to where you want GoAccess to write its `report.html` file with the real-time statistics:

```
docker run --dns=8.8.8.8 -p 7890:7890 -p 8080:8080 -p 8181:8181 -v [path-to-folder-with-real-time-html-site]:/PerfectServerTest/output -d perfect-server-test
```

Once it's up and running, you just need to open said `report.html` file in your browser, and through port `7890`, GoAccess will be updating the HTML live to your browser.

![Analytics test image.](https://github.com/the7thgoldrunner/perfect-server-test/blob/master/analytics.png)

## Further Information on the Perfect project
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
