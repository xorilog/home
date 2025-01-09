{ pkgs, nixosConfig, ... }:

{
  home.sessionVariables = { WEBKIT_DISABLE_COMPOSITING_MODE = 1; };
  home.packages = with pkgs; [
    #zoom-us
    (zoom-us.overrideAttrs {
      version = "6.2.11.5069";
      src = pkgs.fetchurl {
        url = "https://zoom.us/client/6.2.11.5069/zoom_x86_64.pkg.tar.xz";
        hash = "sha256-k8T/lmfgAFxW1nwEyh61lagrlHP5geT2tA7e5j61+qw=";
      };
    })
    signal-desktop
    slack
    discord
  ];
}
