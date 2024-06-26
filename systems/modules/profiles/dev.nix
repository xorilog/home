{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.dev;
in
{
  options = {
    profiles.dev = {
      enable = mkEnableOption "Enable dev profile";
    };
  };
  config = mkIf cfg.enable {
    profiles.git.enable = true;
    environment.systemPackages = with pkgs; [
      git
      tig
      grc
      ripgrep
      gnumake
      glab
    ];
  };
}
