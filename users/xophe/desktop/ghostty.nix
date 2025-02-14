{ config, nixosConfig, lib, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      #(builtins.getFlake "github:ghostty-org/ghostty").packages.${builtins.currentSystem}.ghostty
      (builtins.getFlake "git+ssh://git@github.com/ghostty-org/ghostty?ref=main").packages.${builtins.currentSystem}.ghostty
    ];
  };
}
