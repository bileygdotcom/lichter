# packhaus
<img align="right" height="240" width="280" src="https://github.com/bileygdotcom/packhaus/blob/main/packhaus_logo.png_280x240.png" >

Have you heard that Docker is for server apps only? That's poppycock, you know!

Packhaus is designed to run Windows applications directly from the container. It's possible because Wine 7.0, Winetrics & X-Server is inside. Microsoft .NET Framework 4.6.2 & some other toys are pre-installed too. Packhaus was made specially for Pilotdev team projects but you can also use it for your own purposes. Packhouse is based on ideas & Dockerfile of marvellous Docker-Wine project by Scotty Hardy (https://github.com/scottyhardy/docker-wine).

## On Docker Hub
https://hub.docker.com/repository/docker/bileyg/packhaus

## How to:

```bash
docker run -it --name="packhaus" --hostname="$(hostname)" --env="DISPLAY" --volume="${XAUTHORITY:-${HOME}/.Xauthority}:/root/.Xauthority:ro" --volume="/tmp/.X11-unix:/tmp/.X11-unix:ro" bileyg/packhaus /bin/bash
```
and then (to test how it works):
```bash
wine notepad
```
