_: {
  networking.firewall.checkReversePath = false;
  virtualisation.podman.enable = true;
  virtualisation.containers = {
    enable = true;
    # registries.conf V2 format (V1 `registries.search` dropped in Podman 6)
    registries.settings = {
      unqualified-search-registries = [
        "docker.io"
        "quay.io"
        "docker.pkg.github.com"
        "ghcr.io"
      ];
    };
    policy = {
      default = [ { type = "insecureAcceptAnything"; } ];
      transports = {
        docker-daemon = {
          "" = [ { type = "insecureAcceptAnything"; } ];
        };
      };
    };
    containersConf.settings = {
      network = {
        default_subnet_pools = [
          # See https://github.com/kubernetes-sigs/kind/issues/2872 for this
          {
            "base" = "11.0.0.0/24";
            "size" = 24;
          }
          {
            "base" = "192.168.129.0/24";
            "size" = 24;
          }
          {
            "base" = "192.168.130.0/24";
            "size" = 24;
          }
          {
            "base" = "192.168.131.0/24";
            "size" = 24;
          }
          {
            "base" = "192.168.132.0/24";
            "size" = 24;
          }
        ];
      };
    };
  };
}
