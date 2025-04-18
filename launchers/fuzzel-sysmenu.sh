#!/usr/bin/bash
## Fuzzel System Menu

#date_d=$(date +"%Y %b %d")
#date_t=$(date +"%H : %M : %S")
dt=$(date +"%Y %b %d %a || %H : %M : %S")
focused_ws="> Workspace: "$(niri msg --json workspaces | jq '.[] | select((.is_focused == true) and (.is_active == true))' | jq .idx)
focused_win=$(niri msg --json windows | jq '.[] | select(.is_focused == true)' | jq '.title') ## insert whatever command it is for your window manager/compositor
bat_pcent="Current: $(bat-man capacity)" ### comment out when not using a battery, change accordingly to battery daemon
bat_max="Max: "$(bat-man threshold) ###
bat_stat="Status: "$(bat-man status) ###
vol_out="> Vol: "$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2, $3}') #### whatever audio service you're using
vol_in="> Mic: "$(wpctl get-volume @DEFAULT_SOURCE@ | awk '{print $2, $3}') ####
netwrx=$(nmcli -f TYPE,NAME connection show --active | grep -E 'ethernet|wlan|wifi' | head -n 1)
wifi="Wifi Status: "$(nmcli g | awk '{print $4}' | grep 'abled')
pp="Current: "$(tuned-adm active | awk -F ': ' '{print $2}') ## current power profile
cpu_pcent=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
cpu_temp=$(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 ))
ram_pcent=$(free | grep Mem | awk '{print ($3/$2)*100}')

echo_str="
> $dt
\n
\n$focused_ws
\n> Window ⌄
\n$focused_win
\n
\n> Audio ⌄
\n$vol_out
\n$vol_in
\n
\nBattery ⌄
\n$bat_pcent / $bat_max
\n$bat_stat
\n
\n> Power Profile ⌄
\n$pp
\n
\n> Network ⌄
\n$netwrx
\n$wifi
\n
\n> btop
\nCPU Usage: $cpu_pcent %
\nCPU Temp: $cpu_temp°C
\nRAM Usage: $ram_pcent %
"

fzzl_lines=$(echo -e $echo_str | wc -l) ## dynamic line amount for the menu

fuzzel_cmd(){
    fuzzel --dmenu \
	--border-color=7878eeff \
	--anchor=bottom-left \
	--lines=$fzzl_lines \
	--line-height=16 \
	--width=36%
} ## fuzzel menu config

run_fuzzel(){
	echo -e $echo_str | fuzzel_cmd
} ## choices to list in fuzzel

fzzl_choice="$(run_fuzzel)" ## start of script execution ## change command/s accrodingly
case $fzzl_choice in
	"> $dt ")
		## spawns cal(endar) command in fuzzel
		cal | fuzzel --dmenu --border-color=7878eeff --anchor=left --lines=8 --width=21
	;;
	"$focused_ws ")
		## spawns custom workspace switcher in fuzzel
		./scrpts/fuzzel-workspace-switcher.sh
	;;
	"> Window ⌄ ")
		## spawns custom window switcher in fuzzel
		./scrpts/fuzzel-window-switcher.sh
	;;
    "> Audio ⌄ ")
        ## Spawn Audio Control Program , change accordingly
        flatpak run com.saivert.pwvucontrol
    ;;
    "$vol_out"|"$vol_out ")
        ## Mute / Unmute Speakers / Headset
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    ;;
    "$vol_in"|"$vol_in ")
        ## Mute / Unmute Microphone
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    ;;
	"> Power Profile ⌄ ")
		## Show all possible profiles
		##lines="$(tuned-adm list | wc -l)"
		##tuned-adm list | fuzzel --dmenu --border-color=ee7848ff --anchor=center --width=150% --lines=$lines
		./scrpts/fuzzel-pps.sh
	;;
    "> Network ⌄ ")
        ## Spawn Network Manager Program , change accordingly
        nm-connection-editor
    ;;
    "> btop ")
        ## Spawn system monitor , change to preference
        alacritty -e btop
    ;;
	*)
	exit 0
	;;
esac
