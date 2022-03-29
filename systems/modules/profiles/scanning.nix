{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.scanning;
in
{
  options = {
    profiles.scanning = {
      enable = mkEnableOption "Enable scanning profile";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sane-frontends
      sane-backends
      simple-scan
    ];
    hardware.sane = {
      enable = true;
      # FIXME When i'll get a scanner / printer...
      #extraConfig = { "pixma" = "bjnp://192.168.1.16"; };
    };
  };
}
