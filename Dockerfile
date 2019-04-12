FROM cjmason8/alpine-openjdk:jre-12.33-alpine

COPY target/authservice-0.0.1-SNAPSHOT.jar /app/authService.jar
COPY run.sh /app/run.sh

CMD ["/app/run.sh"]