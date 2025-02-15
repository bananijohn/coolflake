#!/bin/bash

STATE="$(echo "$INFO" | jq -r '.state')"
if [ "$STATE" = "playing" ]; then
	MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
	sketchybar --set $NAME label="$MEDIA" drawing=on
elif [ "$STATE" != "playing" ]; then 
	sketchybar --set $NAME drawing=off
fi
