#!/bin/sh

# load X settings
if [ -f ~/.Xresources ]; then
	xrdb -merge ~/.Xresources
fi

# Force GTK dark theme
export GTK_THEME=Arc-Dark

# Keyboard layouts: US and RU
setxkbmap -layout us,ru -option grp:alt_shift_toggle

# lunch PipeWire
pipewire &
sleep 1
wireplumber &

# XDG Desktop Portals for Flatpak
xdg-desktop-portal &
sleep 1
xdg-desktop-portal-gtk &

# Keyboard repeat rate (delay, rate)
xset r rate 200 50

# lunch i3 with Dbus sesstion
exec dbus-launch --exit-with-session i3
