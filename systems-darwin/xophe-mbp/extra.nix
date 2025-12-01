# Configuration extra spécifique à xophe-mbp (Darwin)
{
  inputs,
  config,
  pkgs,
  lib,
  desktop,
  hostname,
  outputs,
  stateVersion,
  globals,
  libx,
  ...
}:
{
  system.primaryUser = "xophe";

  # Configuration système spécifique
  # networking = {
  #   hostName = "xophe-mbp";
  #   useDHCP = false;
  #   firewall.allowPing = true;
  #   firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  # };

  # Services système
  # services = {
  #   gvfs.enable = true;

  #   # Configuration directe sans modules.*
  #   avahi.enable = true;
  #   tailscale.enable = true;
  #   syncthing.enable = true;
  # };

  # Configuration système
  time.timeZone = "Europe/Paris";
  nixpkgs.config.allowUnfree = true;

  # Configuration GPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  home-manager.users.xophe = import ../../home/default.nix {
    inherit
      config
      pkgs
      lib
      hostname
      desktop
      globals
      outputs
      inputs
      stateVersion
      libx
      ;
    username = "xophe";
  };
}
