# Configuration extra spécifique à xophe-mbp (Darwin)
{
  inputs,
  config,
  pkgs,
  lib,
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
}
