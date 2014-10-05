#!/bin/bash

realpath () {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}
this=$(realpath $0)

sumdir () {
  wd=$(pwd)
  cd "$*"
  find . -mindepth 1 -maxdepth 1 -type f ! -name '._*' ! -name .sha256 -print0 \
  | xargs -0 shasum -a256 -b > .sha256
  find . -mindepth 1 -maxdepth 1 -type d -print0 \
  | xargs -0 -L1 $this sum
  find . -mindepth 2 -maxdepth 2 -type f -name .sha256 -print0 \
  | xargs -0 shasum -a256 -b >> .sha256
  cd "$wd"
}

ckdir () {
  wd=$(pwd)
  cd "$*"
  if [[ ! -f .sha256 ]]; then
    echo "$PWD: no .sha256 file found, directory ignored"
  else
    shasum -c .sha256 2>/dev/null \
    | grep -vP 'OK$' \
    | while read line; do
        echo "$PWD/${line#./}"
      done
  fi
  find . -mindepth 1 -maxdepth 1 -type d -print0 \
  | xargs -0 -L1 $this check
  cd "$wd"
}

case "$1" in
  sum)
    sumdir "$2"
    ;;
  check)
    ckdir "$2"
    ;;
  *)
    echo "Invalid argument: $1. Must be 'sum' or 'check'."
    ;;
esac
