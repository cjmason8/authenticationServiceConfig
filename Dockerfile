FROM cjmason8/alpine-openjdk:jre-11.0.2.9-alpine-v2

#RUN adduser -D -u 1000 localUser

#RUN mkdir /app

#RUN chown localUser /app

#RUN apk update
#RUN apk add curl

COPY target/authservice-0.0.1-SNAPSHOT.jar /app/authService.jar
COPY run.sh /app/run.sh

#USER localUser

CMD ["/app/run.sh"]