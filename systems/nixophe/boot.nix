# Configuration boot spécifique à nixophe
{ config, pkgs, lib, ... }:
{
  # ZFS support  
  boot.supportedFilesystems = [ "zfs" ];
  
  # Host ID requis pour ZFS
  networking.hostId = "c8d9352c";

  # Bootloader systemd-boot
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Modules initrd pour Yubikey et stockage
  boot.initrd.kernelModules = [ 
    "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" 
    "uas" "usbcore" "usb_storage" 
  ];
  
  # Paramètres kernel
  boot.kernelParams = [ 
    "cgroup_no_v1=all" 
    "systemd.unified_cgroup_hierarchy=1" 
  ];

  # Configuration LUKS avec Yubikey
  boot.initrd.luks = {
    cryptoModules = [ "aes" "xts" "sha256" "sha512" "cbc" ];
    yubikeySupport = true;
    
    devices = {
      crypted = {
        device = "/dev/disk/by-uuid/abbdad3e-93b4-4b6e-989f-8fb8dda493b1";
        preLVM = true;
        yubikey = {
          slot = 2;
          gracePeriod = 30;
          twoFactor = true;
          keyLength = 64;
          saltLength = 16;
          storage = {
            device = "/dev/nvme0n1p1";
          };
        };
      };
    };
  };
}