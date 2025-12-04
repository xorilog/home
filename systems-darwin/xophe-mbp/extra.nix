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
  imports = [
    # Development
    ../../systems/common/dev

    # Shell & editors
    ../../systems/common/shell
    ../../systems/common/editors
  ];
  system.primaryUser = "xophe";

  # Minimal Darwin user; avoids NixOS-only bits (systemd, Linux groups, etc.)
  users.users.xophe = {
    name = "xophe";
    home = "/Users/xophe";
    shell = pkgs.zsh;
    # extraGroups = [ "wheel" ]; # add more if/when you define them on macOS
  };

  # Configuration système spécifique
  # networking = {
  #   hostName = "xophe-mbp";
  #   useDHCP = false;
  #   firewall.allowPing = true;
  #   firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  # };

  # Services système
  services = {
    tailscale.enable = true;
  };

  # Configuration système
  time.timeZone = "Europe/Paris";
  nixpkgs.config.allowUnfree = true;

  ## Configuration GPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    #    enableExtraSocket = true;
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
