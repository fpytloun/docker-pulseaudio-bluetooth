#!/bin/bash -e

export NAME=${NAME:-$HOSTNAME}
export DEVICE=${DEVICE:-$(hciconfig dev|grep 'BD Address:'|awk '{print $3}')}
export DEVICE_PIN=${DEVICE_PIN:-0000}

rm -f /run/dbus/pid
rm -rf /tmp/pulse-*

sed -re 's/#?Name =.*$/Name = '"$NAME"'/' -i /etc/bluetooth/main.conf

dbus-daemon --system --fork
eval "$(dbus-launch)"
export DBUS_SESSION_BUS_ADDRESS
export DBUS_SESSION_BUS_PID
pulseaudio --log-level=1 &
bluetoothd --plugin=a2dp -n &
#avahi-daemon -D
. /usr/local/bin/simple-bluetooth-agent.sh
