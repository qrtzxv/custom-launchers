#!/usr/bin/bash
## Niri window switcher in Fuzzel

fuzzel_cmd(){
	fuzzel --dmenu --index \
	--border-color=00c896ff \
	--anchor=center \
	--lines=8 \
	--line-height=32 \
	--width=80
} ## fuzzel menu config

niri_windows_title(){
	niri msg --json windows | jq -r '.[].title' | fuzzel_cmd
} ## niri outputs windows to fuzzel using jq and outputs index in list

win_id_list=($(niri msg --json windows | jq -r '.[].id')) ## Puts Window IDs in an array

ndx=$(niri_windows_title) ## start of script execution

## To avoid switching to windows when command is cancelled or there are no entries chosen
if (( $ndx >= 0 )); then
	## operation to store window id into $win_id
	win_id=${win_id_list[ndx]}
	## command to focus chosen window
	niri msg action focus-window --id $win_id
fi