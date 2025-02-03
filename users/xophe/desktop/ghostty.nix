{ config, nixosConfig, lib, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      #(builtins.getFlake "github:ghostty-org/ghostty").packages.${builtins.currentSystem}.ghostty
      # Working based on main.
      #(builtins.getFlake "git+ssh://git@github.com/ghostty-org/ghostty?ref=main").packages.${builtins.currentSystem}.ghostty
      (builtins.getFlake "git+ssh://git@github.com/ghostty-org/ghostty?ref=v1.0.1").packages.${builtins.currentSystem}.ghostty
    ];
  };
}
