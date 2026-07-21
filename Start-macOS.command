#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1

# Make curl inherit an enabled macOS system HTTP(S) proxy when this launcher is
# opened from Finder, where shell proxy variables normally are not present.
if command -v scutil >/dev/null 2>&1; then
  proxy_settings="$(scutil --proxy)"
  proxy_host="$(printf '%s\n' "$proxy_settings" | awk '/HTTPSProxy/ { print $3; exit }')"
  proxy_port="$(printf '%s\n' "$proxy_settings" | awk '/HTTPSPort/ { print $3; exit }')"
  proxy_enabled="$(printf '%s\n' "$proxy_settings" | awk '/HTTPSEnable/ { print $3; exit }')"
  if [[ "$proxy_enabled" == "1" && -n "$proxy_host" && -n "$proxy_port" ]]; then
    export http_proxy="http://$proxy_host:$proxy_port"
    export https_proxy="http://$proxy_host:$proxy_port"
  fi
fi

exec bash ./kickstarter.sh
