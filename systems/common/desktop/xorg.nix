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
    xorg.xmessage
    xorg.xmodmap
    xorg.xdpyinfo
    xorg.xhost
    xorg.xinit
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
        ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0
      '';
      xkb = {
        layout = "us";
        variant = "intl";
      };
    };
  };
}
