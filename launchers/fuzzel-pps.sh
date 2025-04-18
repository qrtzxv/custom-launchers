#!/usr/bin/bash
## Fuzzel Powerprofile Switcher

pp_b="- balanced                    - General non-specialized tuned profile"
pp_bb="- balanced-battery            - Balanced profile biased towards power savings changes for battery"
pp_tpp="- throughput-performance      - Broadly applicable tuning that provides excellent performance across a variety of common server workloads"
pp_ps="- powersave                   - Optimize for low power consumption"

lines="$(tuned-adm list | wc -l)"

fuzzel_cmd(){
	fuzzel --dmenu \
	--border-color=ee7848ff \
	--anchor=center \
	--lines=4 \
	--line-height=16 \
	--width=150%
} ## fuzzel menu config

pp=$(echo -e "$pp_b\n$pp_bb\n$pp_tpp\n$pp_ps" | fuzzel_cmd | awk -F '- ' '{print $2}')

case $pp in
	"balanced "*)
	icon="/usr/share/icons/breeze-dark/status/32/battery-060-profile-balanced.svg"
	;;
	"balanced-battery "*)
	icon="/usr/share/icons/breeze-dark/status/32/battery-060-charging-profile-balanced.svg"
	;;
	"throughput-performance "*)
	icon="/usr/share/icons/breeze-dark/status/32/battery-060-profile-performance.svg"
	;;
	"powersave "*)
	icon="/usr/share/icons/breeze-dark/status/32/battery-060-profile-powersave.svg"
	;;
	*)
	pp=$(tuned-adm active | awk '{print $4}')
	icon="/usr/share/icons/breeze-dark/status/32/battery-060.svg"
	;;
esac

notify-send -t 30000 -c battery -i $icon "Current power profile : " "$pp"

tuned-adm profile $pp
