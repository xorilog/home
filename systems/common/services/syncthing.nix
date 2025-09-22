{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.syncthing;
in
{
  options = {
    modules.services.syncthing = {
      enable = mkEnableOption "Enable syncthing profile";
      guiAddress = mkOption {
        type = types.str;
        default = "127.0.0.1:8384";
        description = ''
          The address to serve the web interface at.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = "xophe";
      dataDir = "/home/xophe/.syncthing";
      configDir = "/home/xophe/.syncthing";
      guiAddress = cfg.guiAddress;
      #openDefaultPorts = true;
    };
  };
}
