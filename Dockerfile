FROM ubuntu:latest
LABEL project="Lichter"\
      version="0.5.0"\
      mark="ubuntu, wine, cybermax, dotnet472, vcrun2019, X"\
      mantainer="bileyg"\
      company="Ascon"
#Добавляем поддержку x86
RUN dpkg --add-architecture i386 \
    && apt-get update \
    #Ставим некоторые необходимые пакеты
    && apt-get install -qfy --install-recommends \
       software-properties-common \
       apt-transport-https \
       ca-certificates \
       cabextract \
       dbus-x11 \
       gnupg2 \
       gpg-agent \
       locales \
       tzdata \
       wget \
       x11-xserver-utils \
       xvfb \
       zenity
    #Добавляем репозиторий Wine
    && wget -nv https://dl.winehq.org/wine-builds/winehq.key \
    && apt-key add winehq.key \
    && apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' \
    #Дополнительный репозиторий для корректной установки Wine
    && add-apt-repository ppa:cybermax-dexter/sdl2-backport \
    #Ставим сам Wine
    && apt-get install -qfy --install-recommends \
        winehq-staging \
        winbind \
    #Подчищаем лишнее
    && apt-get -y clean \
    && rm -rf \
      /var/lib/apt/lists/* \
      /usr/share/doc \
      /usr/share/doc-base \
      /usr/share/man \
      /usr/share/locale \
      /usr/share/zoneinfo
#Переменные окружения для старта Wine
ENV WINEDEBUG=fixme-all
ENV WINEPREFIX=/root/.net
ENV WINEARCH=win64
#Пуск конфигурирования Wine
RUN winecfg \
    #Скачиваем winetricks
    && wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    -O /usr/local/bin/winetricks \
    && chmod +x /usr/local/bin/winetricks \
#Подчищаем лишнее
    && apt-get -y clean \
    && rm -rf \
      /var/lib/apt/lists/* \
      /usr/share/doc \
      /usr/share/doc-base \
      /usr/share/man \
      /usr/share/locale \
      /usr/share/zoneinfo \
    #Запуск Wine с необходимыми дополнениями
    && wineboot -u && winetricks -q dotnet472 && xvfb-run winetricks -q vcrun2019
