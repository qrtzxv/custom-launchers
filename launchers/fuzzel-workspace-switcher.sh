#!/usr/bin/bash
## Fuzzel Niri Workspace Menu

mn=$(niri msg --json focused-output | jq -r .name) ## monitor name

am=$(niri msg --json workspaces | jq --arg key $mn '.[] | select (.output==$key)') ## json of active monitor ## the very command copied to $iindex due to jq formatting

fzzl_ln=$(echo $am | jq '.idx' | wc -l)

fuzzel_cmd(){
    fuzzel --dmenu \
    --border-color=00c896ff \
    --anchor=top-left \
    --lines=$(($fzzl_ln+2)) \
    --line-height=16 \
    --width=30%
	--placeholder="text"
} ## fuzzel menu config

iindex=$(
for ((l_idx = 1; l_idx <= fzzl_ln; ++l_idx)); do
    l_if=$(niri msg --json workspaces | jq --arg key $mn --arg keyy $l_idx '.[] | select (.output==$key and .idx==($keyy|tonumber)) | .is_focused')
    l_awi=$(niri msg --json workspaces | jq --arg key $mn --arg keyy $l_idx '.[] | select (.output==$key and .idx==($keyy|tonumber)) | .active_window_id')

    if [[ "$l_if" == "true" ]]; then
        ll_if=" [Current]"
    else
        ll_if=""
    fi

    if [[ "$l_awi" == "null" ]]; then
        ll_awi=" [Empty]"
    else
        ll_awi=""
    fi

    lline=$l_idx$ll_if$ll_awi

    #printf "%s" "\n$lline" ## Monitor first
	printf "%s" "$lline\n" ## Workspace Indexes first
done
)

## Monitor first
#echo_str="Current Monitor: $mn
#\n$iindex"

## Workspace Indexes first
echo_str="$iindex
\nCurrent Monitor: $mn"

workspace_index(){
	echo -e $echo_str | fuzzel_cmd | awk '{print $1}'
}

ws_idx=$(workspace_index) ## start of script execution
niri msg action focus-workspace $ws_idx ## move to workspace chosen in fuzzel menu
