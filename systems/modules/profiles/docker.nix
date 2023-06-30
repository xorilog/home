{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.profiles.docker;
in
{
  options = {
    profiles.docker = {
      enable = mkEnableOption "Enable docker profile";
      package = mkOption {
        default = pkgs.docker;
        description = "docker package to be used";
        type = types.package;
      };
      runcPackage = mkOption {
        default = pkgs.runc;
        description = "runc package to be used";
        type = types.package;
      };
    };
  };
  config = mkIf cfg.enable {
    virtualisation = {
      containerd = {
        enable = true;
      };
      buildkitd = {
        enable = true;
        settings = {
          worker.oci = {
            enabled = false;
          };
          worker.containerd = {
            enabled = true;
            platforms = [ "linux/amd64""linux/arm64" ];
            namespace = "buildkit";
          };
          #registry = {
          #  "registry.svc.localhost:5000" = {
          #    http = true;
          #    insecure = true;
          #  };
          #};
        };
        #autostart = false;
        #extraOptions = "--oci-worker=false --containerd-worker=true";
      };
      docker = {
        enable = true;
        package = cfg.package;
        liveRestore = false;
        storageDriver = "overlay2";
        daemon.settings = {
          experimental = true;
          bip = "172.26.0.1/16";
          runtimes = {
            "docker-runc" = {
              path = "${cfg.runcPackage}/bin/runc";
            };
          };
          default-runtime = "docker-runc";
          containerd = "/run/containerd/containerd.sock";
          features = { buildkit = true; };
          #insecure-registries = [ "registry.svc.localhost:5000" ];
        };
      };
    };
    environment.systemPackages = with pkgs; [
      my.buildx
    ];
    networking.firewall.trustedInterfaces = [ "docker0" ];
  };
}
