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
  xdg.dataFile."atuin/key".source = ../../../secrets/personal/atuin/key;
}
