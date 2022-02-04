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
        enable = true;
        displayManager.defaultSession = "none+i3";
        displayManager.sddm.enable = true;
        # Might break sway
        displayManager.sessionCommands = ''
          ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0
        '';
        layout = "us";
        libinput.enable = true;
        xkbVariant = "intl";
        windowManager.i3.enable = true;
      };
      dbus = {
        enable = true;
        # socketActivated = true;
        packages = [ pkgs.dconf ];
      };
    };
    programs.dconf.enable = true;
  };
}
