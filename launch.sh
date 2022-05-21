#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# Host-dependent settings
HOSTNAME=$(cat /proc/sys/kernel/hostname)
if [ "$HOSTNAME" == 'home' ]; then
  export ETH_INTERFACE=enp8s0
  export TEMPERATURE_HWMON_PATH=/sys/class/hwmon/hwmon1/temp1_input
elif [ "$HOSTNAME" == 'orion' ]; then
  export ETH_INTERFACE=enp86s0
  export WIFI_INTERFACE=wlp0s20f3
  export TEMPERATURE_HWMON_PATH=/sys/class/hwmon/hwmon4/temp1_input
elif [ "$HOSTNAME" == 'dynamo' ]; then
  export ETH_INTERFACE=enp67s0
  export TEMPERATURE_HWMON_PATH=/sys/class/hwmon/hwmon1/temp2_input
elif [ "$HOSTNAME" == 'forge' ]; then
  export ETH_INTERFACE=enp0s31f6
fi

# Launch bar1 and bar2
for m in $(xrandr --listmonitors | tail -n +2 | awk -e '{ print $4  }'); do
  MONITOR=$m polybar main&
done

echo "Polybar launched."
