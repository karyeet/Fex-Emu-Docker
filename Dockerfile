# ------------------------------------------------------------ Builder ------------------------------------------------------------
FROM ubuntu:22.04 AS builder

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    cmake \
    ninja-build \
    pkg-config \
    clang \
    llvm \
    lld \
    libsdl2-dev \
    libepoxy-dev \
    libssl-dev \
    python-setuptools \
    python3-clang \
    libstdc++-10-dev-i386-cross \
    libstdc++-10-dev-amd64-cross \
    libstdc++-10-dev-arm64-cross \
    squashfs-tools \
    squashfuse \
    qtdeclarative5-dev\
    wget

# Clone the FEX repository and build it
RUN git clone --recurse-submodules https://github.com/FEX-Emu/FEX.git

# Checkout supported version
RUN cd /FEX && \
    git checkout FEX-2311 && \
    git submodule update --recursive

# Build
RUN mkdir /FEX/Build && \
    cd /FEX/Build && \
    CC=clang CXX=clang++ cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DUSE_LINKER=lld -DENABLE_LTO=True -DBUILD_TESTS=False -DENABLE_ASSERTIONS=False -G Ninja .. && \
    ninja

# Install
WORKDIR /FEX/Build
RUN ninja install

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
COPY --from=builder /FEX/Build/Bin/* /usr/bin/

USER ubuntu

# Set config
RUN echo '{"Config":{"RootFS":"Ubuntu_22_04"}}' > /home/ubuntu/.fex-emu/Config.json

WORKDIR /home/ubuntu/

ENTRYPOINT FEXBash