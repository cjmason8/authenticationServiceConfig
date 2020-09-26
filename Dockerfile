FROM cjmason8/alpine-openjdk:x86_64-alpine-jre-15_36

COPY target/authservice-0.0.1-SNAPSHOT.jar /app/authService.jar
COPY run.sh /app/run.sh

CMD ["/app/run.sh"]