#!/bin/bash
# Quick script to add all the dotfile configs to the home directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ~
echo $CURRENT_DIR

mkdir temp
rm -rf ~/.vim
rm ~/.vimrc
ln -s "$CURRENT_DIR/vim" ~/.vim
ln -s "$CURRENT_DIR/vim/vimrc" ~/.vimrc
rm -rf temp

rm ~/.zshrc
rm -r ~/.zsh
ln -s "$CURRENT_DIR/zsh/zshrc" ~/.zshrc
ln -s "$CURRENT_DIR/zsh/local" ~/.zsh
source ~/.zshrc

rm -rf ~/.tmux
rm ~/.tmux.conf
ln -s "$CURRENT_DIR/tmux/" ~/.tmux
ln -s "$CURRENT_DIR/tmux/tmux.conf" ~/.tmux.conf

# So vim config works in neovim
ln -s "$CURRENT_DIR/nvm/init.vim" ~/.config/nvim/init.vim
