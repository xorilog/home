{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.pulseaudio;
in
{
  options = {
    profiles.pulseaudio = {
      enable = mkEnableOption "Enable pulseaudio profile";
      tcp = mkOption {
        default = false;
        description = "Enable pulseaudio tcp";
        type = types.bool;
      };
    };
  };
  config = mkIf cfg.enable {
    hardware = {
      pulseaudio = {
        enable = true;
        support32Bit = true;
        zeroconf = {
          discovery.enable = cfg.tcp;
          publish.enable = cfg.tcp;
        };
        tcp = {
          enable = cfg.tcp;
          anonymousClients = {
            allowAll = true;
            allowedIpRanges = [ "127.0.0.1" "10.0.0.0/24" ];
          };
        };
        package = pkgs.pulseaudioFull;
      };
    };

    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
      { domain = "@audio"; item = "nofile"; type = "-"; value = "99999"; }
    ];

    # spotify & pulseaudio
    networking.firewall = {
      allowedTCPPorts = [ 57621 57622 4713 ];
      allowedUDPPorts = [ 57621 57622 ];
    };
    environment.systemPackages = with pkgs; [
      apulse # allow alsa application to use pulse
      pavucontrol # pulseaudio volume control
      pasystray # systray application
      playerctl
    ];
  };
}
