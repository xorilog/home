{ config, lib, pkgs, nixosConfig, ... }:

{
  # home.file.".Xmodmap".source = ./xorg/Xmodmap;
  programs.autorandr.enable = nixosConfig.modules.hardware.laptop.enable;
}
