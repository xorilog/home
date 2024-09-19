{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.openvpn3;
in
{
  options = {
    profiles.openvpn3 = {
      enable = mkEnableOption "Whether to enable openvpn3.";
    };
  };
  config = mkIf cfg.enable {
    # Add the openvpn3 package
    environment.systemPackages = [ pkgs.openvpn3 ];

    # enable the openvpn3 client
    programs.openvpn3.enable = true;
  };
}
