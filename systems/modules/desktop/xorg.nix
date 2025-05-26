{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.modules.desktop.xorg;
in
{
  options = {
    modules.desktop.xorg = {
      enable = mkEnableOption "Enable Xorg desktop";
    };
  };
  config = mkIf cfg.enable {
    modules.desktop.enable = true;
    # Extra packages to add to the system
    environment.systemPackages = with pkgs; [
      xorg.xmessage
      xorg.xmodmap
      # xorg.xbacklight
      xorg.xdpyinfo
      xorg.xhost
      xorg.xinit
      xss-lock
    ];

    services = {
      # Enable xserver on desktop
      libinput.enable = true;
      xserver = {
        enable = true;
        enableTCP = false;
        synaptics.enable = false;
         # Might break sway
        displayManager.sessionCommands = ''
          ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0
        '';
        xkb = {
          layout = "us";
          variant = "intl";
        };
      };
    };

  };
}
