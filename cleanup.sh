#!/bin/zsh
# Remove all symlinks created by install.sh

echo "Removing dotfile symlinks..."

# Vim
rm -f ~/.vimrc
rm -f ~/.vim

# Python
rm -f ~/.python_profile.py

# Zsh
rm -f ~/.zshrc
rm -f ~/.zsh

# Tmux
rm -f ~/.tmux.conf
rm -f ~/.tmux

# Neovim
rm -f ~/.config/nvim/init.vim

# AeroSpace
rm -f ~/.config/aerospace/aerospace.toml

echo "Cleanup complete!"
