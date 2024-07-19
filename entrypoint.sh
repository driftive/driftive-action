#!/bin/sh -l

if [ "$TERRAFORM_DISTRIBUTION" != "tf" ] && [ "$TERRAFORM_DISTRIBUTION" != "tofu" ]; then
    echo "Invalid value for TERRAFORM_DISTRIBUTION"
    exit 1
fi

tenv $TERRAFORM_DISTRIBUTION install $TERRAFORM_DISTRIBUTION_VERSION

# terragrunt is optional. If present, install it using tenv
if [ -n "$TERRAGRUNT_VERSION" ]; then
  tenv tg install $TERRAGRUNT_VERSION
fi

driftive_args=" --repo-path=./"
if [ -n "$SLACK_URL" ]; then
  driftive_args="$driftive_args --slack-url=$SLACK_URL"
fi

if [ -n "$CONCURRENCY" ]; then
  # use concurrency or default to 1
  driftive_args="$driftive_args --concurrency=${CONCURRENCY:-1}"
fi

if [ -n "$GITHUB_TOKEN" ]; then
  driftive_args="$driftive_args --github-token=$GITHUB_TOKEN"
fi

if [ -n "$LOG_LEVEL" ]; then
  driftive_args="$driftive_args --log-level=${LOG_LEVEL:-info}"
fi

if [ -n "$STDOUT_OUTPUT" ]; then
  driftive_args="$driftive_args --stdout=${STDOUT_OUTPUT:-true}"
fi

if [ -n "$GITHUB_ISSUES" ]; then
  driftive_args="$driftive_args --github-issues=$GITHUB_ISSUES"
fi

if [ -n "$CLOSE_ISSUES" ]; then
  driftive_args="$driftive_args --close-resolved-issues=${CLOSE_ISSUES:-false}"
fi

if [ -n "$MAX_ISSUES" ]; then
  driftive_args="$driftive_args --max-opened-issues=${MAX_ISSUES:-10}"
fi

driftive $driftive_args
