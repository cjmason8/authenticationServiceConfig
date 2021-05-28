#!/bin/bash

echo "Building version."
TAG_NAME=$(<VERSION)
TAG_NAME="${TAG_NAME%.*}.$((${TAG_NAME##*.}+1))"
echo $TAG_NAME > VERSION

echo "commiting bump version"
git config user.name "Release Manager"
git config user.email "Release.Manager@jenkins.com.au"
git add --all
git commit -m "bump version"
git push git@github.com:cjmason8/authenticationServiceConfig.git