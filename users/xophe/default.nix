{ config, lib, pkgs, ... }:
{
  users.users.xophe = {
    createHome = true;
    uid = 1000;
    description = "Christophe Boucharlat";
    extraGroups = [
      "wheel" # enable sudo
      "input" # touchpad FIXME need to remove that one
      "audio" "video" "networkmanager" # Desktop
      "lp" "scanner" # scanner stuff
      "docker"
      "buildkit"
      #"libvirtd"
      "systemd-journal"
    ];
    isNormalUser = true;
    home = "/home/xophe";
    initialPassword = "changeMe";
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
  };

  # To use nixos config in home-manager configuration, use the nixosConfig attr.
  # This make it possible to import the whole configuration, and let each module
  # load their own.
  home-manager.users.xophe = import ./home.nix;
}
