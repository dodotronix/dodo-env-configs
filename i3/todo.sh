#!/usr/bin/bash

# find workspace "todo" in actual tree and check if there is already any window
# only possible window is todo list in vim editor
OUTPUT=$(i3-msg -t get_tree | jq '.nodes | .[] | .nodes | .[] 
                              | .nodes | .[] | .nodes | .[] | 
                                select(.name == "todo-list") | .name')

if [ -z "$OUTPUT" ]; then
  alacritty --title "todo-list" -e nvim $HOME/projects/vimwiki_record/index.wiki &
fi
