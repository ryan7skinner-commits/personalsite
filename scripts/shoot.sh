#!/usr/bin/env bash
# Builds the site and screenshots pages for design review.
# Usage: scripts/shoot.sh [out-dir] [path ...]   (default paths: / /work/ /writing/ /about/)
# Writes <out-dir>/<page>-{desktop,mobile}-{light,dark}.png. Needs the Playwright CLI.
set -euo pipefail
out=${1:-.design-review}; [ $# -gt 0 ] && shift
paths=("$@"); [ ${#paths[@]} -eq 0 ] && paths=(/ /work/ /writing/ /about/)
command -v playwright >/dev/null || { echo "playwright CLI not found (npm i -g playwright)"; exit 1; }

npm run build --silent >/dev/null
mkdir -p "$out"
port=4329
python3 -m http.server "$port" -d dist >/dev/null 2>&1 &
server=$!
trap 'kill $server' EXIT
sleep 1

for p in "${paths[@]}"; do
  name=$(echo "$p" | tr -c 'a-z0-9' '-' | sed 's/^-*//; s/-*$//'); name=${name:-home}
  for scheme in light dark; do
    playwright screenshot -b chromium --full-page --viewport-size=1440,900 --color-scheme=$scheme \
      --wait-for-timeout=1500 "http://localhost:$port$p" "$out/$name-desktop-$scheme.png" >/dev/null
    playwright screenshot -b chromium --full-page --viewport-size=390,844 --color-scheme=$scheme \
      --wait-for-timeout=1500 "http://localhost:$port$p" "$out/$name-mobile-$scheme.png" >/dev/null
  done
done
ls "$out"
