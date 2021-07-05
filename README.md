# fitztech/dotfiles
-------------------
### Configuration files for various linux utilities.

Currently used for a PopOS laptop and desktop.

There are fancy tools for managing dotfiles, but symlinking works fine for me:
```
ln -s /home/kevin/code/dotfiles/alacritty.yml /home/kevin/.config/alacritty/alacritty.yml
ln -s /home/kevin/code/dotfiles/vimrc /home/kevin/.vimrc
ln -s /home/kevin/code/dotfiles/zshrc /home/kevin/.zshrc
ln -s /home/kevin/code/dotfiles/.tmux.conf /home/kevin/.tmux.conf
```
### Requirements
1. Vim with python3 support
```
sudo apt install vim-gtk3
```
2. Vundle
```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
3. Powerline
```
pip install powerline-status
```
4. Tmux Plugin Manager
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
5. Starship Prompt
```
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
```
6. Powerline Fonts (I use JetBrainsMono Medium Nerd Font from Nerd Fonts)
