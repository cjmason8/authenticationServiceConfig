#!/bin/bash

RANCHER_ACCESS_KEY=$1
RANCHER_SECRET_KEY=$2
RANCHER_URL=$3
ENV_NAME=$4
PROJECT_NAME=auth-service
BASE_DIR=${PWD}
TAG_NAME=$(<VERSION)

if [ $ENV_NAME == "lcl" ]; then
  TAG_NAME=$(<LOCAL)
fi

echo -e "TAG_NAME=$TAG_NAME" > env.txt

echo "Force pulling..."
rancher-compose --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} -e env.txt -p authService -f ${BASE_DIR}/${ENV_NAME}/docker-compose-${ENV_NAME}.yml pull

echo "Starting deployment..."
rancher-compose --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} -r ${BASE_DIR}/rancher-compose.yml -e env.txt -p authService -f ${BASE_DIR}/${ENV_NAME}/docker-compose-${ENV_NAME}.yml up --upgrade -d --pull --batch-size 1

if [ $? -eq 0 ]; then
  echo "Deploy success! Confirming..."
  rancher-compose --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} -e env.txt -p authService -f ${BASE_DIR}/${ENV_NAME}/docker-compose-${ENV_NAME}.yml up --confirm-upgrade -d --batch-size 1
else
  echo "Deploy failed :( rolling back..."
  rancher-compose --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} -e env.txt -p authService -f ${BASE_DIR}/${ENV_NAME}/docker-compose-${ENV_NAME}.yml up --rollback -d --batch-size 1
fi
