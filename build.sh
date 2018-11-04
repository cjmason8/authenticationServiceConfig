#!/bin/bash

set -e

FULL_IMAGE_NAME="auth-service"

while getopts ":p:d:" opt; do
  case $opt in
    # Provide commands to run
    p)
      PASSWORD="${OPTARG}"
    ;;
    d)
      GIT_PASS="${OPTARG}"
    ;;    
    \?)
      echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

git checkout master
git pull origin master

echo "Building version."
TAG_NAME=$(<VERSION)
TAG_NAME="${TAG_NAME%.*}.$((${TAG_NAME##*.}+1))"
echo $TAG_NAME > VERSION

echo "commiting bump version"
git config user.name "Release Manager"
git config user.email "Release.Manager@jenkins.com.au"
git add --all
git commit -m "bump version"
git push

echo "Beginning cleanup step."
echo "Removing docker images for: ${FULL_IMAGE_NAME}"
set +e
# Below to be implemented when docker has been updated to >1.10
#  docker rmi -f $(docker images --format "{{.Repository}}:{{.Tag}}" ${FULL_IMAGE_NAME}) 2> /dev/null
docker rmi $(docker images | grep "^${FULL_IMAGE_NAME}" | awk "{print $3}") 2> /dev/null
set -e

echo "Beginning preparation step."
if [ -z "${TAG_NAME}" ]; then
  echo "No tag name defined, unable to continue."
  exit 1
fi
if [[ "$(docker images -q ${FULL_IMAGE_NAME}:${TAG_NAME} 2> /dev/null)" == "" ]]; then

  echo "Creating image: ${FULL_IMAGE_NAME}:${TAG_NAME}"
  cd ../authenticationService
  mvn clean install
  cd ../authenticationServiceConfig
  mkdir -p target
  cp ../authenticationService/target/authservice-0.0.1-SNAPSHOT.jar target
  
  docker build --no-cache --pull -t ${FULL_IMAGE_NAME}:${TAG_NAME} .
fi

echo "Beginning publish step."
echo "Pushing image to repository: ${FULL_IMAGE_NAME}:${TAG_NAME}"
docker tag ${FULL_IMAGE_NAME}:${TAG_NAME} cjmason8/${FULL_IMAGE_NAME}:${TAG_NAME}
docker tag ${FULL_IMAGE_NAME}:${TAG_NAME} cjmason8/${FULL_IMAGE_NAME}:latest
docker push cjmason8/${FULL_IMAGE_NAME}:latest
docker push cjmason8/${FULL_IMAGE_NAME}:${TAG_NAME}
