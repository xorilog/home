let
  sources = import ./nix;
  pkgs = sources.nixpkgs { };
  nixos-unstable = sources.pkgs-unstable { };
  nixos = sources.pkgs { };
  sops-nix = sources.sops.nix;
in
pkgs.mkShell
{
  name = "nix-config";
  buildInputs = with pkgs; [
    cachix
    morph
    niv
    nixos-generators
    nixpkgs-fmt
    sops
    libguestfs-with-appliance
  ];
  shellHook = ''
    export NIX_PATH="nixpkgs=${pkgs.path}:nixos=${nixos.path}:nixos-unstable=${nixos-unstable.path}"
  '';
}
