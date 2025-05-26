{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.xorg.i3;
in
{
  options = {
    modules.desktop.xorg.i3 = {
      enable = mkEnableOption "Enable i3 desktop module";
    };
  };

  config = mkIf cfg.enable {
    # Enable xorg desktop modules if not already
    modules.desktop.xorg.enable = true;

    # Enable pipewire
    modules.hardware.audio = {
      enable = true;
      pipewire.enable = true;
    };

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
        # socketActivated = true;
        packages = [ pkgs.dconf ];
      };
    };
    programs.dconf.enable = true;
  };
}
