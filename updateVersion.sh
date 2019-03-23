#!/bin/bash

GIT_PASS=$1
PROJECT=$2

echo "Building version."
TAG_NAME=$(<VERSION)
TAG_NAME="${TAG_NAME%.*}.$((${TAG_NAME##*.}+1))"
echo $TAG_NAME > VERSION

echo "commiting bump version"
git config user.name "Release Manager"
git config user.email "Release.Manager@jenkins.com.au"
git add --all
git commit -m "bump version"
git push https://cjmason8:${GIT_PASS}@github.com/cjmason8/${PROJECT}Config.git