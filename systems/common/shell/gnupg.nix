# GnuPG configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:
{
  environment = {
    # GNUPGHOME est défini dans home-manager où XDG_CONFIG_HOME est disponible
    # variables.GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
    systemPackages = [ pkgs.gnupg ];
  };
}
