{ lib, pkgs, nixosConfig, ... }:

{
  imports = [
    ./firefox.nix
    ./gtk.nix
    ./mpv.nix
    ./redshift.nix
    ./communication-tools.nix
  ] ++ lib.optionals nixosConfig.profiles.desktop.i3.enable [ ./i3.nix ]
  ++ lib.optionals nixosConfig.profiles.desktop.sway.enable [ ./sway.nix ];

  home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };
  home.sessionVariables = { WEBKIT_DISABLE_COMPOSITING_MODE = 1; };
  home.packages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.fr
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.en_GB-ize
    hunspellDicts.fr-any
    libreoffice-fresh
    #wmctrl
    #xclip
    xdg-user-dirs
    xdg-utils
    xsel
    # TODO make this an option
    obs-studio
    # FIXME move this elsewhere
    keybase
    # pass
    profile-sync-daemon
  ];

  programs.autorandr.enable = nixosConfig.profiles.laptop.enable;

  home.file.".XCompose".source = ./xorg/XCompose;
  # home.file.".Xmodmap".source = ./xorg/Xmodmap;
  xdg.configFile."xorg/emoji.compose".source = ./xorg/emoji.compose;
  xdg.configFile."xorg/parens.compose".source = ./xorg/parens.compose;
  xdg.configFile."xorg/modletters.compose".source = ./xorg/modletters.compose;

}
