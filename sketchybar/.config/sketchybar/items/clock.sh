#!/bin/bash

sketchybar --add item clock right \
	   --set clock icon=  \
	               background.drawing=off \
	   		  label="$(date +'%b %d %H:%M')" \
			  update_freq=10 \
			  script="$PLUGIN_DIR/clock.sh"
