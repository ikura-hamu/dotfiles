#!/bin/bash

set -eu -o pipefail

REPO_NAME="oh-my-fish/theme-bobthefish"
TEMP_DIR=$(mktemp -d)

# tarballをダウンロードして一時ディレクトリに展開
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$REPO_NAME/tarball/HEAD \
  | tar xz -C "$TEMP_DIR"

# functions ディレクトリを探してコピー
find "$TEMP_DIR" -type d -name functions -exec cp -r {} ~/.config/fish/ \;

# 一時ディレクトリを削除
rm -rf "$TEMP_DIR"

echo "Fish theme installed successfully" 
