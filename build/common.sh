#!/usr/bin/env bash
# Sourced by the build scripts. Sets kver to the image's only kernel and adds
# the COPR repositories: the bcachefs akmod, and the kwizart kernel-longterm
# series that matches the kernel (for kernel-longterm-devel).
set -euo pipefail

mapfile -t kernels < <(ls /usr/lib/modules)
if [[ ${#kernels[@]} -ne 1 ]]; then
  echo "Expected one kernel in /usr/lib/modules, found: ${kernels[*]}" >&2
  exit 1
fi
kver=${kernels[0]}
series=$(cut -d. -f1,2 <<< "$kver")
echo "Kernel ${kver} (kernel-longterm-${series})"

dnf=$(command -v dnf5 || command -v dnf)

add_copr() {
  local owner=$1 project=$2
  cat > "/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:${owner}:${project}.repo" <<EOF
[copr:copr.fedorainfracloud.org:${owner}:${project}]
name=Copr repo for ${project} owned by ${owner}
baseurl=https://download.copr.fedorainfracloud.org/results/${owner}/${project}/fedora-\$releasever-\$basearch/
type=rpm-md
gpgcheck=1
gpgkey=https://download.copr.fedorainfracloud.org/results/${owner}/${project}/pubkey.gpg
repo_gpgcheck=0
enabled=1
EOF
}

remove_coprs() {
  rm -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:sebvett:akmod-bcachefs-test.repo \
    "/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:kwizart:kernel-longterm-${series}.repo"
}

add_copr sebvett akmod-bcachefs-test
add_copr kwizart "kernel-longterm-${series}"
