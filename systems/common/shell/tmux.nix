# Tmux configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    escapeTime = 0;
    terminal = "tmux-256color";
  };
}
