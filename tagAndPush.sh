#!/bin/bash

FULL_IMAGE_NAME=$1
TAG_NAME=$2

echo "Beginning publish step."
echo "Pushing image to repository: ${FULL_IMAGE_NAME}:${TAG_NAME}"
docker tag ${FULL_IMAGE_NAME}:${TAG_NAME} cjmason8/${FULL_IMAGE_NAME}:${TAG_NAME}
docker tag ${FULL_IMAGE_NAME}:${TAG_NAME} cjmason8/${FULL_IMAGE_NAME}:latest
docker push cjmason8/${FULL_IMAGE_NAME}:latest
docker push cjmason8/${FULL_IMAGE_NAME}:${TAG_NAME}