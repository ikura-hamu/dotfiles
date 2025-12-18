#!/bin/bash

set -eu -o pipefail # 失敗したら異常終了

SOURCE_DIR="$(dirname $(realpath $0))/config"
TARGET_DIR="$HOME/.config"

find "$SOURCE_DIR" -type f | while read file; do
  relative_path="${file#$SOURCE_DIR/}"
  target_path="$TARGET_DIR/$relative_path"
  target_dir="$(dirname "$target_path")"
  
  mkdir -p "$target_dir"
  
  # 既存のシンボリックリンクまたはファイルを削除してから新しいシンボリックリンクを作成
  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    rm -f "$target_path"
  fi
  ln -s "$file" "$target_path"
  
  echo "Linked: $target_path -> $file"
done
