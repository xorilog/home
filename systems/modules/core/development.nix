{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.core.development;
in
{
  options = {
    modules.core.development = {
      enable = mkOption {
        default = true;
        description = "Enable development tools and environment";
        type = types.bool;
      };
    };
  };
  config = mkIf cfg.enable {
    environment.pathsToLink = [
      "/share/nix-direnv"
    ];
    environment.systemPackages = with pkgs; [
      cachix
      direnv
      eza
      tmux
      gnumake
    ];
  };
}