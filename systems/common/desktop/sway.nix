# Sway desktop configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Bluetooth support
  hardware.bluetooth.enable = true;

  # Sway compositor session
  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  # Sway configuration
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      alacritty
      swaylock
      swayidle
      dmenu
      wofi
      xwayland
      mako
      kanshi
      grim
      slurp
      wl-clipboard
      wf-recorder
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  # X server and display manager
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "intl";
      };
    };
    displayManager = {
      defaultSession = "sway";
      sddm.enable = true;
    };
    libinput.enable = true;
  };
}
