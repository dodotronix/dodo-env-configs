#!/usr/bin/env bash

DATE="$(date +%Y-%m-%d_%H%M%S)"
printf "\e[1;36m[INF]\e[0m Date: %s\n" "$DATE"

cd $HOME/projects/records

printf "\e[1;36m[INF]\e[0m Pulling latest changes\n"

git pull

# save my new notes
printf "\e[1;36m[INF]\e[0m Saving new notes\n"
git add -A
git commit -m "$DATE"
git push

# wait, to be able to read the output 
sleep 2
