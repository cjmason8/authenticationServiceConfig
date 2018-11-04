#!/bin/bash

TAG_NAME=$(<LOCAL)

./deploy.sh AA57D92145E412E26C0D N519UCmNmqq2AD7ti8EYxEVUv1PwyFpcJyGWeqUm http://localhost:8080/v2-beta/projects/1a5 lcl $TAG_NAME
