{
  config,
  nixosConfig,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.ghostty
    ];
  };
}
