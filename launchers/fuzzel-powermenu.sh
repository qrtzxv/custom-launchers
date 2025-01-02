#!/usr/bin/bash
## Fuzzel Powermenu

lk=' Lock'
lg='󰿅 Log Out'
rb='󰜉 Restart'
sd='󰐥 Shutdown'
y='󰿄 Yes'
n='󱞳 No'

fuzzel_cmd(){
    fuzzel --dmenu \
	--border-color=ee7878ff \
	--anchor=bottom-left \
	--lines=4 \
	--line-height=32 \
	--width=12
} ## fuzzel menu config

run_fuzzel(){
	echo -e "$lk\n$lg\n$rb\n$sd" | fuzzel_cmd
} ## action choices to list in fuzzel

confirm_exit(){
	echo -e "$n\n$y" | fuzzel_cmd
} ## confirmation choices to list in fuzzel

fzzl_choice="$(run_fuzzel)" ## start of script execution

if [[ "$fzzl_choice" == "$lk" || "$fzzl_choice" == "$lg" || "$fzzl_choice" == "$rb" || "$fzzl_choice" == "$sd" ]]; then 
    confirm_choice="$(confirm_exit)"
    if [ "$confirm_choice" == "$y" ]; then
        case ${fzzl_choice} in
            $lk)
                ## edit accordingly to lock command
                swaylock
            ;;
            $lg)
                ## edit accordingly to logout command
                niri msg action quit --skip-confirmation
            ;;
            $rb)
                systemctl reboot
            ;;
            $sd)
                systemctl poweroff
            ;;
        esac
    fi
fi
