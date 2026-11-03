#!/usr/bin/env bash
# Build stage: compile kmod-bcachefs for the image's kernel with akmods and
# copy the RPM to the output directory.
set -euo pipefail
out=$1
. "$(dirname "$0")/common.sh"

# gcc may need a newer libgcc than the base image ships; dnf upgrades it here,
# which is fine because this stage is thrown away. Scriptlets are off because
# the akmod's %post builds as root, which akmodsbuild refuses; akmods below
# builds as the akmods user instead.
"$dnf" -y install --setopt=install_weak_deps=False --setopt=tsflags=noscripts \
  akmod-bcachefs "kernel-longterm-devel-${kver%.*}"
systemd-sysusers
ldconfig

if ! akmods --force --kernels "$kver" --kmod bcachefs; then
  cat /var/cache/akmods/bcachefs/*.log >&2 || true
  exit 1
fi

mkdir -p "$out"
cp /var/cache/akmods/bcachefs/kmod-bcachefs-*.rpm "$out/"
ls -l "$out"
