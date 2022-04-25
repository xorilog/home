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
      extraConfig = { "maxify" = "bjnp://192.168.1.164"; };
    };
  };
}
