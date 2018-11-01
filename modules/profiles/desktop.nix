{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.desktop;
in
{
  options = {
    profiles.desktop = {
      enable = mkOption {
        default = false;
        description = "Enable desktop profile";
        type = types.bool;
      };
      xsession = {
        enable = mkOption {
          default = true;
          description = "Enable xsession managed";
          type = types.bool;
        };
        i3 = mkOption {
           default = true;
           description = "Enable i3 managed window manager";
           type = types.bool;
        };
      };
      
    };
  };
  config = mkIf cfg.enable {
    xsession = mkIf cfg.xsession.enable {
      enable = true;
      initExtra = ''
        ${pkgs.xlibs.xmodmap}/bin/xmodmap ~/.Xmodmap &
      '';
      pointerCursor = {
        package = pkgs.vanilla-dmz;
        name = "Vanilla-DMZ";
      };
    };
    home.keyboard = mkIf cfg.xsession.enable {
      layout = "fr(bepo),fr";
      variant = "oss";
      options = ["grp:menu_toggle" "grp_led:caps" "compose:caps"];
    };
    gtk = {
      enable = true;
      iconTheme = {
        name = "Arc";
        package = pkgs.arc-icon-theme;
      };
      theme = {
        name = "Arc-Dark";
        package = pkgs.arc-theme;
      };
    };
    services = {
      redshift = {
        enable = true;
        brightness = { day = "1"; night = "0.9"; };
        latitude = "48.3";
        longitude = "7.5";
        tray = true;
      };
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        defaultCacheTtlSsh = 7200;
      };
    };
    home.file.".XCompose".source = ./assets/xorg/XCompose;
    home.file.".Xmodmap".source = ./assets/xorg/Xmodmap;
    xdg.configFile."xorg/emoji.compose".source = ./assets/xorg/emoji.compose;
    xdg.configFile."xorg/parens.compose".source = ./assets/xorg/parens.compose;
    xdg.configFile."xorg/modletters.compose".source = ./assets/xorg/modletters.compose;
    xdg.configFile."user-dirs.dirs".source = ./assets/xorg/user-dirs.dirs;
    programs = {
      firefox.enable = true;
    };
    profiles.i3.enable = cfg.xsession.i3;
    home.packages = with pkgs; [
      keybase
      peco
      #etBook
      gnome3.defaultIconTheme
      gnome3.gnome_themes_standard
      xdg-user-dirs
      xdg_utils
    ];
  };
}
