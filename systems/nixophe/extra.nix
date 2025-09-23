# Configuration extra spécifique à nixophe (pattern vdemeester)
{ inputs, config, pkgs, lib, ... }:
{
  # Imports directs modules common (pattern vdemeester)
  imports = [
    # Hardware laptop (déjà géré par hardware/default.nix conditionnel)
    # Services requis
    ../common/services/avahi.nix
    ../common/services/syncthing.nix  
    ../common/services/tailscale.nix
    # Development
    ../common/dev
    ../common/virtualisation
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
  environment.variables.EDITOR = "vim";
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

  # Version système
  system.stateVersion = "22.05";
}