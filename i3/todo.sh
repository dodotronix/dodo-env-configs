#!/usr/bin/bash

# find workspace "todo" in actual tree and check if there is already any window
# only possible window is todo list in vim editor
OUTPUT=$(i3-msg -t get_tree | jq '.nodes | .[] | .nodes | .[] 
                              | .nodes | .[] | .nodes | .[] | 
                                select(.name == "todo-list") | .name')

if [ -z "$OUTPUT" ]; then
    if [ -d $HOME/projects/neorg_record ]; then
        alacritty --title "todo-list" -e nvim -c "Neorg workspace personal" &
    fi
fi
