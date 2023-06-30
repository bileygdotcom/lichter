ARG BASE_IMAGE="ubuntu"
ARG TAG="20.04"
#ARG WINE_BRANCH="staging"

FROM ${BASE_IMAGE}:${TAG}

LABEL project="Lichter"\
      version="0.1.0" \
      mantainer="bileyg"\
      company="Ascon"

# Install prerequisites
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       apt-transport-https \
       ca-certificates \
       cabextract \
       #dbus-x11 \
       gnupg \
       gpg-agent \
       locales \
       wget \
       #winbind \
       #x11-xserver-utils \
       #xvfb \
       zenity \
    && rm -rf /var/lib/apt/lists/*
    
# add wine repository & winetricks     
COPY keys /usr/share/keyrings/
COPY source /etc/apt/sources.list.d/
COPY winetricks /usr/bin/

# Add i386 architecture && winetricks execution
RUN dpkg --add-architecture i386 \
    && APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 \
    && DEBIAN_FRONTEND="noninteractive" \
    && chmod +x /usr/bin/winetricks
    
# Install wine
RUN apt-get update \
    && apt-get install -y --install-recommends winehq-staging \
    && rm -rf /var/lib/apt/lists/*

# Add dotnet
RUN winetricks --force -q dotnet472

# Add Special Ingredients with Winetricks
#RUN winetricks -q d3dcompiler_47 && winetricks -q corefonts

# Configure locale for unicode
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
