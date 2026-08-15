FROM ubuntu:26.04 AS source

ADD --checksum=sha256:43ce15e11404aaff313ec44ca03601e5e753bba3b355c38a7c67a4344d517aca https://github.com/Rosalie241/RMG/releases/download/v0.9.0/RMG-Portable-Linux64-v0.9.0.AppImage /tmp/app.AppImage

RUN chmod 0755 /tmp/app.AppImage && \
    cd /tmp && \
    ./app.AppImage --appimage-extract >/dev/null && \
    mkdir -p /stage && \
    cp -a /tmp/squashfs-root/. /stage/

FROM ghcr.io/containerpak/mesa64:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/rmg"

COPY --from=source /stage/ /opt/rmg/
COPY rmg /usr/bin/rmg
COPY rmg.desktop /usr/share/applications/rmg.desktop
COPY icon.png /usr/share/icons/hicolor/128x128/apps/rmg.png

RUN chmod 0755 /usr/bin/rmg && cpak-clean-junk

