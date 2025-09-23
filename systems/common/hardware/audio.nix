# Audio configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:

let
  inherit (lib) versionOlder;
  stable = versionOlder config.system.nixos.release "24.05";
in
{
  # Audio limits for low-latency
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile"; type = "-"; value = "99999"; }
  ];

  # Pipewire (modern audio)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
    } // (if stable then { } else {
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
          bluez_monitor.properties = {
            ["bluez5.enable-sbc-xq"] = true,
            ["bluez5.enable-msbc"] = true,
            ["bluez5.enable-hw-volume"] = true,
            ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
          }
        '')
      ];
    });
  } // (if stable then { } else {
    extraConfig = {
      pipewire-pulse = {
        "50-network-party.conf" = {
          "context.exec" = [
            { path = "pactl"; args = "load-module module-native-protocol-tcp"; }
            { path = "pactl"; args = "load-module module-zeroconf-discover"; }
            { path = "pactl"; args = "load-module module-zeroconf-publish"; }
          ];
        };
      };
    };
  });

  # Firewall for audio streaming
  networking.firewall.allowedTCPPorts = [ 6001 6002 ];

  # Audio packages
  environment.systemPackages = with pkgs; [
    apulse
    pavucontrol
    pasystray
    pulseaudioFull
  ];
}
