apt-get update
apt-get install -y zsh tmux neovim
mkdir -p ~/.config/nvim
mkdir -p ~/.zsh
touch ~/.zsh/dummy.zsh
mkdir -p ~/.vim
git submodule update --init
./install.sh