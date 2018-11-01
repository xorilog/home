{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.dev;
in
{
  options = {
    profiles.dev = {
      enable = mkOption {
        default = false;
        description = "Enable development profile";
        type = types.bool;
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      profiles.git.enable = true;
      profiles.emacs.enable = true;
      home.packages = with pkgs; [
        binutils-unwrapped
        cmake
        fswatch
        gnumake
        lnav
        mercurial
        ripgrep
        shfmt
      ];
    }
    (mkIf config.profiles.fish.enable {
      programs.fish.shellAbbrs = {
        m = "make";
      };
    })
  ]);
}
