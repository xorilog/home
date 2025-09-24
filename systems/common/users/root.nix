{ config, lib, pkgs, ... }:

with lib; {
  users.users.root = {
    shell = pkgs.zsh;
  };
}
