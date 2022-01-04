#makefile for dodotronix's enviroment setup

SCRIPT_PATH:=$(shell pwd)
XORG_PATH:=/etc/X11
XORG_CONFD_DIR:=xorg.conf.d

all:
	@printf 'USAGE : make te6st | run\n'
	@printf '        make test - test recipe for makefile development\n'
	@printf '        make run  - checks the sofware and install the complete env\n' 

run:_check_software _install_packages

test:_create_symlinks
	@printf 'dodo''s enviroment\n'
	@printf '$(SCRIPT_PATH)\n'

_check_software:
	@type sudo >/dev/null 2>@1 || { \
		printf 'ERR: "sudo" is probably not installed"\n' >&2; \
		false; }

_install_packages:
	@sudo pacman -Syu noconfirm \
	pacman -S gajim emacs \
	xorg-server xorg-xinput xorg-xmodmap xorg-xev xorg-setxkbmap \
	xf86-input-synaptics xf86-input-libinput

_create_symlinks:
	@[ -d $(XORG_PATH)/$(XORG_CONFD_DIR) ] \
		&& sudo ln -vnsf $(SCRIPT_PATH)/$(XORG_CONFD_DIR)/* \
		$(XORG_PATH)/$(XORG_CONFD_DIR);
