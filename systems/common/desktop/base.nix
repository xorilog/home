# Desktop base configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:
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
      theme = "spinner";
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
      fira
      fira-code
      fira-code-symbols
      fira-mono
      font-awesome
      inconsolata
      jetbrains-mono
      liberation_ttf
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-code-pro
      ubuntu_font_family
    ];
  };

  # Enable NetworkManager
  networking.networkmanager = {
    enable = lib.mkDefault true;
    unmanaged = [
      "interface-name:br-*"
      "interface-name:ve-*"
      "interface-name:veth-*"
    ]
    ++ lib.optionals config.networking.wireguard.enable [ "interface-name:wg0" ]
    ++ lib.optionals config.virtualisation.docker.enable [ "interface-name:docker0" ]
    ++ lib.optionals config.virtualisation.libvirtd.enable [ "interface-name:virbr*" ];
    plugins = with pkgs; [ networkmanager-openvpn ];
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
    pinentry
    inxi
  ];
}
