#Makefile for dodotronix's enviroment setup

SCRIPT_PATH:=$(shell pwd)
XORG_PATH:=/etc/X11
XORG_CONFD_DIR:=xorg.conf.d

all:
	@printf 'USAGE : make init            | install_all_packages | configure_all\n'
	@printf '             tmux_config     | zsh_config           | install_kicad\n'
	@printf '             neovim_config   |  xfce_config\n'

init:
	@git submodule update --init --recursive
	@cd $$HOME/projects && [ -d "neorg_record" ] || \
		git clone git@github.com:dodotronix/neorg_record.git;

install_all_packages: _check_software
	@sudo pacman -Syu --noconfirm; \
		sudo pacman --noconfirm -S  wget gajim \
		archlinux-keyring bitwarden python alsa-utils \
		xorg-server xorg-xinput xorg-xmodmap xorg-xev xorg-setxkbmap \
		xf86-input-synaptics xf86-input-libinput evolution-ews \
		gnome-keyring bluez bluez-utils \
		pulseaudio pulseaudio-bluetooth blueberry lazygit timew \
		cups network-manager-applet pulseaudio-alsa ntfs-3g flatpak \
		mtpfs gvfs-gphoto2 gvfs-mtp man-db xfce4-mailwatch-plugin \
		firewalld ipset lightdm lightdm-gtk-greeter firefox rofi llvm clang \
		pavucontrol alacritty usbutils xfce4-panel xfce4-power-manager \
		xfce4-whiskermenu-plugin dmenu xfce4-session ttf-font-awesome \
		xfce4-settings light-locker thunar nitrogen xfdesktop xfwm4 flatpak \
		thunar-volman xfce4-sensors-plugin neovim xclip zsh fzf ntp;
	@sudo systemctl enable bluetooth.service; pulseaudio -k; pulseaudio --start;
	@printf "[INF]: Installing yay for simple AUR downloads\n"
	@which yay &> /dev/null || { cd /tmp; \
		git clone https://aur.archlinux.org/yay.git; \
		cd yay; makepkg -si --noconfirm; cd $(SCRIPT_PATH); }
	@printf "[INF]: Creating symlinks\n"
	@[ -d $(XORG_PATH)/$(XORG_CONFD_DIR) ] \
		&& sudo ln -vnsf $(SCRIPT_PATH)/$(XORG_CONFD_DIR)/* \
		$(XORG_PATH)/$(XORG_CONFD_DIR);
	@printf "[INF]: Installing packages from AUR\n"
# xfce4-i3-workspaces-plugin-git will be loaded from home 
	@yay --noconfirm -S discord spotify i3-gaps \
		python-i3ipc xfce4-panel-profiles protonmail-bridge-bin \
		xfce4-genmon-plugin pyright antigen-git \
		lua-language-server-git svls python-pynvim ueberzug \
		oh-my-zsh-git autojump nnn-icons pomodorino verible-bin \
		xfce4-i3-workspaces-plugin-git yad-git tmux-git todoist-appimage \
		--nocleanmenu --nodiffmenu;	
	@printf "[INF]: git activated verbose mode.\n" \
		&& git config --global commit.verbose true

configure_all: _install_fonts tmux_config xfce_config \
	zsh_config neovim_config
	@sudo systemctl enable ntpd.service && sudo systemctl start ntpd.service;
	
_check_software:
	@which sudo &> /dev/null || { \
		printf 'ERR: "sudo" is probably not installed"\n' >&2; false; }
	@which lsb_release &> /dev/null || { \
		printf 'ERR: "lsb-release" is probably not installed"\n' >&2; false; }

tmux_config:
	@ln -vnsf $(SCRIPT_PATH)/tmux/ $$HOME/.config/tmux; \
		[ ! -d $$HOME/.local/bin ] && mkdir $$HOME/.local/bin; \
		ln -vnsf $(SCRIPT_PATH)/scripts/* $$HOME/.local/bin/

# TODO remove all xfce cached dirs
# you can find all the active defaults in
# /usr/share/applications/mimeinfo.cache 
xfce_config:
	@[ ! -d $$HOME/.config/autostart ] && mkdir -p $$HOME/.config/autostart; \
		cp $(SCRIPT_PATH)/autostart/* $$HOME/.config/autostart
	@ln -vnsf $(SCRIPT_PATH)/i3 $$HOME/.config; \
		ln -vnsf $(SCRIPT_PATH)/xdg/mimeapps.list $$HOME/.config; \
		source $(SCRIPT_PATH)/scripts/xfce_configurer.sh \
		rm -rf $$HOME/.cache/*
	@ln -vnsf $(SCRIPT_PATH)/Xresources $$HOME/.Xresources;
	@[ -d $$HOME/.config/rofi ] && rm -r $$HOME/.config/rofi; \
		ln -vnsf $(SCRIPT_PATH)/rofi $$HOME/.config;

evolution_config:
	@[ ! -d $$HOME/.config/evolution ] && mkdir -p $$HOME/.config/evolution; \
		ln -vnsf $(SCRIPT_PATH)/evolution/* $$HOME/.config/evolution; \
		ln -vnsf $(SCRIPT_PATH)/desktop/* $$HOME/.local/share/applications;

zsh_config: 
	@printf "make the zsh default shell\n"; \
		sudo chsh -s $$(which zsh); \
		ln -vnsf $(SCRIPT_PATH)/zsh/zshrc $$HOME/.zshrc; \
		[ ! -f $$HOME/.personal_cfg.zsh ] && { touch $$HOME/.personal_cfg.zsh; } || { true; } 

_install_fonts:
	@mkdir $(SCRIPT_PATH)/fonts; \
		sudo ln -vnsf $(SCRIPT_PATH)/fonts /usr/local/share; \
		wget -N -P $(SCRIPT_PATH)/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf; \
		wget -N -P $(SCRIPT_PATH)/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf; \
		wget -N -P $(SCRIPT_PATH)/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf; \
		wget -N -P $(SCRIPT_PATH)/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

neovim_config:
	@ln -vnsf $(SCRIPT_PATH)/nvim $$HOME/.config
	@[ -d ${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins ] && \
		{ rm -rf ${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins; } || { true; }; \
		curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh;

install_kicad:
	@yay --noconfirm -S kicad-git kicad-libraries-git --nocleanmenu --nodiffmenu;

# install_flatcam:
# 	@yay --noconfirm -S flatcam-git --nocleanmenu --nodiffmenu; \
# 		echo "replace import collections with import collections.abc as collections in
# 	all files which will raise an exception"; \
# 		sudo pip uninistall vispy && sudo pip install vispy==0.7

# install_bcnc:
# 	@sudo pacman --noconfirm -S python-wcwidth python-attrs python-more-itertools \
# 		python-pluggy python-importlib-metadata python-setuptools-scm python-attrs; \
# 		echo "Download BCNC-git PKGBUILD from AUR and change the python2 to python and python2.7 to python3.10"

# install_work_specific:
# 	@yay --noconfirm -S mattermost-desktop --nocleanmenu --nodiffmenu; \
# 		yay --noconfirm -S zoom --nocleanmenu --nodiffmenu; \
# 		sudo pacman --noconfirm -S tigervnc remmina libvncserver
