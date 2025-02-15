#!/bin/bash

sketchybar --add item media right \
	   --set media label.color=$LAVENDER \
		       label.max_chars=15 \
		       icon.padding_left=0 \
		       scroll_texts=on \
		       icon= \
		       icon.color=$LAVENDER \
		       background.drawing=off \
		       script="$PLUGIN_DIR/media.sh" \
	   --subscribe media media_change
