FROM maven:3-eclipse-temurin-17 as build
WORKDIR /app

RUN apt-get -qqy update \
    && apt-get -qqy --no-install-recommends install \
    ca-certificates-java \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY . .
COPY conf/russian_trusted_root_ca_pem.crt conf/russian_trusted_sub_ca_pem.crt $JAVA_HOME/jre/lib/security/

RUN \
    cd $JAVA_HOME/jre/lib/security \
    && keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias russian_trusted_root_ca_pem -file russian_trusted_root_ca_pem.crt \
    && keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias russian_trusted_sub_ca_pem -file russian_trusted_sub_ca_pem.crt

RUN mvn verify

FROM eclipse-temurin:17
WORKDIR /app

RUN apt-get -qqy update \
    && apt-get -qqy --no-install-recommends install \
    ca-certificates-java \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY --from=build /app/target/client-jar-with-dependencies.jar ./client.jar
COPY conf/russian_trusted_root_ca_pem.crt conf/russian_trusted_sub_ca_pem.crt $JAVA_HOME/jre/lib/security/

RUN \
    cd $JAVA_HOME/jre/lib/security \
    && keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias russian_trusted_root_ca_pem -file russian_trusted_root_ca_pem.crt \
    && keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias russian_trusted_sub_ca_pem -file russian_trusted_sub_ca_pem.crt

ENTRYPOINT ["java", "-jar", "client.jar"]