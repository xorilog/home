{ config, pkgs, ... }:

{
  xsession = {
    enable = true;
    # by xophe
    #initExtra = ''
    #  ${pkgs.xorg.xmodmap}/bin/xmodmap ${config.home.homeDirectory}.Xmodmap &
    #'';
    #pointerCursor = {
    #  package = pkgs.vanilla-dmz;
    #  name = "Vanilla-DMZ";
    #};
  };
}
