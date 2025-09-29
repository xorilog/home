# Configuration hardware spécifique à nixophe
{
  config,
  pkgs,
  lib,
  modulesPath,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.dell-xps-13-9310
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.6") pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/141245d9-0df4-4627-bd29-e6a941150033";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0695-EB46";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/13f5f86e-b62d-4fa8-a945-9fc4682eb020"; } ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # Configuration hardware spécifique
  services.hardware.bolt.enable = true;

  # Graphics et drivers
  services.xserver.videoDrivers = [
    "displaylink"
    "modesetting"
  ];
  hardware.graphics.enable = true;

  # Packages système hardware
  environment.systemPackages = with pkgs; [
    virt-manager
    acpilight # Force xbacklight à fonctionner
  ];

  # Règles udev pour backlight
  services.udev.extraRules = ''
    # Rule for screen Backlight
    SUBSYSTEM=="backlight", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    # Rule for keyboard backlight
    SUBSYSTEM=="leds", ACTION=="add", KERNEL=="*::kbd_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
  '';
}
