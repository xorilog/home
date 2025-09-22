{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.base.base;
in
{
  options = {
    modules.base.base = {
      enable = mkOption {
        default = true;
        description = "Enable base system configuration";
        type = types.bool;
      };
    };
  };
  config = mkIf cfg.enable {
    environment = {
      variables = {
        EDITOR = pkgs.lib.mkOverride 0 "vim";
      };
      systemPackages = with pkgs; [
        file
        htop
        iotop
        lsof
        netcat
        psmisc
        pv
        tree
        vim
        wget
      ];
    };
    security.sudo = {
      extraConfig = ''
        Defaults env_keep += SSH_AUTH_SOCK
      '';
    };
  };
}