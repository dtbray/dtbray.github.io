#!/usr/bin/env bash

set -euo pipefail

HUGO_VERSION="0.164.0"
ARCH="$(dpkg --print-architecture)"

case "$ARCH" in
amd64) HUGO_ARCH="linux-amd64" ;;
arm64) HUGO_ARCH="linux-arm64" ;;
*) echo "Unsupported architecture for Hugo install: $ARCH" >&2; exit 1 ;;
esac

curl -fsSL "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_${HUGO_ARCH}.tar.gz" \
  | sudo tar -xz -C /usr/local/bin hugo

if [ -f package.json ]; then
  bash -i -c "nvm install --lts && nvm install-latest-npm"
  npm i
  npm run build
fi

# Install dependencies for shfmt extension
curl -sS https://webi.sh/shfmt | sh &>/dev/null

# Add OMZ plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sed -i -E "s/^(plugins=\()(git)(\))/\1\2 zsh-syntax-highlighting zsh-autosuggestions\3/" ~/.zshrc

# Avoid git log use less
echo -e "\nunset LESS" >>~/.zshrc
