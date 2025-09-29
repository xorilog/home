{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
    # nix-update #FIXME only available on unstable for now
  ];
}
