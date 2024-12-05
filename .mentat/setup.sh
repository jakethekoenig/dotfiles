apt-get update
apt-get install -y zsh tmux neovim shellcheck
mkdir -p ~/.config/nvim
mkdir -p ~/.zsh
mkdir -p ~/.vim
git submodule update --init
./install.sh