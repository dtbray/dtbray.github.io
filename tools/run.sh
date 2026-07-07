#!/usr/bin/env bash
#
# Run the Hugo development server.

set -euo pipefail

host="127.0.0.1"
port="1313"

help() {
  echo "Usage:"
  echo
  echo "   bash tools/run.sh [options]"
  echo
  echo "Options:"
  echo "     -H, --host [HOST]    Host to bind to. Default: 127.0.0.1"
  echo "     -p, --port [PORT]    Port to bind to. Default: 1313"
  echo "     -h, --help           Print this help information."
}

while (($#)); do
  opt="$1"
  case $opt in
  -H | --host)
    if [[ $# -lt 2 || "$2" == -* ]]; then
      echo "> Missing value for '$opt'"
      echo
      help
      exit 1
    fi
    host="$2"
    shift 2
    ;;
  -p | --port)
    if [[ $# -lt 2 || "$2" == -* ]]; then
      echo "> Missing value for '$opt'"
      echo
      help
      exit 1
    fi
    port="$2"
    shift 2
    ;;
  -h | --help)
    help
    exit 0
    ;;
  *)
    echo "> Unknown option: '$opt'"
    echo
    help
    exit 1
    ;;
  esac
done

if command -v hugo >/dev/null 2>&1; then
  exec hugo server --bind "$host" --port "$port" --baseURL "http://$host:$port/"
fi

exec docker run --rm \
  -p "$port:$port" \
  -v "$PWD:/src" \
  -w /src \
  ghcr.io/gohugoio/hugo:v0.164.0 \
  server --bind 0.0.0.0 --port "$port" --baseURL "http://localhost:$port/" --noBuildLock --noTimes
