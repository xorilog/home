# Configuration extra spécifique à nixophe (pattern vdemeester)
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  # Imports directs modules common
  imports = [
    # Services requis
    ../common/services/avahi.nix
    ../common/services/syncthing.nix
    ../common/services/tailscale.nix
    ../common/services/networkmanager.nix

    # Containers & virtualisation
    ../common/services/containers.nix
    ../common/services/docker.nix
    ../common/services/libvirt.nix

    # Development
    ../common/dev
    # EDF-SF
    ../common/edf-sf
    # Shell & editors
    ../common/shell
    ../common/editors
  ];

  # Configuration système spécifique
  networking = {
    hostName = "nixophe";
    useDHCP = false;
    firewall.allowPing = true;
    firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };

  # Services système
  services = {
    gvfs.enable = true;

    # Configuration directe sans modules.*
    avahi.enable = true;
    tailscale.enable = true;
    syncthing.enable = true;
  };

  # Configuration système
  time.timeZone = "Europe/Paris";
  nixpkgs.config.allowUnfree = true;

  # Configuration GPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
  };

  # 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "xophe" ];
  };
}
