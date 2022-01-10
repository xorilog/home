# Makefile for home
# Variables

ETCNIXOS = /etc/nixos
SYNCDIR = /home/xophe/sync/nixos
SRCHOME = ~/src/github.com/xorilog/home

# Targets
.PHONY: all
all: switch

.PHONY: update
update:
	nix-channel --update

.PHONY: secrets
secrets:
	mkdir -p secrets
	-cp -Rv $(SYNCDIR)/* secrets/

.PHONY: assets
assets:
	mkdir -p assets
	cp -Rv $(SYNCDIR)/* assets/
	chown -R xophe:users assets || true

.PHONY: home-build
home-build: secrets
	home-manager -f home.nix build

.PHONY: home-switch
home-switch: secrets
	home-manager -f home.nix switch

.PHONY: build
build: secrets
	./bin/system build

.PHONY: nixos-dry-build
dry-build: secrets setup
	./bin/system dry-build

.PHONY: switch
switch: secrets
	./bin/system switch

.PHONY: boot
boot: secrets
	./bin/system boot

.PHONY: install-hooks
install-hooks:
	if [ -e .git ]; then nix-shell -p git --run 'git config core.hooksPath .githooks'; fi

.PHONY: pre-commit
pre-commit: README.md fmt

.PHONY: fmt
fmt:
	-nixpkgs-fmt *.nix nix systems tools users
#-nixpkgs-fmt *.nix nix lib overlays pkgs systems tools users

# Cleaning
.PHONY: clean
clean: clean-system clean-results

.PHONY: clean-system
clean-system:
	nix-env --profile /nix/var/nix/profiles/system --delete-generations 15d

.PHONY: clean-results
clean-results:
	unlink results

# Setup and doctor
.PHONY: doctor
doctor:
	@echo "Validate the environment"
	@readlink $(DOTNIXPKGS) || $(error $(DOTNIXPKGS) is not correctly linked, you may need to run setup)

.PHONY: setup
setup: $(SYNCDIR) $(SRCHOME)

$(SRCHOME):
	@echo "Make sure $(SRCHOME) exists"
	@-ln -s ${PWD} $(SRCHOME)

$(SYNCDIR):
	$(error $(SYNCDIR) is not present, you need to configure syncthing before running this command)

setup-gpg:
	gpg --import module/gnupg/gpg-0xB151572DE8FADB71-2021-12-14.asc
	gpg --card-status
	@echo -e "\nNow trust the imported key using:\ngpg -K\ngpg --edit-key 0xB151572DE8FADB71\ngpg> trust\ngpg> quit\nCheck ssb card status\ngpg --card-status"


setup-lockscreen:
	betterlockscreen -u $(HOME)/desktop/pictures/walls --blur 1
