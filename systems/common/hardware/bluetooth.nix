# Bluetooth configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
}
