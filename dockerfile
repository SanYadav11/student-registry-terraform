FROM eclipse-temurin:17-jdk-jammy as build
WORKDIR /workspace
COPY .mvn/ .mvn
COPY mvnw .
COPY pom.xml .
COPY src ./src
RUN ./mvnw -DskipTests package

FROM eclipse-temurin:17-jre-jammy
COPY --from=build /workspace/target/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
