#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_REPO="https://github.com/YaLTeR/niri.git"

LATEST_TAG=$(
  git ls-remote --tags --sort="v:refname" "$UPSTREAM_REPO" |
  awk -F/ '{print $3}' |
  grep '^v' |
  grep -v '\^{}$' |
  tail -n1
)

VERSION="${LATEST_TAG#v}"

echo "$VERSION"
