FROM cjmason8/alpine-openjdk:openjdk-17-alpine

COPY target/authservice-0.0.1-SNAPSHOT.jar /app/authService.jar
COPY run.sh /app/run.sh

CMD ["/app/run.sh"]