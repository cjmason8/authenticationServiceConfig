#!/bin/bash

FULL_IMAGE_NAME=$1
TAG_NAME=$2

echo "Beginning cleanup step."
echo "Removing docker images for: ${FULL_IMAGE_NAME}"
set +e
# Below to be implemented when docker has been updated to >1.10
#  docker rmi -f $(docker images --format "{{.Repository}}:{{.Tag}}" ${FULL_IMAGE_NAME}) 2> /dev/null
docker rmi $(docker images | grep "^${FULL_IMAGE_NAME}" | awk "{print $3}") 2> /dev/null

echo "Beginning preparation step."
if [ -z "${TAG_NAME}" ]; then
  echo "No tag name defined, unable to continue."
  exit 1
fi

echo "Creating image: ${FULL_IMAGE_NAME}:${TAG_NAME}"

echo "start gradle"
docker run --rm -u gradle -v "/jenkinsHome/workspace/auth-service-pipeline/authService":/home/gradle/project -w /home/gradle/project gradle gradle -Dskip.tests build

#docker run --rm -v "/jenkinsHome/workspace/auth-service-pipeline/authenticationService":/usr/src/mymaven -u 1000:1000 \
#    -v "/home/tomcat/.m2":/var/maven/.m2 -e MAVEN_CONFIG=/var/maven/.m2 -w /usr/src/mymaven maven:3.8.1-openjdk-17 \
#    mvn -Duser.home=/var/maven clean install --no-transfer-progress
mkdir -p target
cp authService/build/libs/authservice-0.0.1-SNAPSHOT.jar target

docker build --no-cache --pull -t ${FULL_IMAGE_NAME}:${TAG_NAME} .