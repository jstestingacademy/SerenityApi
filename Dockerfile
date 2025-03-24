# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app
COPY . .

# Run tests and generate Serenity reports
RUN mvn clean verify -DskipTests=false -Dserenity.outputDirectory=/app/target/serenity-reports && \
    mvn serenity:aggregate -Dserenity.outputDirectory=/app/target/serenity-reports -Dserenity.reports=target/site/serenity && \
    ls -lah /app/target && \
    ls -lah /app/target/serenity-reports

# Run stage - Use Nginx to serve Serenity reports
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copy Serenity reports from correct location
COPY --from=builder /app/target/serenity-reports /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
