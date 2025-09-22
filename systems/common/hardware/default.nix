{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./laptop.nix
    ./trusted-platform-module.nix
    # remove "nixos"
    ./sane-extra-config.nixos.nix
    ./yubikey.nix
  ];
}
