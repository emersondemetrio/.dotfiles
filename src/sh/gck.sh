#!/bin/bash
BRANCH_NAME=$(~/scripts/src/js/dash-case.js --exceptions=['/'] $@)

printf "\n=> Checking out new branch: '$BRANCH_NAME'\n\n"

git checkout -b $BRANCH_NAME
