#!/bin/bash

sketchybar --add item front_app left \
	   --set front_app	background.color=$LAVENDER \
	   			icon.color=$BAR_COLOR \
				icon.font="sketchybar-app-font:Regular:17.0" \
				label.color=$BAR_COLOR \
				script="$PLUGIN_DIR/front_app.sh" \
	   --subscribe front_app front_app_switched
