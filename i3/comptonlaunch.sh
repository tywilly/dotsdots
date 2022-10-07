#!/bin/bash

killall -p picom --config ~/.config/picom/picom.conf

picom &
