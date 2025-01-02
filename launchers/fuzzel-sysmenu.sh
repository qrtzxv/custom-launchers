#!/usr/bin/bash
## Fuzzel System Menu

#date_d=$(date +"%Y %b %d")
#date_t=$(date +"%H : %M : %S")
dt=$(date +"%Y %b %d %a || %H : %M : %S")
focused_win=$(niri msg --json windows | jq '.[] | select(.is_focused == true)' | jq '.title') ## insert whatever command it is for your window manager/compositor
bat_pcent="Current: $(bat-man capacity)" ### comment out when not using a battery, change accordingly to battery daemon
bat_max="Max: "$(bat-man threshold) ###
bat_stat="Status: "$(bat-man status) ###
vol_out="> Vol: "$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2, $3}') #### whatever audio service you're using
vol_in="> Mic: "$(wpctl get-volume @DEFAULT_SOURCE@ | awk '{print $2, $3}') ####
netwrx=$(nmcli -f TYPE,NAME connection show --active | grep -E 'ethernet|wlan|wifi' | head -n 1)
pp="Current: "$(tuned-adm active | awk -F ': ' '{print $2}') ## current power profile
cpu_pcent=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
cpu_temp=$(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 ))
ram_pcent=$(free | grep Mem | awk '{print ($3/$2)*100}')

echo_str="$dt
\n
\nCurrect Focused Window ⌄
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
\n> Network ⌄
\n$netwrx
\n
\n> Power Profile ⌄
\n$pp
\n
\nCPU Usage: $cpu_pcent %
\nCPU Temp: $cpu_temp°C
\n
\nMemory Usage: $ram_pcent %"

fzzl_lines=$(echo -e $echo_str | wc -l) ## dynamic line amount for the menu

fuzzel_cmd(){
    fuzzel --dmenu \
	--border-color=7878eeff \
	--anchor=top-left \
	--lines=$fzzl_lines \
l	--line-height=16 \
	--width=36%
} ## fuzzel menu config

run_fuzzel(){
	echo -e $echo_str | fuzzel_cmd
} ## choices to list in fuzzel

fzzl_choice="$(run_fuzzel)" ## start of script execution ## change command/s accrodingly
case ${fzzl_choice} in
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
    "> Network ⌄ ")
        ## Spawn Network Manager Program , change accordingly
        nm-connection-editor
    ;;
	"> Power Profile ⌄ ")
		## Show all possible profiles
		lines="$(tuned-adm list | wc -l)"
		tuned-adm list | fuzzel --dmenu --width=150% --lines=$lines
	;;
esac
