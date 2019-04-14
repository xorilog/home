{ config, pkgs, ... }:

with import ../assets/machines.nix; {
  imports = [ ../hardware/dell-latitude-e6540.nix ./home.nix ];
  networking = {
    enableIPv6 = false;
    firewall.allowedTCPPorts = [ 3389 2375 7946 9000 80 ];
    firewall.allowPing = true;
  };
  profiles = {
    avahi.enable = true;
    dev.enable = true;
    nix-config.buildCores = 4;
    ssh.enable = true;
    syncthing.enable = true;
  };
  services = {
    logind.lidSwitch = "ignore";
    syncthing-edge.guiAddress = "${wireguard.ips.honshu}:8384";
    wireguard = {
      enable = true;
      ips = [ "${wireguard.ips.honshu}/24" ];
      endpoint = wg.endpointIP;
      endpointPort = wg.listenPort;
      endpointPublicKey = wireguard.kerkouane.publicKey;
    };
  };

  # -----------------------------------
  environment.etc."vrsync".text = ''
/home/vincent/desktop/pictures/screenshots/ vincent@synodine.local:/volumeUSB2/usbshare/pictures/screenshots/
/home/vincent/desktop/pictures/wallpapers/ vincent@synodine.local:/volumeUSB2/usbshare/pictures/wallpapers/
/home/vincent/desktop/pictures/photos/ vincent@synodine.local:/volumeUSB2/usbshare/pictures/photos/
/home/vincent/desktop/documents/ vincent@synodine.local:/volume1/documents/
/run/media/vincent/FcCuir/music/ vincent@synodine.local:/volumeUSB2/usbshare/music/
  '';
  systemd.services.vrsync = {
    description = "vrsync - sync folders to NAS";
    wantedBy = [ "multi-user.target" ];
    restartIfChanged = false;
    startAt = "daily";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.vrsync}/bin/vrsync";
      Environment = "PATH=/run/current-system/sw/bin";
      OnFailure = "status-email-root@%n.service";
    };
  };
}
