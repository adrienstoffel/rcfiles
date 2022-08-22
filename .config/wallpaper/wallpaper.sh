#!/usr/bin/env bash

distrib=$(lsb_release -i| awk '{ print $3 }')

if [[ "${distrib}" == "Ubuntu" ]]; then
	feh --bg-fill ~/.config/wallpaper/ubuntu.jpg
elif [[ "${distrib}" == "Debian" ]]; then
	feh --bg-fill ~/.config/wallpaper/debian.jpg
else
	feh --bg-fill ~/.config/wallpaper/archlinux.jpg
fi
