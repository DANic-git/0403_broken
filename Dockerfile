FROM maven:3-eclipse-temurin-17 as build
WORKDIR /app
COPY . .
COPY conf/russian_trusted_root_ca_pem.crt conf/russian_trusted_sub_ca_pem.crt /usr/share/pki/ca-trust-source/anchors/
RUN mvn verify

FROM eclipse-temurin:17
WORKDIR /app
COPY --from=build /app/target/client-jar-with-dependencies.jar ./client.jar
COPY conf/russian_trusted_root_ca_pem.crt conf/russian_trusted_sub_ca_pem.crt /usr/share/pki/ca-trust-source/anchors/
ENTRYPOINT ["java", "-jar", "client.jar"]