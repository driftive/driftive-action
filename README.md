# driftive-action

This action is used to run driftive in a GitHub Actions workflow.

## Inputs

#### `distribution` (required)

The Terraform distribution to use. Options are `tf` (Terraform) or `tofu` (OpenTofu).

#### `distribution-version` (optional)

The version of the Terraform distribution to use. Default is `latest`.

#### `terragrunt-version` (optional)

The version of Terragrunt to use. Default is `latest`.

#### `concurrency` (optional)

The number of projects driftive will run concurrently. Default is `1`.

#### `slack-url` (optional)

The Slack webhook URL to use for sending state drift notifications.

#### `github-token` (optional)

The GitHub token to use for creating issues. Required if `enable-github-issues` is set to `true`.

#### `enable-stdout-output` (optional)

Enable outputting driftive state drifts to stdout. Default is `true`.

#### `log-level` (optional)

The log level to use. Options are `debug`, `info`, `warn`, `error`, `fatal`, and `panic`. Default is `info`.

#### `exit-code` (optional)

Set to true to exit with a non-zero exit code if driftive finds any state drift. Default is `false`.

## Example

Full workflow example:

```yaml
name: Driftive
on:
  workflow_dispatch:

permissions:
  contents: read
  issues: write
  pull-requests: read # required if `settings.skip_if_open_pr` in driftive.yml is set to true

jobs:
  driftive:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4

    - name: Driftive
      uses: driftive/driftive-action@v0.x.y
      env:
        GITHUB_CONTEXT: ${{ toJson(github) }} # Required if `enable-github-issues` is true
        DRIFTIVE_TOKEN: ${{ secrets.DRIFTIVE_TOKEN }} # optional
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }} # Required if `enable-github-issues` is true
        slack-url: ${{ secrets.SLACK_WEBHOOK_URL }}
        distribution: tf
        distribution-version: 1.5.7
        terragrunt-version: 0.60.0
        concurrency: 4
```
