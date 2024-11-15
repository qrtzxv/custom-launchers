#!/usr/bin/bash
## Fuzzel System Menu

#date_d=$(date +"%Y %b %d")
#date_t=$(date +"%H : %M : %S")
dt="$(date +"%a || %Y %b %d || %H : %M : %S")"
bat_pcent="Current: $(bat-man capacity)" ## comment out when not using a battery, change accordingly to battery daemon
bat_max="Max:     $(bat-man threshold)" ##
bat_stat="Status:  $(bat-man status)" ##
vol_out="Vol: $(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2, $3}')"
vol_in="Mic: $(wpctl get-volume @DEFAULT_SOURCE@ | awk '{print $2, $3}')"
netwrx=$(nmcli -f TYPE,NAME connection show --active | grep -E 'ethernet|wlan')
ppc="Current: $(powerprofilesctl get)" ##
cpu_pcent=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
cpu_temp=$(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 ))
ram_pcent=$(free | grep Mem | awk '{print ($3/$2)*100}')

echo_str="$dt
\n
\n> Audio ↴
\n$vol_out
\n$vol_in
\n
\nBattery ↴
\n$bat_pcent / $bat_max
\n$bat_stat
\n
\n> Network ↴
\n$netwrx
\n
\nPower Profile ↴
\n$ppc
\n
\nCPU Usage: $cpu_pcent %
\nCPU Temp: $cpu_temp°C
\n
\nMemory Usage: $ram_pcent %"

fuzzel_cmd(){
    fuzzel --dmenu \
	--border-color=78ee78ff \
	--anchor=top-left \
	--lines=20 \
	--line-height=16 \
	--width=40%
} ## fuzzel menu config

run_fuzzel(){
	echo -e $echo_str | fuzzel_cmd
} ## choices to list in fuzzel

fzzl_choice="$(run_fuzzel)" ## start of script execution
case ${fzzl_choice} in
    "> Audio ↴ ")
        ## Spawn Audio Control Program , change accordingly
        pavucontrol
    ;;
    "$vol_out ")
        ## Mute / Unmute Speakers / Headset
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    ;;
    "$vol_in ")
        ## Mute / Unmute Micropphone
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    ;;
    "> Network ↴ ")
        ## Spawn Network Manager Program , change accordingly
        nm-connection-editor
    ;;
esac
