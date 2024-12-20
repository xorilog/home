{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.base;
in
{
  options = {
    profiles.base = {
      enable = mkOption {
        default = true;
        description = "Enable base profile";
        type = types.bool;
      };
    };
  };
  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
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
