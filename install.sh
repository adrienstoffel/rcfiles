#!/bin/bash

if [[ `id -u` == 0 ]]; then
	echo "You should not run this script as root. Make sure the current user is in the sudoers."
	exit 1
fi

if [ ! -z "$(whereis -b apt | awk '{ print $2 }')" ]; then
	pkgmgr="apt"
elif [ ! -z "$(whereis -b pacman | awk '{ print $2 }')" ]; then
	pkgmgr="pacman"
elif [ ! -z "$(whereis -b yum | awk '{ print $2 }')" ]; then
	pkgmgr="yum"
else
	echo "Can't find the package manager. Aborting..."
	exit 1
fi

distribution=$(lsb_release -i|awk '{ split($0, a, /:\s*/); print a[2] }')
release=$(lsb_release -r|awk '{ split($0, a, /:\s*/); print a[2] }')

# Ask for package groups to install

yes_no () {
	while :; do 
		read -p "$1 [y/n] " answer
		case ${answer:0:1} in
			y|Y )
				echo 'y'
				return 1
			;;
			n|N )
				echo 'n'
				return 0
			;;
			* )
				continue
			;;
		esac
	done
}

has_pwn=$(yes_no "Install pwn packages?")
has_desktop=$(yes_no "Install desktop packages?")
has_virt=$(yes_no "Install virtualization packages?")
has_docker=$(yes_no "Install docker?")
has_tex=$(yes_no "Install LaTeX?")

# ArchLinux requirements

if [[ "${pkgmgr}" == "pacman" ]]; then
	# Install the yay package manager

	if [ -z "$(whereis -b yay | awk '{ print $2 }')" ]; then
		cd /tmp
		sudo pacman -S --needed base-devel git
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si
	fi
	pkgmgr="yay"

	# Enable multilib

	if [ ! -z "$(cat /etc/pacman.conf|grep '#\[multilib\]')" ]; then
		sudo sed -i -z "s/\#\[multilib\][[:space:]]*\#/\[multilib\]\n/" /etc/pacman.conf
	fi

	if [[ "${has_pwn}" == "y" ]]; then
		# Add the blackarch repository (if pwn)
		cd /tmp
		curl -O https://blackarch.org/strap.sh
		chmod +x strap.sh
		sudo ./strap.sh
	fi
	sudo pacman -Syu

	# Make sure the locale is correctly configured, this can mess up powerline

	locale 2>&1 | grep "No such file or directory"
	if [[ $? == 0 ]]; then
		localectl set-locale LANG=en_US.UTF-8
	fi

# Ubuntu / Debian requirements
elif [[ "${pkgmgr}" == "apt" ]]; then
	if [[ "${has_docker}" == "y" ]]; then
		sudo apt-get update
		sudo apt-get install \
			ca-certificates \
			curl \
			gnupg \
			lsb-release
		sudo mkdir -p /etc/apt/keyrings

		if [[ "${distribution}" == "Ubuntu" ]]; then
			curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
			echo \
				"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
				$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		else
			curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
			echo \
				"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
				$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		fi
	fi
	sudo apt-get update

# CentOS 8 requirements
elif [[ "${pkgmgr}" == "yum" ]]; then
	sudo yum -y install epel-release yum-utils
	if [[ "${has_docker}" == "y" ]]; then
		sudo yum-config-manager \
			--add-repo \
			https://download.docker.com/linux/centos/docker-ce.repo
	fi
fi

base_pkgs=""
pwn_pkgs=""
desktop_pkgs=""
tex_pkgs=""
virt_pkgs=$(cat <<EOF
	qemu
	virt-manager
	virtualbox
EOF
)

