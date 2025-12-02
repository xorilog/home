# Tmux configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.tmux =
    if pkgs.stdenv.isLinux then
      {
        enable = true;
        clock24 = true;
        escapeTime = 0;
        terminal = "tmux-256color";
      }
    else
      {
        enable = true;
      };
}
