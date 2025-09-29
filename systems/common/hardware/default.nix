{
  hardwareType ? "",
  lib,
  ...
}:
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./trusted-platform-module.nix
    ./sane-extra-config.nixos.nix
    ./yubikey.nix
  ]
  # Import conditionnel selon hardwareType (pattern vdemeester)
  ++ lib.optional (hardwareType == "laptop") ./laptop.nix;
}
