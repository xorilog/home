{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.tailscale;
in
{
  options = {
    profiles.tailscale = {
      enable = mkEnableOption "Whether to enable tailscale.";
      port = mkOption {
        default = 41641;
        type = with types; int;
        description = ''
          The port to listen on for tunnel traffic
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    # Enable the tailscale daemon; this will do a variety of tasks:
    services.tailscale = { enable = true; };

    # Add the Tailscale https://tailscale.com/ package.
    environment.systemPackages = [ pkgs.tailscale ];

    # Trust the tailscale interface
    networking.firewall.trustedInterfaces = [ "tailscale0" ];

    # Let's open the UDP port with which the network is tunneled through
    networking.firewall.allowedUDPPorts = [ cfg.port ];
  };
}
