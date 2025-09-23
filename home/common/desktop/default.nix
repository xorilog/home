{ config, lib, pkgs, nixosConfig, desktop, ... }:

let
  inherit (lib) optionals;
in
{
  imports = [
    ./audio.nix
    ./firefox.nix
    ./gtk.nix
    ./mpv.nix
    ./gammastep.nix
    ./communication-tools.nix
    ./claude.nix
  ]
  ++ optionals (desktop == "i3") [ ./i3.nix ./xorg.nix ]
  ++ optionals (desktop == "sway") [ ./sway.nix ];

  home.sessionVariables = { WEBKIT_DISABLE_COMPOSITING_MODE = 1; };
  home.packages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.fr
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.en_GB-ize
    hunspellDicts.fr-any
    #wmctrl
    #xclip
    xdg-user-dirs
    xdg-utils
    xsel
    # TODO make this an option
    obs-studio
    # pass
    playerctl
    profile-sync-daemon
  ];

  home.file.".XCompose".source = ./xorg/XCompose;
  # home.file.".Xmodmap".source = ./xorg/Xmodmap;
  xdg.configFile."xorg/emoji.compose".source = ./xorg/emoji.compose;
  xdg.configFile."xorg/parens.compose".source = ./xorg/parens.compose;
  xdg.configFile."xorg/modletters.compose".source = ./xorg/modletters.compose;

}
