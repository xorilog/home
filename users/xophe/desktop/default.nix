{ pkgs, nixosConfig, ... }:

{
  imports = [
    ./firefox.nix
    ./gtk.nix
    ./mpv.nix
    # ./i3.nix
    # ./mpd.nix
    ./redshift.nix
    # ./xsession.nix
    ./communication-tools.nix
  ];
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
    xdg_utils
    xsel
    # TODO make this an option
    obs-studio
    # FIXME move this elsewhere
    keybase
    # pass
    profile-sync-daemon
  ]; # ++ lib.optionals nixosConfig.profiles.desktop.i3.enable [ pkgs.brave ];

  # obs-v4l2sink is integrated into upstream OBS since version 26.1
  #xdg.configFile."obs-studio/plugins/obs-v4l2sink/bin/64bit/obs-v4l2sink.so".source =
  #  "${pkgs.obs-v4l2sink}/share/obs/obs-plugins/v4l2sink/bin/64bit/v4l2sink.so";
  home.file.".XCompose".source = ./xorg/XCompose;
  # home.file.".Xmodmap".source = ./xorg/Xmodmap;
  xdg.configFile."xorg/emoji.compose".source = ./xorg/emoji.compose;
  xdg.configFile."xorg/parens.compose".source = ./xorg/parens.compose;
  xdg.configFile."xorg/modletters.compose".source = ./xorg/modletters.compose;

  /*
    xdg.configFile."nr/desktop" = {
    text = builtins.toJSON [
    { cmd = "peek"; }
    { cmd = "shutter"; }
    { cmd = "station"; }
    { cmd = "dmenu"; }
    { cmd = "sxiv"; }
    { cmd = "screenkey"; }
    { cmd = "gimp"; }
    { cmd = "update-desktop-database"; pkg = "desktop-file-utils"; chan = "unstable"; }
    { cmd = "lgogdownloader"; chan = "unstable"; }
    { cmd = "xev"; pkg = "xorg.xev"; }
    ];
    onChange = "${pkgs.my.nr}/bin/nr desktop";
    };
  */
}
