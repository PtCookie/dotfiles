#!/usr/bin/env bash

if [ "$(ibus engine)" = "hangul" ];
  then ibus engine anthy;
elif [ "$(ibus engine)" = "anthy" ];
  then ibus engine xkb:us::eng;
  else ibus engine hangul;
fi

