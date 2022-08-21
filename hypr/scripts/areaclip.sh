#!/bin/sh

grim -g "$(slurp)" - | wl-copy

dunstify "Screen capture" "Area captured to clipboard." -u normal
