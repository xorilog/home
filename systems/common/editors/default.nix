# Editors configuration (pattern vdemeester)
{ config, lib, ... }:
{
  imports = [ ./vim.nix ];
  
  environment.variables = {
    EDITOR = lib.mkOverride 0 "vim";
  };
}
