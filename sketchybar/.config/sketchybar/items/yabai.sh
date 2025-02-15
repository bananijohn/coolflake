#!/bin/bash

sketchybar -m --add item yabai left
sketchybar -m --set yabai update_freq=3
sketchybar -m --set yabai script="~/.config/sketchybar/plugins/yabai.sh"
sketchybar -m --subscribe yabai space_change
sketchybar -m --set yabai click_script="~/.config/sketchybar/plugins/yabai_click.sh"
