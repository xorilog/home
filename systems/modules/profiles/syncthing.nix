{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.syncthing;
in
{
  options = {
    profiles.syncthing = {
      enable = mkEnableOption "Enable syncthing profile";
    };
  };
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = "xophe";
      dataDir = "/home/xophe/.syncthing";
      configDir = "/home/xophe/.syncthing";
      openDefaultPorts = true;
    };
  };
}
