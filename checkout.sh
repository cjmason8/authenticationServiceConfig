#!/bin/bash

GIT_PASS=$1
PROJECT=$2

git checkout master
git pull origin master

cd authenticationService
echo "git pull"
git pull https://cjmason8:${GIT_PASS}@github.com/cjmason8/${PROJECT}.git