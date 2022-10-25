#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# nvim
ln -s ${BASEDIR}/nvim ~/.config
ln -s ${BASEDIR}/vim ~/.vim

# zsh
ln -s ${BASEDIR}/.zshrc ~/.zshrc

#i3
ln -s ${BASEDIR}/i3 ~/.config

# i3blocks
ln -s ${BASEDIR}/i3blocks ~/.config

# rofi
ln -s ${BASEDIR}/rofi ~/.config

# alacritty
ln -s ${BASEDIR}/alacritty ~/.config
