{ config, lib, pkgs, ... }:
let
  shellConfig = import ./shell.nix { inherit config lib pkgs; };
in
{
  home.packages = [
    pkgs.eza
  ];
  programs.bash = {
    enable = true;
    historyControl = [ "erasedups" "ignorespace" ];
    historyFile = "${config.xdg.dataHome}/bash_history";
    historyFileSize = shellConfig.historySize;
    historySize = shellConfig.historySize;
    shellAliases = shellConfig.aliases;
  };
}
