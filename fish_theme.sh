#!/bin/bash

set -eu -o pipefail

REPO_NAME="oh-my-fish/theme-bobthefish"

curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$REPO_NAME/tarball/HEAD \
  | tar xz -C ~/.config/fish --strip-components=1 '*/functions/*' 
