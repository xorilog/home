# Makefile for home - Flake Architecture Migration
# Variables
ETCNIXOS = /etc/nixos
SYNCDIR = /home/xophe/sync/nixos
SRCHOME = ~/src/github.com/xorilog/home

# Flake configuration
FLAKE_HOST := nixophe
FLAKE := .#$(FLAKE_HOST)
HOME_FLAKE := .#homeConfigurations."xophe@$(FLAKE_HOST)"

# Build flags
REBUILD_FLAGS := --fast --show-trace
BUILD_FLAGS := --show-trace

# Targets
.PHONY: all help
all: switch

# Aide utilisateur
help:
	@echo "🏠 Makefile NixOS Flakes - Commandes disponibles:"
	@echo ""
	@echo "📦 Build & Deploy:"
	@echo "  build        - Build configuration système (flake)"
	@echo "  switch       - Switch vers nouvelle configuration"
	@echo "  test         - Test configuration temporaire"
	@echo "  boot         - Configure prochaine boot uniquement"
	@echo "  dry-run      - Preview changements sans appliquer"
	@echo ""  
	@echo "🏡 Home Manager:"
	@echo "  home-build   - Build home-manager uniquement"
	@echo "  home-switch  - Switch home-manager"
	@echo "  home         - Build + switch home-manager"
	@echo ""
	@echo "⚡ Mise à jour:"
	@echo "  update       - Update flake inputs"
	@echo "  upgrade      - Update + switch (migration complète)"
	@echo "  update-input - Update input spécifique (INPUT=nom)"
	@echo ""
	@echo "🔧 Maintenance:"
	@echo "  clean        - Clean old generations + optimise store"
	@echo "  secrets      - Sync secrets depuis $(SYNCDIR)"
	@echo "  fmt          - Format code nix"
	@echo "  check        - Vérifier validité flake"
	@echo ""
	@echo "💡 Développement:"
	@echo "  dev          - Shell développement flake"
	@echo "  info         - Informations flake"
	@echo "  history      - Historique configurations"
	@echo "  rollback     - Rollback dernière configuration"

# FLAKE BUILD & DEPLOY (nouvelles commandes)
.PHONY: build
build: secrets
	@echo "🔨 Build configuration système flake..."
	nix build $(BUILD_FLAGS) $(FLAKE).config.system.build.toplevel

.PHONY: switch  
switch: secrets
	@echo "🔄 Switch vers nouvelle configuration..."
	sudo nixos-rebuild switch $(REBUILD_FLAGS) --flake $(FLAKE)

.PHONY: test
test: secrets
	@echo "🧪 Test configuration temporaire..."
	sudo nixos-rebuild test $(REBUILD_FLAGS) --flake $(FLAKE)

.PHONY: boot
boot: secrets  
	@echo "🚀 Configuration pour prochaine boot..."
	sudo nixos-rebuild boot $(REBUILD_FLAGS) --flake $(FLAKE)

.PHONY: dry-run
dry-run: secrets
	@echo "👁️  Preview changements (dry-run)..."
	sudo nixos-rebuild switch $(REBUILD_FLAGS) --flake $(FLAKE) --dry-run

# HOME MANAGER (migration flakes)
.PHONY: home-build
home-build: secrets
	@echo "🏠 Build home-manager..."
	nix build $(BUILD_FLAGS) $(HOME_FLAKE).activationPackage

.PHONY: home-switch
home-switch: secrets
	@echo "🏠 Switch home-manager..."
	$(shell nix build $(BUILD_FLAGS) $(HOME_FLAKE).activationPackage --no-link --print-out-paths)/activate

.PHONY: home
home: home-build home-switch

# UPDATES (flake-native)
.PHONY: update
update:
	@echo "📦 Update flake inputs..."
	nix flake update

.PHONY: update-input
update-input:
	@echo "📦 Update input: $(INPUT)..."
	nix flake update $(INPUT)

