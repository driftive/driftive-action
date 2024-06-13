#!/bin/sh -l

REPO_PATH=./
SLACK_URL=$1
CONCURRENCY=$2
TERRAFORM_DISTRIBUTION=$3
TERRAFORM_DISTRIBUTION_VERSION=$4

if [ "$TERRAFORM_DISTRIBUTION" != "tf" ] && [ "$TERRAFORM_DISTRIBUTION" != "tofu" ]; then
    echo "Invalid value for TERRAFORM_DISTRIBUTION"
    exit 1
fi

if [ -z "SLACK_URL" ]; then
  echo "SLACK_URL is required"
  exit 1
fi

tenv install $TERRAFORM_DISTRIBUTION $TERRAFORM_DISTRIBUTION_VERSION

driftive --repo-path="$REPO_PATH" --slack-url="$SLACK_URL" --concurrency="$CONCURRENCY"