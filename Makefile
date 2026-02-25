DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
XDG_PACKAGES := ghostty git lazygit nvim prettier tmux yazi zellij

OS := $(shell bin/is-supported bin/is-macos macos linux)
HOMEBREW_PREFIX := $(shell bin/is-supported bin/is-macos $(shell bin/is-supported bin/is-arm64 /opt/homebrew /usr/local) /home/linuxbrew/.linuxbrew)
export N_PREFIX = $(HOME)/.n

PATH := $(HOMEBREW_PREFIX)/bin:$(DOTFILES_DIR)/bin:$(N_PREFIX)/bin:$(PATH)
SHELL := env PATH=$(PATH) /bin/bash
SHELLS := /private/etc/shells
BIN := $(HOMEBREW_PREFIX)/bin
export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

.PHONY: test

all: $(OS)


LINUX_CORE := core-linux

ifdef GITHUB_ACTIONS
LINUX_CORE := core-linux-ci
endif

linux: $(LINUX_CORE) link bun

core-linux:
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -f

core-linux-ci:
	apt-get update
	apt-get install -y --no-install-recommends \
		bash \
		ca-certificates \
		curl \
		git \
		make \
		stow \
		bats \
		jq \
		awk \
		sed \
		grep \
		coreutils \
		findutils

stow-linux: core-linux
	is-executable stow || apt-get -y install stow


macos: sudo core-macos packages link duti bun

core-macos: brew bash git npm

macos-ci: macos-test-deps stow-macos link

stow-macos: brew
	is-executable stow || brew install stow


sudo:
ifndef GITHUB_ACTIONS
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

packages: brew-packages cask-apps mas-apps node-packages rust-packages

link-julia:
	mkdir -p $(HOME)/.julia/config
	cp $(DOTFILES_DIR)/config/julia/startup.jl \
	   $(HOME)/.julia/config/startup.jl
	mkdir -p $(HOME)/.julia/environments/dsbc
	cp $(DOTFILES_DIR)/config/julia/environments/dsbc/Project.toml \
	   $(HOME)/.julia/environments/dsbc/Project.toml

unlink-julia:
	rm -f $(HOME)/.julia/config/startup.jl
	rm -f $(HOME)/.julia/environments/dsbc/Project.toml

link: stow-$(OS) link-julia
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	stow -d "$(DOTFILES_DIR)" -t "$(HOME)" runcom
	for PKG in $(XDG_PACKAGES); do \
		stow -d "$(DOTFILES_DIR)/config" -t "$(HOME)" "$$PKG"; \
	done
	mkdir -p $(HOME)/.local/runtime
	chmod 700 $(HOME)/.local/runtime

unlink: stow-$(OS) unlink-julia
	stow -d "$(DOTFILES_DIR)" --delete -t "$(HOME)" runcom
	for PKG in $(XDG_PACKAGES); do \
		stow -d "$(DOTFILES_DIR)/config" --delete -t "$(HOME)" "$$PKG"; \
	done
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

bash: brew
ifdef GITHUB_ACTIONS
	if ! grep -q bash $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		echo $(shell which bash) | sudo tee -a $(SHELLS) && \
		sudo chsh -s $(shell which bash); \
	fi
else
	if ! grep -q bash $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		echo $(shell which bash) | sudo tee -a $(SHELLS) && \
		chsh -s $(shell which bash); \
	fi
endif

git: brew
	brew install git git-extras

npm: brew-packages
	n install lts

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile || true

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true

mas-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/MASfile || true

vscode-extensions: cask-apps
	for EXT in $$(cat install/Codefile); do code --install-extension $$EXT; done

node-packages: npm
	$(N_PREFIX)/bin/npm install --force --location global $(shell cat install/npmfile)

rust-packages: brew-packages
	cargo install $(shell cat install/Rustfile)

duti:
	duti -v $(DOTFILES_DIR)/install/duti

bun:
	curl -fsSL https://bun.sh/install | bash

macos-test-deps: brew
	brew install bats-core jq || true

test:
	bats test
