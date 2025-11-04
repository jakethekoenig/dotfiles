#!/bin/zsh
# Quick script to add all the dotfile configs to the home directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Vim
ln -sfn "$CURRENT_DIR/vim" ~/.vim
ln -sf "$CURRENT_DIR/vim/vimrc" ~/.vimrc

# Python
pip3 install ptpython
ln -sf "$CURRENT_DIR/python_profile.py" ~/.python_profile.py

# Zsh
ln -sf "$CURRENT_DIR/zsh/zshrc" ~/.zshrc
ln -sfn "$CURRENT_DIR/zsh/local" ~/.zsh
source ~/.zshrc

# Tmux
ln -sfn "$CURRENT_DIR/tmux" ~/.tmux
ln -sf "$CURRENT_DIR/tmux/tmux.conf" ~/.tmux.conf

# Neovim (use vim config)
mkdir -p ~/.config/nvim
ln -sf "$CURRENT_DIR/vim/vimrc" ~/.config/nvim/init.vim

# AeroSpace
mkdir -p ~/.config/aerospace
ln -sf "$CURRENT_DIR/aerospace/aerospace.toml" ~/.config/aerospace/aerospace.toml

# Codex CLI
mkdir -p ~/.codex
ln -sf "$CURRENT_DIR/codex/config.toml" ~/.codex/config.toml

# Claude Code
mkdir -p ~/.claude
ln -sf "$CURRENT_DIR/.claude/settings.local.json" ~/.claude/settings.local.json
ln -sf "$CURRENT_DIR/.claude/settings.json" ~/.claude/settings.json

git submodule update --init
