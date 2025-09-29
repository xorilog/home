# Vim editor configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment = {
    systemPackages = [ pkgs.vim ];
    shellAliases = {
      v = "vim";
    };
  };
}
