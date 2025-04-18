#!/usr/bin/bash
## Fuzzel Powermenu

mo='🖵 Monitors Off'
lk=' Lock'
optn='🖵 +  = 1 + 2'
lg='󰿅 Log Out'
sp='⏸ Suspend'
rb='󰜉 Restart'
sd='󰐥 Shutdown'
y='󰿄 Yes'
n='󱞳 No'

fuzzel_cmd(){
    fuzzel --dmenu \
	--border-color=ee7878ff \
	--anchor=bottom-left \
	--lines=7 \
	--line-height=32 \
	--width=15
} ## fuzzel menu config

run_fuzzel(){
	echo -e "$mo\n$lk\n$optn\n$lg\n$sp\n$rb\n$sd" | fuzzel_cmd
} ## action choices to list in fuzzel

confirm_exit(){
	echo -e "$n\n$y" | fuzzel_cmd
} ## confirmation choices to list in fuzzel

fzzl_choice="$(run_fuzzel)" ## start of script execution

if [[ "$fzzl_choice" == "$mo" || "$fzzl_choice" == "$lk" || "$fzzl_choice" == "$optn" || "$fzzl_choice" == "$lg" || "$fzzl_choice" == "$rb" || "$fzzl_choice" == "$sd" ]]; then 
    confirm_choice="$(confirm_exit)"
    if [ "$confirm_choice" == "$y" ]; then
        case ${fzzl_choice} in
            $mo)
                ## Power off Monitors
                niri msg action power-off-monitors
            ;;
            $lk)
                ## edit accordingly to lock command
                swaylock
            ;;
			$optn)
                ## lock system and turn off monitors
                niri msg action power-off-monitors && swaylock
            ;;
            $lg)
                ## edit accordingly to logout command
                niri msg action quit --skip-confirmation
            ;;
            $sp)
                ## Suspend
                systemctl suspend
            ;;
            $rb)
				## Reboot
                systemctl reboot
            ;;
            $sd)
				## Shutdown / Power Off
                systemctl poweroff
            ;;
        esac
    fi
fi
