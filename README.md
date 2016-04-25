This repo centralizes some of the `.rc` files that I often use so I can quickly setup new virtual machines.

## Misc configuration ##

```bash
cd /etc/
git clone https://github.com/adrienstoffel/rcfiles

ln -s /etc/rcfiles/.gitconfig ~/
ln -s /etc/rcfiles/.tmux/ ~/
ln -s /etc/rcfiles/.tmux.conf ~/
ln -s ~/.tmux/.tmux.conf.local ~/.tmux.conf.local
mkdir -p ~/.ssh/
cat /etc/rcfiles/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
```
## Common packages ##

* **Archlinux**:
```
TODO after next install...
```

* **Ubuntu**:
```bash
apt-get install build-essential clang libclang-3.8-dev libncurses-dev libz-dev cmake xz-utils ssh screen tmux git zsh vim vim-nox htop gdb strace ltrace python-dev python3-dev ipython ipython3 bpython bpython3 powerline fonts-powerline
```


## Common scripts ##

```bash
mkdir -p /scripts && cd /scripts/
git clone https://github.com/hugsy/gef
git clone https://github.com/gdbinit/Gdbinit
git clone https://github.com/longld/peda
pip2 install requests capstone ropgadget pwntools xortool
pip3 install requests capstone ropgadget
wget wget http://www.trapkit.de/tools/checksec.sh && chmod +x ./checksec.sh
git clone https://github.com/eugeii/ida-consonance
wget https://github.com/downloads/0vercl0k/rp/rp-lin-x64 && chmod +x rp-lin-x64
git clone https://github.com/acama/xrop && cd xrop && git submodule update --init --recursive && make && cd ..
```

## Setup zsh ##

```bash
ln -s /etc/rcfiles/.oh-my-zsh ~/
ln -s /etc/rcfiles/.zshrc ~/
```

* **Archlinux**:
```bash
yaourt -S aur/oh-my-zsh-git
```
* **Ubuntu**:
```bash
cd /etc/rcfiles/
git clone https://github.com/robbyrussell/oh-my-zsh/
sed -i 's/^ZSH=.*$/ZSH=\/etc\/rcfiles\/oh-my-zsh\//' .zshrc
```

## Setup vim ##

```bash
ln -s /etc/rcfiles/.vimrc ~/
cp -r /etc/rcfiles/.vim/ ~/
mkdir -p ~/.vim/bundle/
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim ~/.vimrc
    Disable unused plugins, then run :PluginInstall
```
* Install `color_coded` (for awesome C syntax hl):

Extact lua version from `vim --version | grep lua` then install it:

**Archlinux**:
```bash
TODO
```
**Ubuntu**:
```bash
apt-get install lua5.2 liblua5.2-dev
```
Proceed with the installation:
```bash
cd ~/.vim/bundle/color_coded/
mkdir build && cd build
make && make install
make clean && make clean_clang
```

* Install `YouCompleteMe` (for awesome completion):

```bash
cd ~/.vim/bundle/YouCompleteMe/
./install.py --clang-completer
```
