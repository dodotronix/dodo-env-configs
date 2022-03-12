#makefile for dodotronix's enviroment setup

SCRIPT_PATH:=$(shell pwd)
XORG_PATH:=/etc/X11
XORG_CONFD_DIR:=xorg.conf.d

all:
	@printf 'USAGE : make test | run\n'
	@printf '        make test - test recipe for makefile development\n'
	@printf '        make run  - checks the sofware and install the complete env\n' 

init:
	git submodule update --init --recursive

run:_check_software _install_packages _create_symlinks \
	_install_yay install_yay_packages
install_enviroment: _install_xfce load_i3xfce4 
load_i3xfce4: _load_xfce_settings _create_xfce_i3_symlinks
install_tools: install_neovim install_zsh install_doom_emacs  

# test:_install_neovim _install_doom_emacs
#test:_install_packages _create_symlinks _install_zsh 
#test: _install_xfce _create_xfce_i3_symlinks 
#test:  _install_neovim
test: _install_fonts 
	@printf 'dodo''s enviroment\n'
	@printf '$(SCRIPT_PATH)\n'

_check_software:
	@type sudo >/dev/null 2>@1 || { \
		printf 'ERR: "sudo" is probably not installed"\n' >&2; \
		false; }

_install_packages:
	@sudo pacman -Syu --noconfirm; \
		sudo pacman --noconfirm -S  wget gajim emacs \
		archlinux-keyring bitwarden python alsa-utils \
		xorg-server xorg-xinput xorg-xmodmap xorg-xev xorg-setxkbmap \
		xf86-input-synaptics xf86-input-libinput \
		evolution gnome-keyring bluez bluez-utils \
		pulseaudio pulseaudio-bluetooth blueberry \
		cups network-manager-applet pulseaudio-alsa \
		mtpfs gvfs-gphoto2 gvfs-mtp man-db \
		firewalld ipset lightdm lightdm-gtk-greeter firefox \
		pavucontrol alacritty ranger usbutils; \
		sudo systemctl enable bluetooth.service; \
		pulseaudio -k; pulseaudio --start

_install_yay:
	cd /tmp; \
	git clone https://aur.archlinux.org/yay.git; \
	cd yay; makepkg -si --noconfirm; cd $(SCRIPT_PATH)

install_yay_packages:
	@yay --noconfirm -S spotify --nocleanmenu --nodiffmenu

install_kicad:
	@yay --noconfirm -S kicad-git kicad-libraries-git --nocleanmenu --nodiffmenu; \
		cd Projects; git clone git@github.com:dodotronix/dodo-env-configs.git; cd

install_flatcam:
	@yay --noconfirm -S flatcam-git --nocleanmenu --nodiffmenu; \
		echo "replace import collections with import collections.abc as collections in
	all files which will raise an exception"; \
		sudo pip uninistall vispy && sudo pip install vispy==0.7

install_bcnc:
	@sudo pacman --noconfirm -S python-wcwidth python-attrs python-more-itertools \
		python-pluggy python-importlib-metadata python-setuptools-scm python-attrs; \
		echo "Download BCNC-git PKGBUILD from AUR and change the python2 to python and python2.7 to python3.10"

_install_xfce:
	@sudo pacman --noconfirm -S xfce4-panel xfce4-power-manager \
		xfce4-whiskermenu-plugin dmenu xfce4-session xfce4-settings light-locker \
		thunar nitrogen yad xfdesktop xfwm4 thunar-volman xfce4-sensors-plugin; \
		yay --noconfirm -S i3-gaps xfce4-i3-workspaces-plugin-git i3ipc-python-git \
		protonmail-bridge --nocleanmenu --nodiffmenu; \

_load_xfce_settings:
		@[ -d $$HOME/.config/xfce4 ] && rm -r $$HOME/.config/xfce4; \
		xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -n -t string -s i3; \
		xfconf-query -c xfce4-session -p /sessions/Failsafe/Client1_Command -n -t string -s xfsettingsd; \
		xfconf-query -c xfce4-session -p /sessions/Failsafe/Client4_Command -n -t bool -s false

