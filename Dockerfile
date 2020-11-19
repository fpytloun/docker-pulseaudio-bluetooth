FROM debian:buster

RUN apt-get update && \
    apt-get install -y bluez expect dbus-x11 pulseaudio-module-bluetooth avahi-daemon && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
ADD simple-bluetooth-agent.sh /usr/local/bin/simple-bluetooth-agent.sh
ADD entrypoint.sh /entrypoint.sh
RUN mkdir /var/run/dbus
RUN sed -re 's/^load-module (module-console-kit|module-udev-detect|module-detect)/#\0/' -i /etc/pulse/default.pa \
    && echo 'load-module module-switch-on-connect' >> /etc/pulse/default.pa \
    && echo 'load-module module-native-protocol-tcp auth-anonymous=1' >> /etc/pulse/default.pa \
    && echo 'load-module module-detect' >> /etc/pulse/default.pa
RUN sed -re 's/#DiscoverableTimeout =.*$/DiscoverableTimeout = 0/' -e 's/#Class =.*$/Class = 0x200414/' -i /etc/bluetooth/main.conf
ENV PULSEAUDIO_SYSTEM_START=1

ENTRYPOINT [ "/entrypoint.sh" ]
