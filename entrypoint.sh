#!/bin/sh -l

REPO_PATH=./
SLACK_URL=$1
CONCURRENCY=$2

if [ -z "SLACK_URL" ]; then
  echo "SLACK_URL is required"
  exit 1
fi

driftive --repo-path="$REPO_PATH" --slack-url="$SLACK_URL" --concurrency="$CONCURRENCY"