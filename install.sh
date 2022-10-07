#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# nvim
ln -s ${BASEDIR}/nvim ~/.config/nvim

# zsh
ln -s ${BASEDIR}/.zshrc ~/.zshrc

#i3
ln -s ${BASEDIR}/i3 ~/.config/i3

# alacritty
ln -s ${BASEDIR}/alacritty ~/.config/alacritty
