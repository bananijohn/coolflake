#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

source "$CONFIG_DIR/colors.sh" # Loads variables
if [ $SELECTED = true ]; then
  sketchybar --set "$NAME" background.drawing=on \
	  		   background.color=$LAVENDER \
			   label.color=$BAR_COLOR \
			   icon.color=$BAR_COLOR 
else
  sketchybar --set $NAME background.drawing=off \
			 label.color=$LAVENDER \
			 icon.color=$LAVENDER
fi
