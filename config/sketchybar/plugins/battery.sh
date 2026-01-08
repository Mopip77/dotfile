#!/bin/sh

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

# Exit early if no battery data
[ -z "$PERCENTAGE" ] && exit 0

# Select icon based on charging state and battery level
if [ -n "$CHARGING" ]; then
  # Charging icons - different levels
  case ${PERCENTAGE} in
    9[0-9]|100) ICON="󰂅" ;;  # nf-md-battery_charging_100
    8[0-9])     ICON="󰂋" ;;  # nf-md-battery_charging_90
    7[0-9])     ICON="󰂊" ;;  # nf-md-battery_charging_80
    6[0-9])     ICON="󰂉" ;;  # nf-md-battery_charging_70
    5[0-9])     ICON="󰢞" ;;  # nf-md-battery_charging_60
    4[0-9])     ICON="󰂈" ;;  # nf-md-battery_charging_50
    3[0-9])     ICON="󰂇" ;;  # nf-md-battery_charging_40
    2[0-9])     ICON="󰂆" ;;  # nf-md-battery_charging_30
    1[0-9])     ICON="󰢜" ;;  # nf-md-battery_charging_20
    *)          ICON="󰢟" ;;  # nf-md-battery_charging_10
  esac
else
  # Discharging icons - different levels
  case ${PERCENTAGE} in
    9[0-9]|100) ICON="󰁹" ;;  # nf-md-battery_90
    8[0-9])     ICON="󰂂" ;;  # nf-md-battery_80
    7[0-9])     ICON="󰂁" ;;  # nf-md-battery_70
    6[0-9])     ICON="󰂀" ;;  # nf-md-battery_60
    5[0-9])     ICON="󰁿" ;;  # nf-md-battery_50
    4[0-9])     ICON="󰁾" ;;  # nf-md-battery_40
    3[0-9])     ICON="󰁽" ;;  # nf-md-battery_30
    2[0-9])     ICON="󰁼" ;;  # nf-md-battery_20
    1[0-9])     ICON="󰁻" ;;  # nf-md-battery_10
    *)          ICON="󰂎" ;;  # nf-md-battery_alert (critical)
  esac
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
