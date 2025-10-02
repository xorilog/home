{
  config,
  lib,
  pkgs,
  desktop,
  ...
}:

let
  inherit (lib) optionals;
in
{
  imports = [
    # FIXME why the infinite recusion
    (./. + "/${desktop}/default.nix")

    ./audio.nix
    ./firefox.nix
    ./gtk.nix
    ./mpv.nix
    ./gammastep.nix
    ./communication-tools.nix
    ./claude.nix

    ../dev/base.nix
    ../dev/desktop.nix
  ];

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
