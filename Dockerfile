ARG BASE_IMAGE="ubuntu"
ARG TAG="20.04"
#ARG WINE_BRANCH="staging"

FROM ${BASE_IMAGE}:${TAG}

LABEL project="Packhaus"\
      version="0.8 dotnet472" \
      mantainer="bileyg"\
      company="Ascon Complex"

# Install prerequisites
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       apt-transport-https \
       ca-certificates \
       cabextract \
       dbus-x11 \
       #git \
       gnupg \
       #gosu \
       gpg-agent \
       locales \
       #p7zip \
       #sudo \
       #tzdata \
       #unzip \
       wget \
       winbind \
       x11-xserver-utils \
       #xorgxrdp \
       #xrdp \
       xvfb \
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

# Install wine old
#
#RUN wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | #APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - \
#    && echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list \
#    && dpkg --add-architecture i386 \
#    && apt-get update \
#    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --install-recommends winehq-${WINE_BRANCH} \
#    && rm -rf /var/lib/apt/lists/*

# Install winetricks
#RUN wget -nv -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
#    && chmod +x /usr/bin/winetricks

# Download gecko and mono installers
#COPY download_gecko_and_mono.sh /root/download_gecko_and_mono.sh
#RUN chmod +x /root/download_gecko_and_mono.sh \
    #&& /root/download_gecko_and_mono.sh "$(wine --version | sed -E 's/^wine-//')"

# Add dotnet
RUN winetricks --force -q dotnet472

# Add Special Ingredients with Winetricks
RUN winetricks -q d3dcompiler_47 && winetricks -q corefonts

# Configure locale for unicode
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

COPY Fonts /root/.wine/drive_c/windows/Fonts

#COPY pulse-client.conf /root/pulse/client.conf
#COPY entrypoint.sh /usr/bin/entrypoint
#EXPOSE 3389/tcp
#ENTRYPOINT ["/usr/bin/entrypoint"]
