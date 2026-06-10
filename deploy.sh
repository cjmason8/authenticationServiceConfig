#!/bin/bash

RANCHER_ACCESS_KEY=$1
RANCHER_SECRET_KEY=$2
RANCHER_URL=$3
ENV_NAME=$4
COMPOSE_PROJECT_NAME=authService
COMPOSE_FILE=${PWD}/${ENV_NAME}/docker-compose-${ENV_NAME}.yml
TAG_NAME=$(<VERSION)

if [ $ENV_NAME = "lcl" ]; then
  TAG_NAME=$(<LOCAL)
fi

# Load AWS credentials from .env file if it exists
if [ -f .env ]; then
  echo "Loading AWS credentials from .env file..."
  export $(grep -v '^#' .env | xargs)
else
  echo "Warning: .env file not found - AWS Secrets Manager may not work"
fi

export TAG_NAME

echo "VER=$TAG_NAME"

echo "Force pulling..."
rancher-compose -p ${COMPOSE_PROJECT_NAME} -f ${COMPOSE_FILE} --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} pull

echo "Starting deployment..."
# Retry logic for Rancher state conflicts
MAX_RETRIES=5
RETRY_DELAY=10
for i in $(seq 1 $MAX_RETRIES); do
  echo "Deployment attempt $i of $MAX_RETRIES..."
  rancher-compose -p ${COMPOSE_PROJECT_NAME} -f ${COMPOSE_FILE} --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} up --upgrade -d --pull --batch-size 1
  if [ $? -eq 0 ]; then
    break
  else
    if [ $i -lt $MAX_RETRIES ]; then
      echo "Deployment failed, waiting ${RETRY_DELAY}s before retry..."
      sleep $RETRY_DELAY
    fi
  fi
done

if [ $? -eq 0 ]; then
  echo "Deploy success! Confirming..."
  rancher-compose -p ${COMPOSE_PROJECT_NAME} -f ${COMPOSE_FILE} --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} up --confirm-upgrade -d --batch-size 1
else
  echo "Deploy failed :( rolling back..."
  rancher-compose -p ${COMPOSE_PROJECT_NAME} -f ${COMPOSE_FILE} --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} up --rollback -d --batch-size 1
fi