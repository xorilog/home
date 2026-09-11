{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopDirectory = config.home.homeDirectory + "/desktop";
in
{
  xdg = {
    enable = true;

    configHome = config.home.homeDirectory + "/.config";
    cacheHome = config.home.homeDirectory + "/.local/cache";
    dataHome = config.home.homeDirectory + "/.local/share";
    stateHome = config.home.homeDirectory + "/.local/state";

    # xdg.userDirs is not supported on all platforms (e.g. Darwin),
    # so only enable it on Linux to avoid errors.
    userDirs = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      createDirectories = lib.mkDefault true;

      desktop = desktopDirectory;
      documents = desktopDirectory + "/documents";
      download = desktopDirectory + "/downloads";
      music = desktopDirectory + "/music";
      pictures = desktopDirectory + "/pictures";
      publicShare = desktopDirectory + "/www";
      templates = desktopDirectory + "/documents/templates";
      videos = desktopDirectory + "/videos";

      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${desktopDirectory}/pictures/screenshots";
      };
    };
  };
}
