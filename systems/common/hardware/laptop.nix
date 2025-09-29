# Laptop hardware configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  desktop,
  ...
}:
{
  # Sysctl options for laptops
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 25;
    "vm.dirty_background_ratio" = 10;
    "vm.dirty_writeback_centisecs" = 5000;
    "vm.dirty_expire_centisecs" = 5000;
  };

  # Laptop packages
  environment.systemPackages = with pkgs; [
    lm_sensors
    powertop
    acpi
  ];

  # Run nix-gc only when on AC power
  systemd.services.nix-gc.unitConfig.ConditionACPower = true;

  # Lid switch handling when docked/external power
  services.logind.settings.Login = {
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # Enable power-profiles-daemon if desktop environment
  services.power-profiles-daemon.enable = lib.mkIf (builtins.isString desktop) true;
}
