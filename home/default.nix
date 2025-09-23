{ config, lib, pkgs, ... }:

{
  imports = [
    ./common
  ];

  # Configuration home-manager de base
  programs.home-manager.enable = true;
}