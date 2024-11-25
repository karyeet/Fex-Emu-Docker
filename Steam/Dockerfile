# ------------------------------------------------------------ Steam Runner ------------------------------------------------------------
FROM karyeet/fex-emu:latest

USER root

# Install wget & ca-certificates
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    apt-get clean

USER ubuntu
WORKDIR /home/ubuntu/Steam
# Get Steamcmd
RUN wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" && \
    tar zxvf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

ENTRYPOINT FEXBash ./steamcmd.sh