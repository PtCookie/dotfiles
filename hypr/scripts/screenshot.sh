#!/bin/sh

grim $(xdg-user-dir PICTURES)/$(uname -n)"_"$(date -Iseconds)".png"

dunstify "Screen capture" "Screen captured." -u normal
