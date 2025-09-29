# ZSH configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
}
