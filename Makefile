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

run:_check_software _install_packages

test:_install_and_configure_xfce
	@printf 'dodo''s enviroment\n'
	@printf '$(SCRIPT_PATH)\n'

_check_software:
	@type sudo >/dev/null 2>@1 || { \
		printf 'ERR: "sudo" is probably not installed"\n' >&2; \
		false; }

_install_packages:
	@sudo pacman -Syu --noconfirm; \
	sudo pacman --noconfirm -S  wget gajim emacs \
	archlinux-keyring bitwarden \
	xorg-server xorg-xinput xorg-xmodmap xorg-xev xorg-setxkbmap \
	xf86-input-synaptics xf86-input-libinput \
	evolution gnome-keyring \
	cups network-manager-applet \
	pavucontrol alacritty ranger

_install_yay:
	cd /tmp; \
	git clone https://aur.archlinux.org/yay.git; \
	cd yay; makepkg -si --noconfirm; cd $(SCRIPT_PATH)

_install_yay_packages:
	yay --noconfirm -S flatcam-git --nocleanmenu --nodiffmenu

_install_and_configure_xfce:
	@sudo pacman --noconfirm -S xfce4-panel xfce4-power-manager xfce4-whiskermenu-plugins \
		xfce4-session xfce4-settings thunar nitrogen \
		xfdesktop xfwm4 thunar-volman; \
		yay --noconfirm -S i3-gaps --nocleanmenu --nodiffmenu; \
		yay --noconfirm -S xfce4-i3-workspaces-plugin-git --nocleanmenu --nodiffmenu; \
		yay --noconfirm -S protonmail-bridge --nocleanmenu --nodiffmenu; \
		[ -d $$HOME/.config/xfce4 ] \
		&& rm -r $$HOME/.config/xfce4; \
		xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -n -t string -s i3; \
		xfconf-query -c xfce4-session -p /sessions/Failsafe/Client1_Command -n -t string -s xfsettingsd; \
		xfconf-query -c xfce4-session -p /sessions/Failsafe/Client4_Command -n -t bool -s false; \
		ln -vnsf $(SCRIPT_PATH)/xfce4 $$HOME/.config; \
		ln -vnsf $(SCRIPT_PATH)/i3 $$HOME/.config; \
		ln -vnsf $(SCRIPT_PATH)/autostart $$HOME/.config

_install_zsh:
	@sudo pacman --noconfirm -S zsh; \
		yay --noconfirm -S oh-my-zsh-git --nocleanmenu --nodiffmenu; \
		yay --noconfirm -S autojump-git --nocleanmenu --nodiffmenu; \
		sudo ln -vnsf $(SCRIPT_PATH)/modules/Powerlevel10k /usr/share/zsh-theme-powerlevel10k; \
		printf "make the zsh default shell\n"; \
		chsh -s $$(which zsh); \
		ln -vnsf $(SCRIPT_PATH)/zsh/zshrc $$HOME/.zshrc; \
		[ ! -d $$HOME/.oh-my-zsh/custom/plugins ] \
		&& mkdir -p $$HOME/.oh-my-zsh/custom/plugins; \
		ln -vnsf $(SCRIPT_PATH)/modules/zsh-dircolors-solarized $$HOME/.oh-my-zsh/custom/plugins; \
		ln -vnsf $(SCRIPT_PATH)/modules/zsh-256color $$HOME/.oh-my-zsh/custom/plugins

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
