# Desktop base configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Import avahi service
  imports = [ ../services/avahi.nix ];

  boot = {
    # /tmp to be tmpfs
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
    # Enable Plymouth for boot splash
    plymouth = {
      enable = true;
      theme = "deus_ex";
      themePackages = [ pkgs.adi1090x-plymouth ];
    };
  };

  # Configure fonts
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      cascadia-code
      corefonts
      dejavu_fonts
      feh
      fira
      fira-code
      fira-code-symbols
      fira-mono
      font-awesome
      go-font
      hack-font
      hasklig
      inconsolata
      iosevka
      jetbrains-mono
      liberation_ttf
      nerd-fonts.jetbrains-mono
      nerd-fonts.inconsolata
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.caskaydia-cove
      nerd-fonts.caskaydia-mono
      nerd-fonts.overpass
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono
      nerd-fonts.ubuntu-sans
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      noto-fonts
      overpass
      source-code-pro
      symbola
      twemoji-color-font
      ubuntu-classic
      unifont
      recursive
    ];
  };

  services = {
    envfs.enable = true;

    # Make /run/user/X larger
    logind.settings.Login.RuntimeDirectorySize = "20%";

    # Enable printing
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };
  };

  location.provider = "geoclue2";

  # Essential packages
  environment.systemPackages = with pkgs; [
    cryptsetup
    unzip
    gnupg
    pinentry-curses
    inxi
  ];
}
