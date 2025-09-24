# Configuration hardware spécifique à nixophe
{ config, pkgs, lib, ... }:
{
  # Import hardware scan
  imports = [
    ../hardware/dell-xps-13-9310.nix
  ];
  
  # Configuration hardware spécifique
  services.hardware.bolt.enable = true;

  # Graphics et drivers
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  hardware.graphics.enable = true;

  # Packages système hardware
  environment.systemPackages = with pkgs; [
    virt-manager
    acpilight  # Force xbacklight à fonctionner
  ];

  # Règles udev pour backlight
  services.udev.extraRules = ''
    # Rule for screen Backlight
    SUBSYSTEM=="backlight", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    # Rule for keyboard backlight
    SUBSYSTEM=="leds", ACTION=="add", KERNEL=="*::kbd_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
  '';
}
