{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.keybase;
in
{
  options = {
    profiles.keybase = {
      enable = mkEnableOption "Enable keybase profile";
    };
  };
  config = mkIf cfg.enable {
    services.keybase.enable = true;
    services.kbfs = {
      enable = true;
      #enableRedirector = true;
    };
    environment.systemPackages = with pkgs; [ keybase kbfs keybase-gui ];
  };
}
