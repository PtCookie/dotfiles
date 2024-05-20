#!/usr/bin/env bash

read INPUT

if [ $INPUT = "ja" ]; then
	ibus engine anthy
elif [ $INPUT = "ko" ]; then
	ibus engine hangul
elif [ $INPUT = "en" ]; then
	ibus engine xkb:us::eng
fi
