#!/bin/bash

sketchybar --add item volume right \
	   --set volume script="$PLUGIN_DIR/volume.sh" \
	         background.drawing=off \
	         background.border_widht=2 \
	         background.border_color=$LAVENDER \
	   --subscribe volume volume_change 