if [[ "${pkgmgr}" == "yay" ]]; then
	# ArchLinux
	base_pkgs=$(cat << EOF
	automake
	bpython
	clang
	cmake
	cscope
	ctags
	curl
	gdb
	git
	gnupg
	gvim
	hexedit
	htop
	inetutils
	ipython
	linux-api-headers
	ltrace
	man
	most
	nano
	open-vm-tools
	openssh
	php
	powerline
	powerline-common
	powerline-fonts
	powerline-vim
	python2
	python2-colorama
	python2-requests
	python-colorama
	python-mysql-connector
	python-requests
	rsync
	screen
	socat
	sshpass
	strace
	tcpdump
	tmux
	vim-jad
	vim-latexsuite
	vim-runtime
	wget
	xinetd
	zsh
EOF
)
	pwn_pkgs=$(cat << EOF
	aflplusplus
	afl-utils
	aircrack-ng
	amass
	binwalk
	capstone
	ffuf
	gef
	ghidra
	impacket
	john
	metasploit
	nasm
	patchelf
	pwndbg
	python-pwntools
	sqlmap
EOF
)
	desktop_pkgs=$(cat << EOF
	arandr
	chromium
	dolphin
	eog
	evince
	feh
	gimp
	i3
	i3-gaps
	i3blocks
	i3lock
	i3status
	irssi
	freerdp
	keepass
	network-manager-applet
	noto-fonts
	noto-fonts-emoji
	openvpn
	picom
	pulseaudio
	remmina
	rofi
	slock
	vlc
	weechat
	wine
	wireshark
	xdotool
	xorg-apps
	xorg-xinit
	xorg-server
	xf86-video-intel
	xfce4-screenshooter
	xfce4-terminal
EOF
)
	docker_pkgs="docker docker-compose"
	tex_pkgs="texlive-most"
elif [[ "${pkgmgr}" == "apt" ]]; then
	# Ubuntu

	base_pkgs=$(cat << EOF
	automake
	bpython
	bpython3
	build-essential
	clang
	cmake
	cscope
	curl
	exuberant-ctags
	fonts-powerline
	gdb
	git
	glibc-source
	gpg
	hexedit
	htop
	ipython
	ipython3
	libc6-dbg
	libc6-dev
	libc6-i386
	libncurses-dev
	linux-headers-generic
	ltrace
	most
	nano
	net-tools
	open-vm-tools
	php
	powerline
	python3
	python3-colorama
	python3-requests
	python-colorama
	python-mysql-connector
	python-requests
	rsync
	screen
	socat
	ssh
	sshpass
	strace
	tcpdump
	tmux
	vim
	vim-nox
	wget
	xinetd
	xz-utils
	zsh
EOF
)
	pwn_pkgs=$(cat << EOF
	afl
	afl-clang
	afl-cov
	afl-doc
	aircrack-ng
	binwalk
	gdb-multiarch
	gdbserver
	python-impacket
	john
	john-data
	nasm
	patchelf
	sqlmap
EOF
)
	desktop_pkgs=$(cat << EOF
	arandr
	chromium-browser
	compton
	dolphin
	eog
	evince
	feh
	gimp
	i3
	i3blocks
	i3lock
	i3status
	irssi
	freerdp-x11
	keepass2
	nm-tray
	openvpn
	pulseaudio
	remmina
	rofi
	suckless-tools
	vlc
	weechat
	wine-stable
	wireshark
	xdotool
	xinit
	xfce4-screenshooter
	xfce4-terminal
EOF
)
	docker_pkgs=$(cat << EOF
	docker-ce
	docker-ce-cli
	containerd.io
	docker-compose-plugin
EOF
)
	tex_pkgs="texlive"
