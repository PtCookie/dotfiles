#!/bin/sh

grim -g "$(slurp)" $(xdg-user-dir PICTURES)/$(uname -n)"_"$(date -Iseconds)".png"

dunstify "Screen capture" "Area captured." -u normal
