{ pkgs, ... }:

{
  imports = [
    ./dconf.nix
  ];
  home.sessionVariables = { WEBKIT_DISABLE_COMPOSITING_MODE = 1; };
  home.packages = with pkgs; [
    gnome.dconf-editor
    gnome.gnome-tweak-tool
    gnome.pomodoro
    gnome.gnome-boxes

    #gnome.gnome-documents
    gnome.gnome-nettool
    gnome.gnome-power-manager
    gnome.gnome-todo
    gnome.gnome-tweaks
    gnome.gnome-usage

    gnomeExtensions.sound-output-device-chooser
    my.gnome-shell-extension-shell
    my.gnome-bluetooth-quick-connect
    my.noannoyance
    my.nightthemeswitcher
    gnome.gnome-shell-extensions

    pop-gtk-theme
    pop-icon-theme
    pinentry-gnome
    # tilix

    aspell
    aspellDicts.en
    aspellDicts.fr
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.en_GB-ize
    hunspellDicts.fr-any
    wmctrl
    xclip
    xdg-user-dirs
    xdg-utils
    xsel
    # FIXME move this elsewhere
    keybase
    pass
    profile-sync-daemon
  ];

  home.file.".XCompose".source = ./xorg/XCompose;
  # xophe
  #home.file.".Xmodmap".source = ./xorg/Xmodmap;
  xdg.configFile."xorg/emoji.compose".source = ./xorg/emoji.compose;
  xdg.configFile."xorg/parens.compose".source = ./xorg/parens.compose;
  xdg.configFile."xorg/modletters.compose".source = ./xorg/modletters.compose;

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
}
