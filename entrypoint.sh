#!/bin/sh -l

REPO_PATH=./
SLACK_URL=$1
CONCURRENCY=$2

driftive --repo-path=$REPO_PATH --slack-url=$SLACK_URL --concurrency=$CONCURRENCY