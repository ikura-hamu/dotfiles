#!/bin/bash

SOURCE_DIR="$(dirname $(realpath $0))/config"
TARGET_DIR="$HOME/.config"

find "$SOURCE_DIR" -type f | while read file; do
  relative_path="${file#$SOURCE_DIR/}"
  target_path="$TARGET_DIR/$relative_path"
  target_dir="$(dirname "$target_path")"
  
  mkdir --parents "$target_dir"
  ln --symbolic --force "$file" "$target_path"
  echo "Linked: $target_path -> $file"
done
