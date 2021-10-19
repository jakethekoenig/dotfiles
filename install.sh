#!/bin/bash
# Quick script to add all the dotfile configs to the home directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -s vim ~/.vim
ln -s vim/vimrc ~/.vimrc

ln -s zsh/zshrc ~/.zshrc
source ~/.zshrc

ln -s tmux/ ~/.tmux
ln -s tmux/tmux.conf ~/.tmux.conf
