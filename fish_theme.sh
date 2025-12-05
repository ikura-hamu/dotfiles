#!/bin/bash

REPO_NAME="oh-my-fish/theme-bobthefish"

curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$REPO_NAME/tarball/HEAD \
  | tar xz --strip-components=1 --wildcards '*/functions/*' -C ~/.config/fish/
