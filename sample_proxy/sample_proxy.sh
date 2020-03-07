#!/usr/bin/env bash
client() {
  echo https://$TOOL_HOST/proxy/8086
}
server() {
  python -m http.server 8086
}
