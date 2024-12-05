# Check shell scripts
shellcheck install.sh
# Verify symlinks are correct
test -L ~/.vim && test -e ~/.vim
test -L ~/.vimrc && test -e ~/.vimrc
test -L ~/.zsh && test -e ~/.zsh
test -L ~/.zshrc && test -e ~/.zshrc
test -L ~/.tmux && test -e ~/.tmux
test -L ~/.tmux.conf && test -e ~/.tmux.conf
test -L ~/.config/nvim/init.vim && test -e ~/.config/nvim/init.vim