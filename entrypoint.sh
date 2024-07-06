#!/bin/sh -l

if [ "$TERRAFORM_DISTRIBUTION" != "tf" ] && [ "$TERRAFORM_DISTRIBUTION" != "tofu" ]; then
    echo "Invalid value for TERRAFORM_DISTRIBUTION"
    exit 1
fi

tenv $TERRAFORM_DISTRIBUTION install $TERRAFORM_DISTRIBUTION_VERSION

# terragrunt is now optional. If present, install it using tenv
if [ -n "$TERRAGRUNT_VERSION" ]; then
  tenv tg install $TERRAGRUNT_VERSION
fi

driftive_args="--repo-path=./"
if [ -n "$SLACK_URL" ]; then
  driftive_args="--slack-url=$SLACK_URL"
fi

if [ -n "$CONCURRENCY" ]; then
  driftive_args="--concurrency=$CONCURRENCY"
fi

if [ -n "$GITHUB_TOKEN" ]; then
  driftive_args="--github-token=$GITHUB_TOKEN"
fi

if [ -n "$LOG_LEVEL" ]; then
  driftive_args="$driftive_args --log-level=$LOG_LEVEL"
fi

if [ -n "$STDOUT_OUTPUT" ]; then
  driftive_args="$driftive_args --stdout-output=$STDOUT_OUTPUT"
fi

if [ -n "$GITHUB_ISSUES" ]; then
  driftive_args="$driftive_args --github-issues=$GITHUB_ISSUES"
fi

driftive --repo-path="$REPO_PATH" $driftive_args
