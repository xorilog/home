# Configuration boot spécifique à nixophe
{
  config,
  pkgs,
  lib,
  ...
}:
{
  # ZFS support
  boot.supportedFilesystems = [ "zfs" ];
  # Explicit (default flips to false in 26.11); keeps current boot behavior.
  boot.zfs.forceImportRoot = true;

  # Host ID requis pour ZFS
  networking.hostId = "c8d9352c";

  # Bootloader systemd-boot
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Modules initrd pour Yubikey et stockage
  boot.initrd.kernelModules = [
    "vfat"
    "nls_cp437"
    "nls_iso8859-1"
    "usbhid"
    "uas"
    "usbcore"
    "usb_storage"
  ];

  # Paramètres kernel
  boot.kernelParams = [
    "cgroup_no_v1=all"
    "systemd.unified_cgroup_hierarchy=1"
  ];

  # Configuration LUKS avec Yubikey
  boot.initrd.luks = {
    cryptoModules = [
      "aes"
      "xts"
      "sha256"
      "sha512"
      "cbc"
    ];

    devices = {
      crypted = {
        device = "/dev/disk/by-uuid/abbdad3e-93b4-4b6e-989f-8fb8dda493b1";
        # FIDO2 keyslot enrolled with systemd-cryptenroll (see docs/luks-fido2-migration.md);
        # falls back to the passphrase prompt if no key is present.
        crypttabExtraOpts = [ "fido2-device=auto" ];
      };
    };
  };
  # Note: scripted stage 1 (and its yubikey challenge-response LUKS unlock) was
  # removed from nixpkgs; systemd stage 1 is now the only initrd.
}
