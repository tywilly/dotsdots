#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# ---------------------
# nvim
# ---------------------

# Install package manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Link config files
ln -s ${BASEDIR}/nvim ~/.config

# ---------------------
# tmux
# ---------------------

# Install package manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Link config file
ln -s ${BASEDIR}/.tmux.conf ~/.tmux.config

# ---------------------
# zsh
# ---------------------

ln -s ${BASEDIR}/.zshrc ~/.zshrc

# ---------------------
# i3
# ---------------------

ln -s ${BASEDIR}/i3 ~/.config

# ---------------------
# i3blocks
# ---------------------

ln -s ${BASEDIR}/i3blocks ~/.config

# ---------------------
# rofi
# ---------------------

ln -s ${BASEDIR}/rofi ~/.config

# ---------------------
# alacritty
# ---------------------

ln -s ${BASEDIR}/alacritty ~/.config

# ---------------------
# kitty
# ---------------------

ln -s ${BASEDIR}/kitty ~/.config

# ---------------------
