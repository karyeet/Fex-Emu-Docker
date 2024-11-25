# Fex-Emu-Docker
FEX-Emu based docker images & Dockerfiles, intended to be used on oracle ampere.

Images are available from [DockerHub](https://hub.docker.com/repository/docker/karyeet/fex-emu/)

## Images:
- Only FEX-Emu installed:
    - `karyeet/fex-emu:latest`
- FEX-Emu and steamcmd installed:
    - `karyeet/fex-emu:steamcmd`

## Example Usage
- Mount a directory to a `fex-emu:latest` container with your program & pass the path as a parameter. You can use `karyeet/fex-emu:steamcmd` to download games.
    - Command (project zomboid):
        - `sudo docker run -it --rm -v ./pz-server:/pz-server karyeet/fex-emu:latest /pz-server/start-server.sh`
#
-  Follow the Steamcmd Dockerfile to create a new image for your application.

## Sourcing and Security
FEX-Emu is ~~built from source~~ installed directly from the PPA, then the binaries are copied to a bare ubuntu image to reduce image size.

The Rootfs (Ubuntu 22.04) is also sourced from FEX-Emu.

The image is built and pushed using Github Actions. An Ubicloud runner is used for arm64 support.

