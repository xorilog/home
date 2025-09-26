# Atuin configuration (pattern vdemeester)
{ config, ... }:
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
  
  # Configuration de la clé directement (sans agenix)
  # TODO: this has to be handled with agenix.
  #xdg.dataFile."atuin/key".source = ../../../secrets/personal/atuin/key;
}
