{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.core.base;
in
{
  options = {
    modules.core.base = {
      enable = mkOption {
        default = true;
        description = "Enable base system configuration";
        type = types.bool;
      };
    };
  };
  config = mkIf cfg.enable {
    environment.pathsToLink = [
      "/share/nix-direnv"
    ];
    environment = {
      variables = {
        EDITOR = pkgs.lib.mkOverride 0 "vim";
      };
      systemPackages = with pkgs; [
        cachix
        direnv
        eza
        file
        htop
        iotop
        lsof
        netcat
        psmisc
        pv
        tmux
        tree
        vim
        wget
        gnumake
      ];
    };
    security.sudo = {
      extraConfig = ''
        Defaults env_keep += SSH_AUTH_SOCK
      '';
    };
  };
}