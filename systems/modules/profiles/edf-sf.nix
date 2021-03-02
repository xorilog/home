{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.edf-sf;
in
{
  options = {
    profiles.edf-sf = {
      enable = mkEnableOption "Enable the EDF Store & Forecast profiles (Apps, VPN, certs, …)";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (google-chrome.override {
        commandLineArgs = "--auth-negotiate-delegate-whitelist='*.redhat.com'";
      })
      libnotify
    ];
    # NetworkManager
    environment.etc."NetworkManager/system-connections/1-EDF-SF-VPN.ovpn" = {
      source = pkgs.mkSecret ../../../secrets/etc/NetworkManager/system-connections/1-EDF-SF-VPN.ovpn;
      mode = "0600";
    };
  };
}
