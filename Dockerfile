FROM maven:3-eclipse-temurin-17 as build
WORKDIR /app

COPY . .
COPY conf/russian_trusted_root_ca_pem.crt /usr/local/share/ca-certificates/russian_trusted_root_ca_pem.crt

RUN keytool -import -noprompt -trustcacerts -alias russian_trusted_root_ca_pem -file /usr/local/share/ca-certificates/russian_trusted_root_ca_pem.crt -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit
RUN update-ca-certificates

RUN mvn verify

FROM eclipse-temurin:17
WORKDIR /app
ENV SSL_CERT_FILE /usr/local/share/ca-certificates/russian_trusted_root_ca_pem.crt
COPY --from=build /app/target/client-jar-with-dependencies.jar ./client.jar
COPY conf/russian_trusted_root_ca_pem.crt /usr/local/share/ca-certificates/russian_trusted_root_ca_pem.crt

RUN keytool -import -noprompt -trustcacerts -alias russian_trusted_root_ca_pem -file /usr/local/share/ca-certificates/russian_trusted_root_ca_pem.crt -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit
RUN update-ca-certificates

ENTRYPOINT ["java", "-jar", "client.jar"]