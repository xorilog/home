# EDF Store & Forecast configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (google-chrome.override {
      commandLineArgs = "--enable-features=UseOzonePlatform --enable-gpu --ozone-platform=wayland";
    })
    libnotify
  ];

  # NetworkManager VPN config (commented - requires secrets)
  # environment.etc."NetworkManager/system-connections/1-EDF-SF-VPN.ovpn" = {
  #   source = ../../../secrets/edf-sf/etc/NetworkManager/system-connections/1-EDF-SF-VPN.ovpn;
  #   mode = "0600";
  # };
}
