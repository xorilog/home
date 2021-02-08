{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles;
in
{
  options = {
    profiles.kubernetes = {
      enable = mkEnableOption "Enable Kubernetes profile";
    };
    profiles.tekton = {
      enable = mkEnableOption "Enable Tekton profile";
    };
  };
}
