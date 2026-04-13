# Git configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment = {
    # Git packages
    systemPackages = with pkgs; [
      glab
      git
      git-annex
      git-extras
      git-crypt
    ];
  };
}
