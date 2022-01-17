{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.desktop.i3;
in
{
  options = {
    profiles.desktop.i3 = {
      enable = mkEnableOption "Enable i3 desktop profile";
    };
  };

  config = mkIf cfg.enable {
    profiles = {
      desktop.enable = true;
    };
    services = {
      blueman.enable = true;
      autorandr.enable = true;
      xserver = {
        displayManager = {
          defaultSession = "none+i3";
          # gdm.enable = true;
          # xophe
          lightdm.enable = true;
          lightdm.greeters.pantheon.enable = false;
          # Might break sway
          sessionCommands = ''
            ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0
          '';
        };
        windowManager.i3.enable = true;
      };
      dbus = {
        enable = true;
        # socketActivated = true;
        packages = [ pkgs.gnome3.dconf ];
      };
    };
    programs.dconf.enable = true;
  };
}
