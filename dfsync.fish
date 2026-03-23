function dfsync --description "sync dotfiles"
  git pull -C $(dirname $(realpath $0))
  git push -C $(dirname $(realpath $0))
end

