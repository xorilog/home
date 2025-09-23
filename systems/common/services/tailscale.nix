# Tailscale configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:
{
  # Enable the tailscale daemon
  services.tailscale.enable = true;

  # Add the Tailscale package
  environment.systemPackages = [ pkgs.tailscale ];

  # Trust the tailscale interface
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Open the UDP port for tunnel traffic
  networking.firewall.allowedUDPPorts = [ 41641 ];
}
