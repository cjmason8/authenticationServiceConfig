#!/bin/bash

export TAG_NAME=$(<LOCAL)
export COMPUTER_NAME=$(cat /proc/sys/kernel/hostname)

docker-compose -f lcl/docker-compose-lcl.yml up
