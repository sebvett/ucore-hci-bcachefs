# ucore-hci-bcachefs

[uCore HCI](https://github.com/ublue-os/ucore) `lts` with the out-of-tree
bcachefs module and `bcachefs-tools`, for hosts whose data is on bcachefs
(bcachefs left the mainline kernel in 6.18).

The module comes from
[akmod-bcachefs](https://github.com/sebvett/akmod-bcachefs), published in the
test COPR `sebvett/akmod-bcachefs-test` and signed by its COPR key. A build
stage installs the akmod, `gcc` and the `kernel-longterm-devel` matching the
base image's kernel, and runs `akmods` to produce `kmod-bcachefs-<kernel>`.
The final image installs only that RPM, `bcachefs-kmod-common` and
`bcachefs-tools`, checks the module's vermagic against the kernel, and runs
`bootc container lint`. Hosts never compile anything.

## Builds

GitHub Actions builds on every push and pull request and daily at 05:30 UTC,
after uCore publishes. Pushes and scheduled runs publish:

- `ghcr.io/sebvett/ucore-hci-bcachefs:lts`
- `ghcr.io/sebvett/ucore-hci-bcachefs:lts-<kernel>-<YYYYMMDD>`, to pin or roll back to a build

A failed build publishes nothing, so hosts stay on the last good image.

## Use

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/sebvett/ucore-hci-bcachefs:lts
systemctl reboot
```

The image is not signed; it is trusted through this GitHub account. The
packages in it are checked against their repositories' keys at build time.
