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
    # TODO: Xophe to activate after migration to modules.
    #modules.editors.vim.enable = true;
    #modules.shell = {
    #  direnv.enable = true;
    #  git.enable = true;
    #  gnupg.enable = true;
    #  tmux.enable = true;
    #};
    # Enable lorri (to handle nix shells)
    # services.lorri.enable = true;
    environment.systemPackages = with pkgs; [
      grc
      ripgrep
      gnumake
      glab
    ];
  };
}
