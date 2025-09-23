# Containers development configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:
{
  # Firewall settings for containers
  networking.firewall = {
    checkReversePath = false;
    trustedInterfaces = [ "docker0" "podman" ];
  };

  # Base containers configuration
  virtualisation.containers = {
    enable = true;
    registries = {
      search = [ "docker.io" "quay.io" "docker.pkg.github.com" "ghcr.io" ];
    };
    policy = {
      default = [{ type = "insecureAcceptAnything"; }];
      transports = {
        docker-daemon = {
          "" = [{ type = "insecureAcceptAnything"; }];
        };
      };
    };
    containersConf.settings = {
      network = {
        default_subnet_pools = [
          { "base" = "11.0.0.0/24"; "size" = 24; }
          { "base" = "192.168.129.0/24"; "size" = 24; }
          { "base" = "192.168.130.0/24"; "size" = 24; }
        ];
      };
    };
  };

  # Docker and containerd
  virtualisation = {
    containerd.enable = true;
    buildkitd = {
      enable = true;
      settings = {
        grpc.address = [ "unix:///run/buildkit/buildkitd.sock" ];
        worker.oci.enabled = false;
        worker.containerd = {
          enabled = true;
          platforms = [ "linux/amd64" "linux/arm64" ];
          namespace = "buildkit";
        };
      };
    };
    docker = {
      enable = true;
      liveRestore = false;
      storageDriver = "overlay2";
      daemon.settings = {
        userland-proxy = false;
        experimental = true;
        bip = "172.26.0.1/16";
        runtimes."docker-runc".path = "${pkgs.runc}/bin/runc";
        default-runtime = "docker-runc";
        containerd = "/run/containerd/containerd.sock";
        features.buildkit = true;
      };
    };
    podman.enable = true;
  };

  # Container packages
  environment.systemPackages = with pkgs; [
    docker-buildx
  ];
}
