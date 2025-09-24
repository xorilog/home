# Base system configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      file
      htop
      iotop
      lsof
      netcat
      psmisc
      pv
      tree
      vim
      wget
    ];
  };

  security.sudo.extraConfig = ''
    Defaults env_keep += SSH_AUTH_SOCK
  '';
}
