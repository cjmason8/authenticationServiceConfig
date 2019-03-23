FROM cjmason8/alpine-openjdk:jre-11.0.2.9-alpine-v2

COPY target/authservice-0.0.1-SNAPSHOT.jar /app/authService.jar
COPY run.sh /app/run.sh

CMD ["/app/run.sh"]