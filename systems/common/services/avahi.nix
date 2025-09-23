# Avahi configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:

let
  inherit (lib) versionOlder;
  stable = versionOlder config.system.nixos.release "24.05";
in
{
  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    publish = {
      enable = true;
      userServices = true;
    };
    openFirewall = true;
  } // (if stable
  then {
    nssmdns = true;
  } else {
    nssmdns4 = true;
  });
}
