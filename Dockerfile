FROM maven:3-eclipse-temurin-17 as build
WORKDIR /app
COPY . .
RUN mvn verify

FROM eclipse-temurin:17
WORKDIR /app
COPY --from=build /app/target/client-jar-with-dependencies.jar ./client.jar
ENTRYPOINT ["java", "-jar", "client.jar"]