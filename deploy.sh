#!/bin/bash

RANCHER_ACCESS_KEY=AA57D92145E412E26C0D
RANCHER_SECRET_KEY=N519UCmNmqq2AD7ti8EYxEVUv1PwyFpcJyGWeqUm
RANCHER_URL=http://localhost:8080/v2-beta/projects/1a5
ENV_NAME=lcl
PROJECT_NAME=auth-service
BASE_DIR=${PWD}
TAG_NAME=0.1.35

echo -e "TAG_NAME=$TAG_NAME" > env.txt

echo "Force pulling..."
rancher-compose --url ${RANCHER_URL} --access-key AA57D92145E412E26C0D --secret-key N519UCmNmqq2AD7ti8EYxEVUv1PwyFpcJyGWeqUm -e env.txt -p expenseManager-${ENV_NAME} -f ${BASE_DIR}/${ENV_NAME}/docker-compose-${ENV_NAME}.yml pull

echo "Starting deployment..."
rancher-compose --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} -r ${BASE_DIR}/rancher-compose.${PROJECT_NAME}.yml -e env.txt -p expenseManager-${ENV_NAME} -f ${BASE_DIR}/${ENV_NAME}/docker-compose-${ENV_NAME}.yml up --upgrade -d --pull --batch-size 1

if [ $? -eq 0 ]; then
  echo "Deploy success! Confirming..."
  rancher-compose --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} -e env.txt -p expenseManager-${ENV_NAME} -f ${BASE_DIR}/${ENV_NAME}/docker-compose-${ENV_NAME}.yml up --confirm-upgrade -d --batch-size 1
else
  echo "Deploy failed :( rolling back..."
  rancher-compose --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} -e env.txt -p expenseManager-${ENV_NAME} -f ${BASE_DIR}/${ENV_NAME}/docker-compose-${ENV_NAME}.yml up --rollback -d --batch-size 1
fi
