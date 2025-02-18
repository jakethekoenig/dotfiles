#!/bin/zsh
# Quick script to add all the dotfile configs to the home directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -rf ~/.vim
rm ~/.vimrc
ln -s "$CURRENT_DIR/vim" ~/.vim
ln -s "$CURRENT_DIR/vim/vimrc" ~/.vimrc

pip3 install ptpython
rm ~/.python_profile.py
ln -s "$CURRENT_DIR/python_profile.py" ~/.python_profile.py

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
rm ~/.config/nvim/init.vim
ln -s "$CURRENT_DIR/vim/vimrc" ~/.config/nvim/init.vim

git submodule update --init
