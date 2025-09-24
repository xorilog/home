{ config, lib, pkgs, nixosConfig, globals, hostname, ... }:

{
  # home.file.".Xmodmap".source = ./xorg/Xmodmap;
  # Enable autorandr for laptop hardware
  programs.autorandr.enable = 
    let 
      machine = globals.machines.${hostname} or {};
      hardware = machine.hardware or null;
    in 
    hardware == "laptop";
}