.PHONY: upgrade
upgrade: update switch
	@echo "⚡ Migration complète terminée!"

# LEGACY SUPPORT (compatibilité anciens scripts)
.PHONY: pretty-build
pretty-build: build

# MAINTENANCE (flake-compatible)
.PHONY: clean
clean:
	@echo "🧹 Nettoyage système..."
	sudo nix-collect-garbage -d
	nix store optimise
	@echo "✅ Nettoyage terminé"

.PHONY: secrets
secrets:
	@echo "🔐 Synchronisation secrets..."
	mkdir -p secrets
	-cp -Rv $(SYNCDIR)/* secrets/

.PHONY: fmt
fmt:
	@echo "🎨 Formatage code nix..."
	nix fmt

.PHONY: check
check:
	@echo "✅ Vérification flake..."
	nix flake check

# DÉVELOPPEMENT
.PHONY: dev
dev:
	@echo "💻 Shell développement..."
	nix develop

.PHONY: info
info:
	@echo "ℹ️  Informations flake..."
	nix flake show
	nix flake metadata

.PHONY: history
history:
	@echo "📜 Historique configurations..."
	nix profile history --profile /nix/var/nix/profiles/system

.PHONY: diff
diff:
	@echo "🔍 Diff dernière configuration..."
	nix profile diff-closures --profile /nix/var/nix/profiles/system | head -20

.PHONY: rollback
rollback:
	@echo "⏪ Rollback configuration..."
	sudo nixos-rebuild switch --rollback

# LEGACY SUPPORT
.PHONY: install-hooks
install-hooks:
	if [ -e .git ]; then nix-shell -p git --run 'git config core.hooksPath .githooks'; fi

.PHONY: assets
assets:
	mkdir -p assets
	cp -Rv $(SYNCDIR)/* assets/
	chown -R xophe:users assets || true

# SETUP & TOOLS
.PHONY: doctor
doctor:
	@echo "🩺 Validation environnement..."
	@echo "Flake: $(shell nix flake metadata --json 2>/dev/null | jq -r .description 2>/dev/null || echo 'ERROR: flake invalide')"
	@echo "Host: $(FLAKE_HOST)"
	@echo "Syncdir: $(SYNCDIR) $(shell [ -d $(SYNCDIR) ] && echo '✅' || echo '❌')"

.PHONY: setup
setup: $(SYNCDIR) $(SRCHOME)

$(SRCHOME):
	@echo "🔗 Créer lien $(SRCHOME)..."
	@-ln -s ${PWD} $(SRCHOME)

$(SYNCDIR):
	$(error ❌ $(SYNCDIR) absent, configurer syncthing d'abord)

# UTILITAIRES GPG/YUBIKEY (inchangés)
.PHONY: setup-gpg yubikey-renew yubikey-restart setup-lockscreen

# Référence: https://github.com/drduh/YubiKey-Guide#renewing-sub-keys
setup-gpg:
	@echo "🔐 Setup GPG + Yubikey..."
	gpg --import extra/gnupg/gpg-0xB151572DE8FADB71-2024-06-26.asc
	gpg --card-status
	@echo -e "\n🔑 Trust la clé importée:\ngpg -K\ngpg --edit-key 0xB151572DE8FADB71\ngpg> trust\ngpg> quit"

yubikey-renew:
	extra/gnupg/renew-subkeys.sh

yubikey-restart:
	gpg-connect-agent killagent /bye
	gpg-connect-agent "scd serialno" "learn --force" /bye
	gpg --card-status

setup-lockscreen:
	betterlockscreen -u $(HOME)/desktop/pictures/walls --blur 1

# MIGRATION INFO
.PHONY: migration-info
migration-info:
	@echo "📋 Migration vers Flakes - Status:"
	@echo "   ✅ flake.nix créé"
	@echo "   ✅ Makefile adapté"
	@echo "   ⏳ Tests à effectuer: make check && make build"
	@echo "   📖 Guide: cat guide-flakes.md"
