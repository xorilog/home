{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.i3;
in
{
  options = {
    modules.desktop.i3 = {
      enable = mkEnableOption "Enable i3 desktop profile";
    };
  };

  config = mkIf cfg.enable {
    # Enable desktop modules if not already
    modules.desktop.enable = true;
    services = {
      blueman.enable = true;
      autorandr.enable = true;
      xserver = {
        displayManager = {
          defaultSession = "none+i3";
          lightdm.enable = true;
          lightdm.greeters.pantheon.enable = true;
        };
        windowManager.i3.enable = true;
      };
      dbus = {
        enable = true;
        # socketActivated = true;
        packages = [ pkgs.gnome3.dconf ];
      };
    };
  };
}
