#!/bin/sh

java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8001,suspend=n -Djava.security.egd=file:/dev/./urandom -jar /app/authService.jar