{ pkgs, ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      liveRestore = false;
      storageDriver = "overlay2";
      daemon.settings = {
        userland-proxy = true;
        experimental = true;
        bip = "172.26.0.1/16";
        features = {
          buildkit = true;
        };
        insecure-registries = [ ];
        # seccomp-profile = ./my-seccomp.json;
      };
    };
  };
  environment.systemPackages = with pkgs; [ docker-buildx ];
  networking.firewall.trustedInterfaces = [ "docker0" ];
  networking.firewall.checkReversePath = false;
}