else # CentOS/Fedora
	# CentOS (tested on 8)

	base_pkgs=$(cat << EOF
	automake
	bpython
	bpython3
	build-essential
	clang
	cmake
	cscope
	ctags
	curl
	gdb
	git
	gpg
	hexedit
	htop
	ipython
	ipython3
	ltrace
	most
	nano
	net-tools
	open-vm-tools
	openssh
	php
	powerline
	python2-pip
	python3
	python3-colorama
	python3-pip
	python3-requests
	rsync
	screen
	socat
	sshpass
	strace
	tcpdump
	tmux
	tmux-powerline
	vim
	vim-powerline
	wget
	xinetd
	zsh
EOF
)
	pwn_pkgs=$(cat << EOF
	patchelf
EOF
)
	desktop_pkgs=$(cat << EOF
	chromium
	dolphin
	eog
	evince
	keepassxc
	openvpn
	remmina
	wireshark
	xfce4-screenshooter
	xfce4-terminal
EOF
)
	docker_pkgs=$(cat << EOF
	docker-ce
	docker-ce-cli
	containerd.io
	docker-compose-plugin
EOF
)
	tex_pkgs="texlive"
fi

pkgs="${base_pkgs}"
if [[ "${has_pwn}" == "y" ]]; then pkgs="${pkgs} ${pwn_pkgs}"; fi
if [[ "${has_desktop}" == "y" ]]; then pkgs="${pkgs} ${desktop_pkgs}"; fi
if [[ "${has_virt}" == "y" ]]; then pkgs="${pkgs} ${virt_pkgs}"; fi
if [[ "${has_docker}" == "y" ]]; then pkgs="${pkgs} ${docker_pkgs}"; fi
if [[ "${has_tex}" == "y" ]]; then pkgs="${pkgs} ${tex_pkgs}"; fi

# Install packages (let the user type 'y' to verify everything is as expected)

BLUE='\033[1;34m'
RED='\033[1;31m'
NC='\033[0m'

if [[ "${pkgmgr}" == "yay" ]]; then
	yay -S -- ${pkgs}
elif [[ "${pkgmgr}" == "apt" ]]; then
	sudo apt --ignore-missing install -- ${pkgs} 2>/tmp/apt.errors 
	if [[ $? > 0 ]]; then
		fails=$(cat /tmp/apt.errors | grep 'Unable to locate package' | awk '{ print $6 }')
		fails="$fails"$'\n'$(cat /tmp/apt.errors |grep 'has no installation candidate' | awk '{ print $3 }'|tr -d "'")
		fails=$(echo "${fails}" | sed "s/\x1b\[0m//g")
		pkgs=$(echo "${pkgs}" | sort -u | tr "\n" " ")
		while read word; do
			word=$(echo "${word}" | tr -d "\n")
			pkgs=$(echo " ${pkgs} " | sed -E "s/[[:space:]]+${word}[[:space:]]+/ /g")
		done <<< "${fails}"
		echo -e "${RED}The following packages were not found and will not be installed:${NC}"
		echo ${fails}
		read -p "Press enter to continue..." _
		sudo apt install -- ${pkgs}
		if [[ $? > 0 ]]; then
			echo "Invalid packages found. Plz fix."
			exit 1
		fi
	fi
	if [[ "${has_pwn}" == "y" ]]; then
		sudo pip2 install pwntools
		sudo pip3 install pwntools
	fi
elif [[ "${pkgmgr}" == "yum" ]]; then
	sudo yum install ${pkgs}
fi

if [[ "${has_pwn}" == "y" ]]; then
	# rp++
	sudo wget https://github.com/0vercl0k/rp/releases/download/v2.0.2/rp-lin-x64 -O /usr/bin/rp++
	sudo wget https://github.com/0vercl0k/rp/releases/download/v1/rp-lin-x64 -O /usr/bin/rp
	sudo chmod +x /usr/bin/rp /usr/bin/rp++

	# xrop
	cd /tmp
	git clone https://github.com/acama/xrop
	cd xrop
	git submodule update --init --recursive
	make
	sudo make install
	cd /tmp
	rm -rf xrop

	if [[ "${pkgmgr}" != "yay" ]]; then
		# pwndbg 
		cd /usr/share
		sudo git clone https://github.com/pwndbg/pwndbg
		cd pwndbg
		sudo ./setup.sh
		# gef
		cd /usr/share
		sudo git clone https://github.com/hugsy/gef
		# peda
		sudo git clone https://github.com/longld/peda
	fi

	cp /etc/rcfiles/.gdbinit ~/
	sudo cp /etc/rcfiles/.gdbinit /root/

	# set the substitution path of the libc

	if [[ "${pkgmgr}" == "apt" ]]; then
		cat > /tmp/cmds << EOF
