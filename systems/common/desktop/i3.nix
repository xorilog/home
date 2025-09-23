# i3 desktop configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:
{
  # Import required modules
  imports = [
    ./xorg.nix
    ../hardware/audio.nix
  ];

  services = {
    blueman.enable = true;
    autorandr.enable = true;
    displayManager.defaultSession = "none+i3";
    displayManager.sddm.enable = true;
    xserver = {
      windowManager.i3.enable = true;
    };
    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };
  };
  
  programs.dconf.enable = true;
}
