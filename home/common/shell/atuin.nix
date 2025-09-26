# Atuin configuration (pattern vdemeester)
{ config, lib, ... }:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      key_path = "${config.xdg.dataHome}/atuin/key";
      sync_frequency = "15m";
    };
    flags = [
      "--disable-up-arrow"
    ];
  };

  # Configuration de la clé avec agenix (si le secret existe)
  # Note: Le secret doit être défini dans systems/common/programs/agenix.nix
  # et le fichier de clé doit être créé avec: agenix -e atuin-key.age
  xdg.dataFile."atuin/key" = lib.mkIf (builtins.pathExists "/run/agenix/atuin-key") {
    source = "/run/agenix/atuin-key";
  };
}
