{ config, lib, pkgs, ... }:

with lib; {
  users.users.root = {
    shell = mkIf config.programs.zsh.enable pkgs.zsh;
  };
  
  # Configuration home-manager pour root (config de base)
  home-manager.users.root = import ../../../home/common;
}