#!/bin/bash

# Log to file
# echo "Dashboard script started at $(date)" > /tmp/dashboard.log

# Wait for i3
sleep 2

# echo "Creating workspace 1 layout..." >> /tmp/dashboard.log

i3-msg workspace 1

# Top-left: cava
# echo "Launching cava..." >> /tmp/dashboard.log
alacritty --class "dashboard-cava" --title "cava" -e cava &
sleep 0.3

# Top-right: fastfetch
# echo "Launching fastfetch..." >> /tmp/dashboard.log
i3-msg split h
alacritty --class "dashboard-fastfetch" --title "fastfetch" -e sh -c 'fastfetch; exec bash' &
sleep 0.3

# Bottom-left: asciiquarium
# echo "Launching asciiquarium..." >> /tmp/dashboard.log
i3-msg focus left
i3-msg split v
alacritty --class "dashboard-aquarium" --title "asciiquarium" -e asciiquarium &
sleep 0.3

# Bottom-right: btop
# echo "Launching btop..." >> /tmp/dashboard.log
i3-msg focus up
i3-msg focus right
i3-msg split v
alacritty --class "dashboard-btop" --title "btop" -e btop &
sleep 0.3

# echo "Dashboard script finished at $(date)" >> /tmp/dashboard.log

# Switch to workspace 2
# i3-msg workspace 2
