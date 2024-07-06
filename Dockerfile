FROM lolhens/baseimage-openjre
COPY target/springbootApp.jar springbootApp.jar
EXPOSE 80
ENTRYPOINT ["java", "-jar", "springbootApp.jar"]
