#!/bin/bash

errcho () {
  echo "$@" >&2
}

here="$(cd $(dirname $0) && pwd)"
binDir=$(basename "$here")

site=$(gum choose $(ls "$here/.." | grep -v "$binDir" | grep \.))

if [ -d "$here/../$site/themes" ]; then
  themes=$(ls "$here/../$site/themes")
  if [ -n "$themes" ]; then
    theme=$(gum choose "$themes")
  else
    errcho "No themes installed"
  fi
else
  errcho "No themes directory detected at '$here/../$site/themes'"
fi

cd "$here/../$site"
hugo --theme="$theme" server -D -F &
sleep 1
open http://localhost:1313
wait $!