_create_xfce_i3_symlinks:
	@ln -vnsf $(SCRIPT_PATH)/xfce4 $$HOME/.config; \
		ln -vnsf $(SCRIPT_PATH)/i3 $$HOME/.config; \
		ln -vnsf $(SCRIPT_PATH)/autostart $$HOME/.config

install_zsh: _install_fonts
	@sudo pacman --noconfirm -S zsh; \
		yay --noconfirm -S oh-my-zsh-git autojump-git --nocleanmenu --nodiffmenu; \
		sudo ln -vnsf $(SCRIPT_PATH)/modules/Powerlevel10k /usr/share/zsh-theme-powerlevel10k; \
		printf "make the zsh default shell\n"; \
		sudo chsh -s $$(which zsh); \
		ln -vnsf $(SCRIPT_PATH)/zsh/zshrc $$HOME/.zshrc; \
		[ ! -d $$HOME/.oh-my-zsh/custom/plugins ] \
		&& mkdir -p $$HOME/.oh-my-zsh/custom/plugins; \
		ln -vnsf $(SCRIPT_PATH)/modules/zsh-dircolors-solarized $$HOME/.oh-my-zsh/custom/plugins; \
		ln -vnsf $(SCRIPT_PATH)/modules/zsh-256color $$HOME/.oh-my-zsh/custom/plugins; \
		[ ! -f $$HOME/.personal_cfg.zsh ] && touch $$HOME/.personal_cfg.zsh 

_install_fonts:
	@mkdir $(SCRIPT_PATH)/fonts; \
		sudo ln -vnsf $(SCRIPT_PATH)/fonts /usr/local/share; \
		wget -N -P $(SCRIPT_PATH)/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf; \
		wget -N -P $(SCRIPT_PATH)/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf; \
		wget -N -P $(SCRIPT_PATH)/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf; \
		wget -N -P $(SCRIPT_PATH)/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

install_neovim:
	sudo pacman --noconfirm -S neovim; \
		yay --noconfirm -S ranger python-pynvim ueberzug --nocleanmenu --nodiffmenu; \
		[ -d $$HOME/.config/nvim ] && rm -r $$HOME/.config/nvim; \
		[ ! -d $(SCRIPT_PATH)/nvim/autoload ] \
		&& mkdir $(SCRIPT_PATH)/nvim/autoload \
		&& git clone --depth 1 https://github.com/junegunn/vim-plug.git $(SCRIPT_PATH)/nvim/autoload; \
		ln -vnsf $(SCRIPT_PATH)/nvim $$HOME/.config

install_doom_emacs:
	git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d; \
		~/.emacs.d/bin/doom install \
	echo "TODO add instaling of pabbrev";

install_packages_for_work:
	@yay --noconfirm -S mattermost-desktop --nocleanmenu --nodiffmenu; \
		yay --noconfirm -S zoom --nocleanmenu --nodiffmenu; \
		sudo pacman --noconfirm -S tigervnc remmina libvncserver

install_task_warrior:
	@yay --noconfirm -S task-git taskd-git timew-git --nocleanmenu --nodiffmenu; \
		cp /usr/share/doc/timew/on-modify.timewarrior ~/.task/hooks; cd ~/.task/hooks; \
		chmod +x on-modify.timewarrior; \
		echo "for server condiguration taskd follow the instructions on archwiki" \
		echo "Do not forget that the TASKDDATA variable has to be in root directory" \
		echo "than generate certificates for client and copy them in to ~/.task" \
		echo "dont forget to replace the username and group with your chosen names"

_create_symlinks: 
	@[ -d $(XORG_PATH)/$(XORG_CONFD_DIR) ] \
		&& sudo ln -vnsf $(SCRIPT_PATH)/$(XORG_CONFD_DIR)/* \
		$(XORG_PATH)/$(XORG_CONFD_DIR);
