#!/usr/bin/env bash

set -euo pipefail

BASEDIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
dry_run=false

usage() {
    printf 'Usage: %s [--dry-run] [--help]\n' "${0##*/}"
}

for arg in "$@"; do
    case "$arg" in
        --dry-run) dry_run=true ;;
        -h|--help) usage; exit 0 ;;
        *) usage >&2; printf 'Unknown option: %s\n' "$arg" >&2; exit 2 ;;
    esac
done

run() {
    if "$dry_run"; then
        printf 'Would run:'
        printf ' %q' "$@"
        printf '\n'
    else
        "$@"
    fi
}

link_config() {
    local source=$1 destination=$2
    if [[ -L "$destination" && "$(readlink -- "$destination")" == "$source" ]]; then
        printf 'Already linked: %s\n' "$destination"
    elif [[ -e "$destination" || -L "$destination" ]]; then
        printf 'Conflict: %s already exists; left unchanged\n' "$destination" >&2
        conflicts=$((conflicts + 1))
    else
        run mkdir -p -- "$(dirname -- "$destination")"
        run ln -s -- "$source" "$destination"
    fi
}

clone_if_missing() {
    local url=$1 destination=$2
    shift 2
    if [[ -d "$destination/.git" ]]; then
        printf 'Already installed: %s\n' "$destination"
    elif [[ -e "$destination" || -L "$destination" ]]; then
        printf 'Conflict: %s already exists; left unchanged\n' "$destination" >&2
        conflicts=$((conflicts + 1))
    else
        run mkdir -p -- "$(dirname -- "$destination")"
        run git clone "$@" -- "$url" "$destination"
    fi
}

conflicts=0
clone_if_missing https://github.com/wbthomason/packer.nvim \
    "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" --depth 1
clone_if_missing https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

link_config "$BASEDIR/.tmux.conf" "$HOME/.tmux.config"
link_config "$BASEDIR/.zshrc" "$HOME/.zshrc"
for config in nvim i3 i3blocks rofi alacritty kitty hypr waybar quickshell; do
    link_config "$BASEDIR/$config" "$HOME/.config/$config"
done

if (( conflicts > 0 )); then
    printf '%d conflict(s) require attention. Move or back up those paths and rerun.\n' "$conflicts" >&2
    exit 1
fi
