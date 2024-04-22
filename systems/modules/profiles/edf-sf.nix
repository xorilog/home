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
        commandLineArgs = "--enable-features=UseOzonePlatform --enable-gpu --ozone-platform=wayland";
      })
      libnotify
    ];
    # NetworkManager
    environment.etc."NetworkManager/system-connections/1-EDF-SF-VPN.ovpn" = {
      source = pkgs.mkSecret ../../../secrets/edf-sf/etc/NetworkManager/system-connections/1-EDF-SF-VPN.ovpn;
      mode = "0600";
    };
    # FIXME
    # required to use https://github.com/jonathanxd/openaws-vpn-client
    # Other option: https://gitlab.freedesktop.org/polkit/polkit/-/merge_requests/122
    #security.polkit.enable = true;
  };
}
