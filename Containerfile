# uCore HCI (lts) with the out-of-tree bcachefs module and bcachefs-tools.
ARG BASE_IMAGE=ghcr.io/ublue-os/ucore-hci:lts

# Build kmod-bcachefs for the base image's kernel from akmod-bcachefs. Only
# this stage has gcc and kernel headers.
FROM ${BASE_IMAGE} AS kmod
COPY build/ /tmp/build/
RUN bash /tmp/build/kmod.sh /out

FROM ${BASE_IMAGE}
COPY build/ /tmp/build/
RUN --mount=type=bind,from=kmod,source=/out,target=/tmp/kmod \
    bash /tmp/build/install.sh /tmp/kmod && \
    rm -rf /tmp/build
RUN bootc container lint
