#!/usr/bin/env bash
# Final stage: install the prebuilt kmod, its common package and
# bcachefs-tools, check the module matches the kernel, and clean up.
set -euo pipefail
kmod_dir=$1
. "$(dirname "$0")/common.sh"

"$dnf" -y install --setopt=install_weak_deps=False \
  "$kmod_dir"/kmod-bcachefs-*.rpm bcachefs-kmod-common bcachefs-tools

echo "---- modinfo ----"
modinfo -k "$kver" bcachefs
vermagic=$(modinfo -k "$kver" -F vermagic bcachefs)
if [[ $vermagic != "$kver"* ]]; then
  echo "bcachefs vermagic ${vermagic} does not match ${kver}" >&2
  exit 1
fi
command -v bcachefs

remove_coprs
"$dnf" clean all
rm -rf /var/cache/* /var/lib/dnf /var/log/*
