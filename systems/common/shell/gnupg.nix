# GnuPG configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:
{
  environment = {
    variables.GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
    systemPackages = [ pkgs.gnupg ];
  };
}
