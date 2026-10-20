# Makefile for dodotronix's environment setup

SHELL := /bin/bash

SCRIPT_PATH    := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
XORG_PATH      := /etc/X11
XORG_CONFD_DIR := xorg.conf.d
PKG_DIR        := $(SCRIPT_PATH)/packages

# Read package names from list files (strips comments, whitespace, empty lines).
# A literal '#' inside $(shell ...) breaks GNU make < 4.3, hence $(HASH).
HASH := \#
# If no files are given, sed would wait on stdin forever -> guard + </dev/null.
read_list = $(if $(strip $(1)),$(shell sed -e 's/$(HASH).*//' -e 's/[[:space:]]//g' -e '/^$$/d' $(1) </dev/null 2>/dev/null))

BASE_PKGS   := $(call read_list,$(PKG_DIR)/base.txt)
PACMAN_PKGS := $(call read_list,$(PKG_DIR)/pacman.txt)
AUR_PKGS    := $(call read_list,$(PKG_DIR)/aur.txt)
# Local PKGBUILDs: name = directory in packages/
LOCAL_PKGS  := $(call read_list,$(PKG_DIR)/local.txt)
KICAD_PKGS  := $(call read_list,$(PKG_DIR)/kicad.txt)
VNC_PKGS    := $(call read_list,$(PKG_DIR)/vnc.txt)
# Core set = what install_all_packages installs
CORE_PKGS   := $(sort $(BASE_PKGS) $(PACMAN_PKGS) $(AUR_PKGS) $(LOCAL_PKGS))
# Keep set = everything in ANY packages/*.txt is protected from pruning
KEEP_PKGS   := $(sort $(call read_list,$(wildcard $(PKG_DIR)/*.txt)))

# NOCONFIRM=1 make sync_packages  -> remove without asking
PACMAN_CONFIRM := $(if $(filter 1,$(NOCONFIRM)),--noconfirm,)

.PHONY: all help init install_all_packages sync_packages prune_packages pkg_diff \
	configure_all install_fonts tmux_config zsh_config neovim_config \
	xfce_config update_applications evolution_config install_kicad \
	configure_kicad alacritty_config vnc_config docker_prepare_claude \
	clean_caches i3_workspaces _i3_workspaces_css _check_software _check_lists _install_yay _mark_explicit

# Full setup, run in order: clone repos -> sync packages -> configure
all:
	@$(MAKE) --no-print-directory init
	@$(MAKE) --no-print-directory sync_packages
	@$(MAKE) --no-print-directory configure_all
	@printf '[INF]: Setup done.\n'

help:
	@printf 'USAGE : make [all]           -> init + sync_packages + configure_all\n'
	@printf '                                (everything except kicad, see install_kicad)\n'
	@printf '        make init            | install_all_packages | configure_all\n'
	@printf '             sync_packages   | prune_packages       | pkg_diff\n'
	@printf '             tmux_config     | zsh_config           | install_kicad\n'
	@printf '             neovim_config   | xfce_config          | docker_prepare_claude\n'
	@printf '             clean_caches    | i3_workspaces        | vnc_config\n'
	@printf '             help\n'
	@printf '\n        NOCONFIRM=1 make     (prune without asking)\n'

init:
	@git submodule update --init --recursive
	@# needs an SSH key on GitHub; don't block the whole setup without one
	@[ -d $$HOME/projects/records ] || \
		git clone git@github.com:dodotronix/records.git $$HOME/projects/records || \
		printf '[WRN]: could not clone records (SSH key?), skipping\n' >&2

# ---------------------------------------------------------------------------
# Packages
# ---------------------------------------------------------------------------

# Install the core set + post-install setup (never removes anything)
install_all_packages: _check_software _check_lists
	@sudo pacman -Syu --needed --noconfirm $(BASE_PKGS) $(PACMAN_PKGS)
	@# after -Syu: a pacman/libalpm upgrade can break the old yay binary
	@$(MAKE) --no-print-directory _install_yay
	@printf "[INF]: Installing packages from AUR\n"
	@# one at a time, so a single broken AUR build doesn't block the rest
	@failed=; for p in $(AUR_PKGS); do \
		yay -S --needed --noconfirm "$$p" || failed="$$failed $$p"; \
	done; \
	if [ -n "$$failed" ]; then \
		printf '[WRN]: AUR packages that failed to build:%s\n' "$$failed" >&2; \
		printf '[WRN]: fix or replace them in packages/aur.txt\n' >&2; \
	fi
	@pacman -Q $(I3WS_PKG) &> /dev/null || $(MAKE) --no-print-directory i3_workspaces
	@sudo systemctl enable bluetooth.service docker.service
	@systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true
	@printf "[INF]: Creating symlinks\n"
	@if [ -d $(XORG_PATH)/$(XORG_CONFD_DIR) ]; then \
		sudo ln -vnsf $(SCRIPT_PATH)/$(XORG_CONFD_DIR)/* $(XORG_PATH)/$(XORG_CONFD_DIR); \
	fi
	@git config --global commit.verbose true && printf "[INF]: git activated verbose mode.\n"

# Make the system match the lists: install what's missing, remove everything else
sync_packages: install_all_packages
	@$(MAKE) --no-print-directory prune_packages

# Dry run: show the difference between the system and the lists
pkg_diff: _check_lists
	@printf '[INF]: Installed but not listed (would be removed):\n'
	@comm -23 <(pacman -Qqe | sort) <(printf '%s\n' $(KEEP_PKGS) | sort -u) | sed 's/^/  - /'
	@printf '[INF]: Listed in core set but not installed:\n'
	@comm -13 <(pacman -Qq | sort) <(printf '%s\n' $(CORE_PKGS) | sort -u) | sed 's/^/  + /'

# Remove explicitly installed packages that are not in any list,
# plus all dependencies nothing needs anymore.
prune_packages: _check_lists _mark_explicit
	@extra=$$(comm -23 <(pacman -Qqe | sort) <(printf '%s\n' $(KEEP_PKGS) | sort -u)); \
	if [ -n "$$extra" ]; then \
		printf '[INF]: Not in package lists:\n'; printf '  - %s\n' $$extra; \
		sudo pacman -D --asdeps $$extra >/dev/null; \
	fi; \
	orphans=$$(pacman -Qqdt); \
	if [ -z "$$orphans" ]; then printf '[INF]: Nothing to remove\n'; exit 0; fi; \
	sudo pacman -Rns $(PACMAN_CONFIRM) $$orphans || { \
		printf '[INF]: Aborted, restoring install reasons\n'; \
		[ -z "$$extra" ] || sudo pacman -D --asexplicit $$extra >/dev/null; }

# Listed packages that got installed as a dependency must be marked explicit,
# otherwise they'd be removed as orphans once nothing depends on them.
_mark_explicit:
	@listed=$$(comm -12 <(pacman -Qq | sort) <(printf '%s\n' $(KEEP_PKGS) | sort -u)); \
	[ -z "$$listed" ] || sudo pacman -D --asexplicit $$listed >/dev/null

# Safety net: never prune against empty/missing lists (that would remove everything)
_check_lists:
	@[ -n "$(strip $(BASE_PKGS))" ] && [ -n "$(strip $(PACMAN_PKGS))" ] || { \
		printf 'ERR: package lists in $(PKG_DIR) are missing or empty\n' >&2; false; }

_check_software:
	@command -v sudo &> /dev/null || { \
		printf 'ERR: "sudo" is probably not installed\n' >&2; false; }

# (Re)build yay if it's missing OR broken (e.g. "libalpm.so.XX: cannot open
# shared object file" after pacman was upgraded). Built from source, so it
# links against the libalpm that is installed right now.
_install_yay:
	@yay --version &> /dev/null || { \
		printf "[INF]: yay missing or broken, (re)building it from AUR\n"; \
		sudo pacman -S --needed --noconfirm base-devel git && \
		rm -rf /tmp/yay && git clone https://aur.archlinux.org/yay.git /tmp/yay && \
		cd /tmp/yay && makepkg -si --noconfirm --rmdeps && \
		yay --version; }

# Patched i3 workspace switcher for the xfce panel. Edit the patches / CSS in
# packages/xfce4-i3-workspaces-plugin-dodo-git/ and rerun this to rebuild,
# reinstall, relink the CSS and restart the panel. The PKGBUILD dir is copied
# to a temp dir so makepkg doesn't write into the repo. No --noconfirm: pacman
# has to ask before replacing the unpatched AUR package.
I3WS_PKG := xfce4-i3-workspaces-plugin-dodo-git
I3WS_DIR := $(PKG_DIR)/$(I3WS_PKG)

i3_workspaces:
	@tmp=$$(mktemp -d); trap 'rm -rf "$$tmp"' EXIT; \
		cp $(I3WS_DIR)/PKGBUILD $(I3WS_DIR)/*.patch "$$tmp"; \
		cd "$$tmp" && makepkg -si --cleanbuild
	@$(MAKE) --no-print-directory _i3_workspaces_css
	@pgrep -x xfce4-panel > /dev/null && xfce4-panel --restart || true

_i3_workspaces_css:
	@mkdir -p $$HOME/.config/xfce4/panel; \
		ln -vnsf $(I3WS_DIR)/i3-workspaces.css $$HOME/.config/xfce4/panel/i3-workspaces.css

# Free space: old package versions, packages/AUR builds of uninstalled
# packages, and folders that uninstalled apps left in $HOME (asks first)
clean_caches:
	@printf '[INF]: Pacman cache: keeping the last 2 versions of installed packages\n'
	@sudo paccache -rk2
	@printf '[INF]: Pacman + AUR caches of uninstalled packages\n'
	@yay -Sc
	@$(SCRIPT_PATH)/scripts/clean_home

install_kicad:
	@yay -S --needed --noconfirm $(KICAD_PKGS)

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

# Everything every machine needs (kicad etc. are separate targets on purpose)
configure_all: install_fonts tmux_config zsh_config neovim_config alacritty_config \
	xfce_config update_applications evolution_config docker_prepare_claude
	@sudo systemctl enable --now ntpd.service
	@# enable only: starting it here would throw you to the greeter mid-setup
	@sudo systemctl enable lightdm.service
	@printf '[INF]: Reboot (or log out) to start the i3 + xfce session.\n'

tmux_config:
	@ln -vnsf $(SCRIPT_PATH)/tmux/ $$HOME/.config/tmux;
	@mkdir -p $$HOME/.local/bin; \
		ln -vnsf $(SCRIPT_PATH)/scripts/* $$HOME/.local/bin/


# you can find all the active defaults in
# /usr/share/applications/mimeinfo.cache
xfce_config:
	@mkdir -p $$HOME/.config/autostart; \
		cp $(SCRIPT_PATH)/autostart/* $$HOME/.config/autostart
	@ln -vnsf $(SCRIPT_PATH)/i3 $$HOME/.config; \
		ln -vnsf $(SCRIPT_PATH)/xdg/mimeapps.list $$HOME/.config
	@# xfconf-query needs a session bus; outside a desktop session (fresh install,
	@# tty) start a temporary one so the settings still get written
	@if [ -n "$$DBUS_SESSION_BUS_ADDRESS" ]; then \
		sh $(SCRIPT_PATH)/scripts/xfce_configurer.sh; \
	else \
		dbus-run-session -- sh $(SCRIPT_PATH)/scripts/xfce_configurer.sh; \
	fi
	@$(MAKE) --no-print-directory _i3_workspaces_css
	@# only xfce caches: a saved session/menu cache would override the new settings
	@rm -rf $$HOME/.cache/sessions $$HOME/.cache/xfce4
	@ln -vnsf $(SCRIPT_PATH)/Xresources $$HOME/.Xresources;
	@rm -rf $$HOME/.config/rofi; \
		ln -vnsf $(SCRIPT_PATH)/rofi $$HOME/.config;

update_applications:
	@mkdir -p $$HOME/.local/share/applications; \
		ln -vnsf $(SCRIPT_PATH)/desktop/* $$HOME/.local/share/applications;

evolution_config:
	@echo "DISABLING WEBKIT SANDBOX IN EVOLUTION"
	@sudo sed -i '/^Exec=evolution/ s/^\(Exec=\)/\1env WEBKIT_DISABLE_SANDBOX_THIS_IS_DANGEROUS=1 /' \
		/usr/share/applications/org.gnome.Evolution.desktop
	@mkdir -p $$HOME/.config/evolution; \
		ln -vnsf $(SCRIPT_PATH)/evolution/* $$HOME/.config/evolution;

# chsh -s $$(which zsh);
# sudo sed -i 's#/bin/sh#/bin/bash#g' /etc/passwd

zsh_config:
	@ln -vnsf $(SCRIPT_PATH)/zsh/zshrc $$HOME/.zshrc; \
		touch $$HOME/.personal_cfg.zsh
	@zsh_bin=$$(command -v zsh); \
	if [ -n "$$zsh_bin" ] && [ "$$(getent passwd $$USER | cut -d: -f7)" != "$$zsh_bin" ]; then \
		printf "[INF]: making zsh the default shell\n"; sudo chsh -s "$$zsh_bin" $$USER; \
	fi

FONT_URL := https://github.com/romkatv/powerlevel10k-media/raw/master
FONTS    := Regular Bold Italic Bold%20Italic

# Download each font only if missing, into a temp file first: an interrupted
# download must never replace a working font (alacritty falls back otherwise)
install_fonts:
	@mkdir -p $(SCRIPT_PATH)/fonts
	@sudo ln -vnsf $(SCRIPT_PATH)/fonts /usr/local/share
	@for f in $(FONTS); do \
		dest="$(SCRIPT_PATH)/fonts/MesloLGS NF $${f//%20/ }.ttf"; \
		[ -s "$$dest" ] && continue; \
		printf '[INF]: Downloading %s\n' "$${dest##*/}"; \
		wget -q -O "$$dest.part" "$(FONT_URL)/MesloLGS%20NF%20$$f.ttf" && \
			mv "$$dest.part" "$$dest" || { rm -f "$$dest.part"; \
			printf '[WRN]: download failed, keeping what was there\n' >&2; }; \
	done
	@fc-cache -f

neovim_config:
	@ln -vnsf $(SCRIPT_PATH)/nvim $$HOME/.config

configure_kicad:
	@[ -d $$HOME/projects/dodo_klibs ] || \
		git clone git@github.com:dodotronix/dodo_klibs.git $$HOME/projects/dodo_klibs
	@rm -rf $$HOME/.local/share/kicad/10.99/{symbols,footprints,3dmodels}
	@mkdir -p $$HOME/.local/share/kicad/10.99
	@ln -vnsf $$HOME/projects/dodo_klibs/symbols $$HOME/.local/share/kicad/10.99/
	@ln -vnsf $$HOME/projects/dodo_klibs/footprints $$HOME/.local/share/kicad/10.99/
	@ln -vnsf $$HOME/projects/dodo_klibs/3dmodels $$HOME/.local/share/kicad/10.99/

alacritty_config:
	@ln -vnsf $(SCRIPT_PATH)/alacritty $$HOME/.config

# VNC server with its own xfce session on display :$(VNC_DISPLAY) (port 590X).
# The session runs through dbus-run-session, otherwise xfce quits right away
# when the same user is logged in locally (shared session bus).
# Connect with: vncviewer <host>:$(VNC_DISPLAY)
VNC_DISPLAY := 1

vnc_config:
	@sudo pacman -S --needed --noconfirm $(VNC_PKGS)
	@# copied, not linked: the greeter can't read through a private $HOME
	@sudo install -vDm644 $(SCRIPT_PATH)/vnc/xfce-vnc.desktop /usr/share/xsessions/xfce-vnc.desktop
	@grep -q '^:$(VNC_DISPLAY)=' /etc/tigervnc/vncserver.users || \
		echo ":$(VNC_DISPLAY)=$$USER" | sudo tee -a /etc/tigervnc/vncserver.users > /dev/null
	@mkdir -p $$HOME/.config/tigervnc; \
		ln -vnsf $(SCRIPT_PATH)/vnc/config $$HOME/.config/tigervnc/config
	@# older tigervnc versions still read ~/.vnc
	@[ ! -d $$HOME/.vnc ] || ln -vnsf $(SCRIPT_PATH)/vnc/config $$HOME/.vnc/config
	@[ -s $$HOME/.config/tigervnc/passwd ] || [ -s $$HOME/.vnc/passwd ] || vncpasswd
	@sudo systemctl enable vncserver@:$(VNC_DISPLAY).service
	@sudo systemctl restart vncserver@:$(VNC_DISPLAY).service

# ---------------------------------------------------------------------------
# Claude Code in docker
# ---------------------------------------------------------------------------

CLAUDE_IMAGE := claude-code-ubuntu-24.04

# Install docker and build the image from claude/Dockerfile
docker_prepare_claude:
	@sudo pacman -S --needed --noconfirm docker docker-buildx
	@systemctl is-active --quiet docker.service || sudo systemctl enable --now docker.service
	@# not in the docker group (fresh install) -> build through sudo
	@d=docker; docker info &> /dev/null || d="sudo docker"; \
		$$d build --pull -t $(CLAUDE_IMAGE) $(SCRIPT_PATH)/claude

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
# 	-> put mattermost-desktop, zoom into packages/work.txt (AUR)
# 	   and remmina libvncserver too, so pruning keeps them
