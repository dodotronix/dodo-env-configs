#!/usr/bin/sh

actual_path=$(pwd)

cd $HOME/.config/i3
head -n 10 common_config > config
cat platform_spec_config >> config
tail -n +10 common_config >> config 
cd $actual_path
