#!/bin/bash

FULL_IMAGE_NAME=cjmason8/auth-service
TAG_NAME=$(<LOCAL)

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

TAG_NAME="${TAG_NAME%.*}.$((${TAG_NAME##*.}+1))"
echo $TAG_NAME > LOCAL

echo "Creating image: ${FULL_IMAGE_NAME}:${TAG_NAME}"

#echo "maven"
cd ../authservice
#docker run --rm -v "$PWD":/usr/src/mymaven -u 1000:1000 -v "$HOME/.m2":/var/maven/.m2 -e MAVEN_CONFIG=/var/maven/.m2 -w /usr/src/mymaven maven:3.8.1-openjdk-17 \
#      mvn -Duser.home=/var/maven clean install --no-transfer-progress

docker run --rm -u gradle -v "$PWD":/home/gradle/project -w /home/gradle/project gradle gradle -Dskip.tests build
cd ../authenticationServiceConfig
mkdir -p target
cp ../authservice/build/libs/authservice-0.0.1-SNAPSHOT.jar target

docker build --no-cache --pull -t ${FULL_IMAGE_NAME}:${TAG_NAME} .