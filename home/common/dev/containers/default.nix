{ pkgs, ... }:

{
  imports = [
    ./kubernetes.nix
  ];

  home.packages = with pkgs; [
    skopeo
    oras
    dive
  ];
}
