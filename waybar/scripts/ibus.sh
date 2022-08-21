#!/usr/bin/env bash

ENGINE=$(ibus engine)

if [ $ENGINE = "hangul" ];
  then echo "한";
elif [ $ENGINE = "anthy" ];
  then echo "あ";
  else echo "en";
fi

