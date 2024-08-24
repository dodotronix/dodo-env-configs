#!/usr/bin/env sh
# NOTES if you want to see, what properties you set run following command
#xfconf-query -c xfce4-panel -m -v

xfconf-query -c xfce4-session -np /general/SessionName -t string -s Default 
xfconf-query -c xfce4-session -np /sessions/Failsafe/Client0_Command -a -t string -s i3
xfconf-query -c xfce4-session -np /sessions/Failsafe/Client4_Command -a -t string -s "" 

# remove all plugins from the panel
xfconf-query -c xfce4-panel -p /plugins -r -R

xfconf-query -c xfce4-panel -np "/panels/dark-mode" -t bool -s true 
xfconf-query -c xfce4-panel -np "/panels/panel-0/plugin-ids" -a \
    -t int -s 1 \
    -t int -s 2 \
    -t int -s 3 \
    -t int -s 4 \
    -t int -s 5 \
    -t int -s 6 \
    -t int -s 8 \
    -t int -s 9 \
    -t int -s 10 \
    -t int -s 11 

# FULL HD PANEL
xfconf-query -c xfce4-panel -np "/panels/panel-0/size" -t uint -s 45

# 4K PANEL
xfconf-query -c xfce4-panel -p "/panels/panel-0/size" -t uint -s 65

xfconf-query -c xfce4-panel -np "/panels/panel-0/icon-size" -t uint -s 0 
xfconf-query -c xfce4-panel -np "/panels/panel-0/position-locked" -t bool -s true 
xfconf-query -c xfce4-panel -p /panels -a -t int -s 0

## CREATE PLUGINS
xfconf-query -c xfce4-panel -np /plugins/plugin-1 \
    -t string -s 'clock'
xfconf-query -c xfce4-panel -np /plugins/plugin-1/digital-time-format \
    -t string -s '%R'
xfconf-query -c xfce4-panel -np /plugins/plugin-1/digital-time-font \
    -t string -s 'Sans 16'
xfconf-query -c xfce4-panel -np /plugins/plugin-1/digital-layout \
    -t uint -s 3 

# SEPARATOR
xfconf-query -c xfce4-panel -np /plugins/plugin-2 \
    -t string -s 'separator'
xfconf-query -c xfce4-panel -np /plugins/plugin-2/style \
    -t uint -s 0 

xfconf-query -c xfce4-panel -np /plugins/plugin-3 \
    -t string -s 'whiskermenu'

# SEPARATOR
xfconf-query -c xfce4-panel -np /plugins/plugin-4 \
    -t string -s 'separator'
xfconf-query -c xfce4-panel -np /plugins/plugin-4/style \
    -t uint -s 0 

# SEPARATOR
xfconf-query -c xfce4-panel -np /plugins/plugin-6 \
    -t string -s 'separator'
xfconf-query -c xfce4-panel -np /plugins/plugin-6/expand \
    -t bool -s 'true' 
xfconf-query -c xfce4-panel -np /plugins/plugin-6/style \
    -t uint -s 0 

# SEPARATOR
xfconf-query -c xfce4-panel -np /plugins/plugin-8 \
    -t string -s 'separator'
xfconf-query -c xfce4-panel -np /plugins/plugin-8/expand \
    -t bool -s 'true' 
xfconf-query -c xfce4-panel -np /plugins/plugin-8/style \
    -t uint -s 0 

xfconf-query -c xfce4-panel -np /plugins/plugin-9 \
    -t string -s 'power-manager-plugin'

xfconf-query -c xfce4-panel -np /plugins/plugin-10 \
    -t string -s 'separator'
xfconf-query -c xfce4-panel -np /plugins/plugin-10/style \
    -t uint -s 0 

xfconf-query -c xfce4-panel -np /plugins/plugin-11 \
    -t string -s 'systray'
xfconf-query -c xfce4-panel -np /plugins/plugin-11/icon-size \
    -t int -s 0

# TODO check if xfce is running, otherwise omit this command
xfce4-panel --restart 

# I3-WORKSPACES
# this is pretty annoying because the i3-workspace widget does
# update when we rewrite the i3-workspaces-X.rc file
sleep 1

xfconf-query -c xfce4-panel -np "/panels/panel-0/plugin-ids" -a \
    -t int -s 1 \
    -t int -s 2 \
    -t int -s 3 \
    -t int -s 4 \
    -t int -s 6 \
    -t int -s 7 \
    -t int -s 8 \
    -t int -s 9 \
    -t int -s 10 \
    -t int -s 11 

# i3-workspaces are configured using css file
# so it has to be generated here
I3_WS_CSS="use_css=false
normal_color=rgb(222,221,218)
focused_color=rgb(255,163,72)
urgent_color=rgb(255,0,0)
mode_color=rgb(51,209,122)
visible_color=rgb(192,97,203)
css=.workspace { }
strip_workspace_numbers=true
auto_detect_outputs=false
output= "

PANEL_DIR=$HOME/.config/xfce4/panel
if [ ! -d $PANEL_DIR ]; then
    mkdir -p $PANEL_DIR
fi

rm -rf $PANEL_DIR/i3-workspaces*
echo "$I3_WS_CSS" > $PANEL_DIR/i3-workspaces-7.rc

xfconf-query -c xfce4-panel -np /plugins/plugin-7 \
    -t string -s 'i3-workspaces'

# settings for whiskermenu 

# FULL HD WHISKER MENU WIDTH
xfconf-query -c xfce4-panel -np /plugins/plugin-3/menu-width \
    -t int -s 1780

xfconf-query -c xfce4-panel -np /plugins/plugin-3/menu-height \
    -t int -s 500

# 4K WHISKER MENU WIDTH 
xfconf-query -c xfce4-panel -p /plugins/plugin-3/menu-width \
    -t int -s 3600

xfconf-query -c xfce4-panel -p /plugins/plugin-3/menu-height \
    -t int -s 1000

# GENERAL WHISKER MENU SETTINGS

xfconf-query -c xfce4-panel -np /plugins/plugin-3/launcher-show-description \
    -t bool -s 'false' 

xfconf-query -c xfce4-panel -np /plugins/plugin-3/launcher-icon-size \
    -t int -s 4

xfconf-query -c xfce4-panel -np /plugins/plugin-3/category-icon-size \
    -t int -s 4

xfconf-query -c xfce4-panel -np /plugins/plugin-3/position-categories-horizontal \
    -t bool -s 'true' 

xfconf-query -c xfce4-panel -np /plugins/plugin-3/position-profile-alternate \
    -t bool -s 'true' 

xfconf-query -c xfce4-panel -np /plugins/plugin-3/button-single-row \
    -t bool -s 'true' 

xfconf-query -c xfce4-panel -np /plugins/plugin-3/position-search-alternate \
    -t bool -s 'true' 

xfconf-query -c xfce4-panel -np /plugins/plugin-3/stay-on-focus-out \
    -t bool -s 'true' 

xfconf-query -c xfce4-panel -np /plugins/plugin-3/default-category \
    -t int -s 1

# TODO check if xfce is running, otherwise omit this command
xfce4-panel --restart 
