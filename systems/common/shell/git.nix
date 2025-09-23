# Git configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:
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
    # Default gitconfig
    etc."gitconfig".source = ./git/config;
    etc."gitignore".source = ./git/ignore;
  };
}
