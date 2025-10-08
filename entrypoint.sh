#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [ "${TERRAFORM_DISTRIBUTION:-}" != "tf" ] && [ "${TERRAFORM_DISTRIBUTION:-}" != "tofu" ]; then
  echo "The specified distribution \"${TERRAFORM_DISTRIBUTION:-<unset>}\" is not supported. (use tf|tofu)" >&2
  exit 1
fi

if [ -n "${TERRAFORM_DISTRIBUTION_VERSION_FILE:-}" ] && [ -n "${TERRAFORM_DISTRIBUTION_VERSION:-}" ]; then
  echo '\"TERRAFORM_DISTRIBUTION_VERSION_FILE\" and \"TERRAFORM_DISTRIBUTION_VERSION\" cannot be specified at the same time.' >&2
  exit 1
elif [ -n "${TERRAFORM_DISTRIBUTION_VERSION_FILE:-}" ] && ! [ -f "${TERRAFORM_DISTRIBUTION_VERSION_FILE:-}" ]; then
  echo "The specified distribution version file at \"${TERRAFORM_DISTRIBUTION_VERSION_FILE}\" does not exist." >&2
  exit 1
elif [ -n "${TERRAFORM_DISTRIBUTION_VERSION_FILE:-}" ]; then
  case "${TERRAFORM_DISTRIBUTION:-}" in
    tf)
      export TERRAFORM_DISTRIBUTION_VERSION="$(
        awk '/^(tf|terraform)[[:space:]]/ { sub(/^(tf|terraform)[[:space:]]+v?/, ""); print; exit }' "${TERRAFORM_DISTRIBUTION_VERSION_FILE:-}"
      )"
      ;;
    tofu)
      export TERRAFORM_DISTRIBUTION_VERSION="$(
        awk '/^(tofu|opentofu)[[:space:]]/ { sub(/^(tofu|opentofu)[[:space:]]+v?/, ""); print; exit }' "${TERRAFORM_DISTRIBUTION_VERSION_FILE:-}"
      )"
      ;;
  esac

  if [ -z "${TERRAFORM_DISTRIBUTION_VERSION:-}" ]; then
    echo "No matching version found in \"${TERRAFORM_DISTRIBUTION_VERSION_FILE:-}\"." >&2
    exit 1
  fi
else
  # For backward compatibility, defaults to latest.
  export TERRAFORM_DISTRIBUTION_VERSION="${TERRAFORM_DISTRIBUTION_VERSION:-latest}"
fi

if [ -n "${TERRAGRUNT_VERSION_FILE:-}" ] && [ -n "${TERRAGRUNT_VERSION:-}" ]; then
  echo '\"TERRAGRUNT_VERSION_FILE\" and \"TERRAGRUNT_VERSION\" cannot be specified at the same time.' >&2
  exit 1
elif [ -n "${TERRAGRUNT_VERSION_FILE:-}" ] && ! [ -f "${TERRAGRUNT_VERSION_FILE:-}" ]; then
  echo "The specified terragrunt version file at \"${TERRAGRUNT_VERSION_FILE:-}\" does not exist." >&2
  exit 1
elif [ -n "${TERRAGRUNT_VERSION_FILE:-}" ]; then
  export TERRAGRUNT_VERSION="$(
    awk '/^(tg|terragrunt)[[:space:]]/ { sub(/^(tg|terragrunt)[[:space:]]+v?/, ""); print; exit }' "${TERRAGRUNT_VERSION_FILE:-}"
  )"
else
  # For backward compatibility, defaults to latest.
  export TERRAGRUNT_VERSION="${TERRAGRUNT_VERSION:-latest}"
fi

tenv "${TERRAFORM_DISTRIBUTION}" install "${TERRAFORM_DISTRIBUTION_VERSION}"
if [ "${TERRAFORM_DISTRIBUTION}" = "tf" ]; then
  if ! command -v terraform &>/dev/null; then
    echo "Terraform could not be found"
    exit 1
  fi
elif [ "$TERRAFORM_DISTRIBUTION" = "tofu" ]; then
  if ! command -v tofu &>/dev/null; then
    echo "Tofu could not be found"
    exit 1
  fi
fi

if [ -n "${TERRAGRUNT_VERSION}" ]; then
  tenv tg install "${TERRAGRUNT_VERSION}"
  if ! command -v terragrunt &>/dev/null; then
    echo "Terragrunt could not be found"
    exit 1
  fi

  # Terragrunt get_repo_root() workaround.
  # Without this, terragrunt will fail with "fatal: detected dubious ownership in repository at ..."
  git config --global --add safe.directory "*"
fi

driftive_args=("--repo-path=./")
[[ -n "${SLACK_URL:-}" ]] && driftive_args+=("--slack-url=${SLACK_URL}")
[[ -n "${CONCURRENCY:-}" ]] && driftive_args+=("--concurrency=${CONCURRENCY:-1}")
[[ -n "${GITHUB_TOKEN:-}" ]] && driftive_args+=("--github-token=${GITHUB_TOKEN}")
[[ -n "${LOG_LEVEL:-}" ]] && driftive_args+=("--log-level=${LOG_LEVEL:-info}")
[[ -n "${STDOUT_OUTPUT:-}" ]] && driftive_args+=("--stdout=${STDOUT_OUTPUT:-true}")
[[ -n "${EXIT_CODE:-}" ]] && driftive_args+=("--exit-code=${EXIT_CODE:-false}")

exec driftive "${driftive_args[@]}"
