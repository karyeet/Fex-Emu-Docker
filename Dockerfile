# ------------------------------------------------------------ Builder ------------------------------------------------------------
FROM ubuntu:22.04 AS builder

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install fex
RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    wget && \
    add-apt-repository -y ppa:fex-emu/fex && \
    apt install -y fex-emu-armv8.2

# Get Rootfs 
# https://rootfs.fex-emu.gg/RootFS_links.json
RUN wget https://rootfs.fex-emu.gg/Ubuntu_22_04/2024-05-27/Ubuntu_22_04.sqsh
RUN unsquashfs -d /Ubuntu_22_04 Ubuntu_22_04.sqsh

# ------------------------------------------------------------ Fex Runner ------------------------------------------------------------
FROM ubuntu:22.04 AS fex-arm

# add ubuntu user and create directories
RUN useradd -m ubuntu && \
    mkdir -p /home/ubuntu/.fex-emu/RootFS && \
    chown ubuntu -R /home/ubuntu

# Copy Rootfs
COPY --chown=ubuntu:ubuntu --from=builder /Ubuntu_22_04 /home/ubuntu/.fex-emu/RootFS/Ubuntu_22_04

# Copy fex binaries
COPY --from=builder /usr/bin/FEX* /usr/bin/

USER ubuntu

# Set config
RUN echo '{"Config":{"RootFS":"Ubuntu_22_04"}}' > /home/ubuntu/.fex-emu/Config.json

WORKDIR /home/ubuntu/

ENTRYPOINT ["FEXBash"]