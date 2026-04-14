#!/usr/bin/bash

export CROOT=/tmp/mycontainer
mkdir -p "$CROOT"

ALPINE_VER=3.19.1
curl -fsSL \
  "https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-${ALPINE_VER}-x86_64.tar.gz" \
  | tar -xz -C "$CROOT"

# Verify
ls "$CROOT"
# bin  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
