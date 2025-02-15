#!/bin/bash

sketchybar --add item calendar right \
	   --set calendar icon=  \
	   		  label="$(date +'%b %d %H:%M')" \
			  update_freq=30
			  script="$PLUGIN_DIR/clock.sh" \
