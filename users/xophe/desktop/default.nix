{ lib, pkgs, nixosConfig, ... }:

{
  imports = [
    ./audio.nix
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
    # libreoffice-fresh Failing and 2h33 to build.
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

  # TODO: Xophe cleanup all this to Xorg with i3.
  #programs.autorandr.enable = nixosConfig.profiles.laptop.enable;
  programs.autorandr.enable = nixosConfig.modules.hardware.laptop.enable;

  home.file.".XCompose".source = ./xorg/XCompose;
  # home.file.".Xmodmap".source = ./xorg/Xmodmap;
  xdg.configFile."xorg/emoji.compose".source = ./xorg/emoji.compose;
  xdg.configFile."xorg/parens.compose".source = ./xorg/parens.compose;
  xdg.configFile."xorg/modletters.compose".source = ./xorg/modletters.compose;

}
