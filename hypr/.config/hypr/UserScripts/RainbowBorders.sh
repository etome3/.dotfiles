#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for rainbow borders animation

function random_hex() {
    random_hex=("0xff$(openssl rand -hex 3)")
    echo $random_hex
}

# rainbow colors only for active window
#hyprctl keyword general:col.active_border $(random_hex)  $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex)  270deg
# blue
hyprctl keyword general:col.active_border 0xff4A148C 0xff8E24AA 0xffAB47BC 0xffCE93D8  45deg
# red fire
# hyprctl keyword general:col.active_border 0xffB71C1C 0xffF44336 0xffFF9800 0xffFFEB3B  45deg
# purple
# hyprctl keyword general:col.active_border 0xff5d3da8 0xff8d4acc 0xffa166d6 0xffbf8eee 45deg

# rainbow colors for inactive window (uncomment to take effect)
#hyprctl keyword general:col.inactive_border $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) 270deg