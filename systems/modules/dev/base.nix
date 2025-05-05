{ config, lib, pkgs, ... }:

let
  cfg = config.modules.dev;
  inherit (lib) mkEnableOption mkIf;
in
{
  options = {
    modules.dev = {
      enable = mkEnableOption "Mark this machine as a dev machine";
    };
  };
  config = mkIf cfg.enable {
    modules.editors.vim.enable = true;
    modules.shell = {
      direnv.enable = true;
      git.enable = true;
      # TODO: To review, current location of the gnupg folder is at $HOME not $XDG_CONFIG_HOME/gnupg
      gnupg.enable = false;
      tmux.enable = true;
    };
    # Enable lorri (to handle nix shells)
    # services.lorri.enable = true;
    environment.systemPackages = with pkgs; [
      grc
      ripgrep
      gnumake
    ];
  };
}
