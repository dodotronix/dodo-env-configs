#makefile for dodotronix's enviroment setup

SCRIPT_PATH:=$(shell pwd)
XORG_PATH:=/etc/X11
XORG_CONFD_DIR:=xorg.conf.d

all:
	@printf 'USAGE : make te6st | run\n'
	@printf '        make test - test recipe for makefile development\n'
	@printf '        make run  - checks the sofware and install the complete env\n' 

run:_check_software _install_packages

test:_install_zsh
	@printf 'dodo''s enviroment\n'
	@printf '$(SCRIPT_PATH)\n'

_check_software:
	@type sudo >/dev/null 2>@1 || { \
		printf 'ERR: "sudo" is probably not installed"\n' >&2; \
		false; }

_install_packages:
	@sudo pacman -Syu noconfirm \
	pacman -S wget gajim emacs \
	archlinux-keyring bitwarden \
	xorg-server xorg-xinput xorg-xmodmap xorg-xev xorg-setxkbmap \
	xf86-input-synaptics xf86-input-libinput \
	evolution gnome-keyring \
	cups network-manager-applet \
	pavucontrol alacritty

_install_yay:
	cd /tmp; \
	git clone https://aur.archlinux.org/yay.git \
	cd yay; makepkg -si --noconfirm; cd $(SCRIPT_PATH)

_install_yay_packages:
	yay --noconfirm -S flatcam-git --nocleanmenu --nodiffmenu

_install_and_configure_xfce:
	@sudo pacman -S xfce4-panel xfce4-power-manager \
		xfce4-session xfce4-settings thunar \
		xfdesktop xfwm4 thunar-volman; \

_install_i3_into_xfce:
	@echo "install xfce4"

_install_zsh:
	@sudo pacman -S zsh

_install_fonts:
	echo "install fonts"

_install_vim:
	echo "install vim"

_install_doom_emacs:
	echo "install doom emacs"

_create_symlinks:
	@[ -d $(XORG_PATH)/$(XORG_CONFD_DIR) ] \
		&& sudo ln -vnsf $(SCRIPT_PATH)/$(XORG_CONFD_DIR)/* \
		$(XORG_PATH)/$(XORG_CONFD_DIR);
