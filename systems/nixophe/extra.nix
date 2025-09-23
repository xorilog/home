# Configuration extra spécifique à nixophe (temporaire simplifiée)
{ inputs, config, pkgs, lib, ... }:
{
  # Configuration système spécifique
  networking = {
    hostName = "nixophe";
    useDHCP = false;
    firewall.allowPing = true;
    firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };

  # Services système essentiels
  services.gvfs.enable = true;

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
  
  # TODO: réintégrer modules après finalisation Point 5
}