set breakpoint pending on
b __libc_start_main
r 0
info source
quit
EOF
		gdb /bin/sleep -x /tmp/cmds 2>/dev/null | \
			grep 'Compilation directory.*glibc' | \
			awk '{ split($4, dirs, "/"); print "set substitute-path /"dirs[2]"/"dirs[3]" /usr/src/glibc" }' \
			>> ~/.gdbinit
		sudo cp ~/.gdbinit /root/
		rm -f /tmp/cmds
	fi
fi

# setup zsh with oh-my-zsh

cd /etc/rcfiles/
if [[ "${pkgmgr}" == "apt" ]]; then
	cd /usr/share
	sudo git clone https://github.com/robbyrussell/oh-my-zsh/
elif [[ "${pkgmgr}" == "yay" ]]; then
	yay -S aur/oh-my-zsh-git
fi

# setup tmux

if [ ! -e /usr/share/.tmux/ ]; then
	cd /usr/share
	sudo git clone https://github.com/gpakosz/.tmux
fi

# configure git, zsh, vim and tmux for the current user and root

declare -A opts=([" "]=~ ["sudo"]="/root")
for opt in "${!opts[@]}"; do
	echo "${opt} ln -s /etc/rcfiles/.config ${opts[$opt]}"
	homedir="${opts[$opt]}"
	${opt} ln -s /etc/rcfiles/.gitconfig ${homedir}/
	${opt} ln -s /usr/share/.tmux/.tmux.conf ${homedir}/
	${opt} ln -s /etc/rcfiles/.tmux.conf.local ${homedir}/
	${opt} mkdir -p ${homedir}/.ssh/
	${opt} cat /etc/rcfiles/.ssh/id_rsa.pub > ${homedir}/.ssh/authorized_keys
	${opt} ln -s /etc/rcfiles/.oh-my-zsh ${homedir}/
	${opt} ln -s /etc/rcfiles/.zshrc ${homedir}/
	${opt} ln -s /etc/rcfiles/.vimrc ${homedir}/
	${opt} ln -s /etc/rcfiles/.vim/ ${homedir}/
	if [ ! -e "${homedir}/.bashrc" ]; then
		${opt} ln -s /etc/rcfiles/.bashrc ${homedir}/
	fi
done
if [[ -e "/usr/bin/zsh" ]]; then
	sudo chsh -s /usr/bin/zsh root
	sudo chsh -s /usr/bin/zsh ${USER}
fi

if [ ! -e ~/.vim/bundle/Vundle ]; then
	sudo mkdir -p ~/.vim/bundle/
	sudo git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	sudo vim +'PluginInstall' +qa
fi

if [[ "${has_desktop}" == "y" ]]; then
	ln -s /etc/rcfiles/.xinitrc ~/
	ln -s /etc/rcfiles/.Xresources ~/
	rm -rf ~/.config/i3/
	ln -s /etc/rcfiles/.config/i3 ~/.config/i3
	ln -s /etc/rcfiles/.config/wallpaper ~/.config/
	rm -rf ~/.config/xfce4/terminal
	mkdir -p ~/.config/xfce4
	cp -r /etc/rcfiles/.config/xfce4/terminal ~/.config/xfce4/
	cd /tmp
	git clone https://github.com/googlefonts/RobotoMono/
	cd RobotoMono/fonts
	sudo cp -r ttf /usr/share/fonts/
fi

# TODO: download and install vmware
# TODO: burp / IDA?

