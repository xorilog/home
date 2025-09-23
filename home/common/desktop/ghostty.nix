{ config, nixosConfig, lib, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      #(builtins.getFlake "github:ghostty-org/ghostty").packages.${builtins.currentSystem}.ghostty
      (builtins.getFlake "git+ssh://git@github.com/ghostty-org/ghostty?ref=refs/tags/v1.1.3").packages.${builtins.currentSystem}.ghostty
      #(builtins.getFlake "github:ghostty-org/ghostty/v1.1.3").packages.${builtins.currentSystem}.ghostty
      #(builtins.getFlake "git+ssh://git@github.com/ghostty-org/ghostty?ref=main").packages.${builtins.currentSystem}.ghostty
    ];
  };
}
