{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.base.development;
in
{
  options = {
    modules.base.development = {
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