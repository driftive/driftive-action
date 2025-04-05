#!/bin/sh -l
set -e

if [ "$TERRAFORM_DISTRIBUTION" != "tf" ] && [ "$TERRAFORM_DISTRIBUTION" != "tofu" ]; then
    echo "Invalid value for TERRAFORM_DISTRIBUTION"
    exit 1
fi

# Install TF distribution
tenv $TERRAFORM_DISTRIBUTION install $TERRAFORM_DISTRIBUTION_VERSION

# Check if the installation was successful
if [ "$TERRAFORM_DISTRIBUTION" = "tf" ]; then
  # Check if terraform is installed
  if ! command -v terraform &> /dev/null; then
    echo "Terraform could not be found"
    exit 1
  fi
elif [ "$TERRAFORM_DISTRIBUTION" = "tofu" ]; then
  # Check if tofu is installed
  if ! command -v tofu &> /dev/null; then
    echo "Tofu could not be found"
    exit 1
  fi
fi

# terragrunt is optional. If present, install it using tenv
if [ -n "$TERRAGRUNT_VERSION" ]; then
  tenv tg install $TERRAGRUNT_VERSION
  # Check if terragrunt is installed
  if ! command -v terragrunt &> /dev/null; then
    echo "Terragrunt could not be found"
    exit 1
  fi
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

if [ -n "$EXIT_CODE" ]; then
  driftive_args="$driftive_args --exit-code=${EXIT_CODE:-false}"
fi

driftive $driftive_args
