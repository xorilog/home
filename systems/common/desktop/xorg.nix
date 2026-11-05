# Xorg desktop configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Import base desktop
  imports = [ ./base.nix ];

  # Extra packages for Xorg
  environment.systemPackages = with pkgs; [
    xmessage
    xmodmap
    xdpyinfo
    xhost
    xinit
    xss-lock
  ];

  services = {
    # Enable xserver
    libinput.enable = true;
    xserver = {
      enable = true;
      enableTCP = false;
      synaptics.enable = false;
      displayManager.sessionCommands = ''
        ${lib.getBin pkgs.xrandr}/bin/xrandr --setprovideroutputsource 1 0
      '';
      xkb = {
        layout = "us";
        variant = "intl";
      };
    };
  };
}
