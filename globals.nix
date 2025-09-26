{ lib, hostname ? "", ... }:

{
  # Configuration SSH
  ssh = {
    xophe = [
      # TODO: ajouter clés SSH publiques
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmfwv6v+lgaQCzA1k8pYf34OxdogFv3wOfeqijYyaZv xophe@nixophe"
    ];
  };

  # Dossiers Syncthing globaux
  syncthingFolders = {
    "desktop/downloads" = {
      id = "2rywy-e5ihq";
      path = "/home/xophe/desktop/downloads";
    };
    "sync/nixos/personal" = {
      id = "3diwf-efmxi";
      path = "~/sync/nixos/personal";
    };
    "AGS-backup-src" = {
      id = "bioq2-kpano";
      path = "~/backup-src";
    };
    "desktop/pictures" = {
      id = "cwjhv-udzcr";
      path = "/home/xophe/desktop/pictures/";
    };
    "sync/password-store" = {
      id = "mfx6g-mvdkx";
      path = "/home/xophe/sync/password-store";
    };
    "edf-sf/documents" = {
      id = "mlqav-6dtms";
      path = "/home/xophe/desktop/documents/";
    };
    "sync/nixos/edf-sf" = {
      id = "nrngx-z7hsp";
      path = "/home/xophe/sync/nixos/edf-sf";
    };
    # TODO: ajouter autres dossiers selon besoins
  };

  # Configuration réseau
  net = {
    dns = {
      cacheNetworks = [
        "192.168.1.0/24"
        "10.0.0.0/8"
      ];
    };
  };

  # Informations machines (pattern vdemeester enrichi)
  machines = {
    nixophe = {
      # Informations système
      system = "x86_64-linux";
      # TODO: need to validate this as i expect this to be in the flake.nix file.
      #desktop = "i3";
      hardware = "laptop";

      # Configuration réseau
      net = {
        ips = [ "192.168.1.100" ]; # TODO: IP réelle
        names = [
          "nixophe.home"
          "nixophe.local"
        ];
        # vpn = {
        #   pubkey = ""; # TODO: avec agenix
        #   ips = [ "10.100.0.10" ];
        # };
      };

      # Configuration SSH
      ssh = {
        hostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDXXHBxfD7fzH63//jkvgLXICqdzYr088lC/+ynU9ogD root@nixophe"; # TODO: ajouter host key
      };

      # Configuration Syncthing
      syncthing = {
        id = "2GFNKHR-3FQTWPG-2WD6LCJ-UIW2PN6-NHWXXYC-5KPJLCS-5STOU5R-MFI3XQI"; # TODO: ID Syncthing réel
        folders = {
          "desktop/downloads" = {
            type = "sendreceive";
          };
          "sync/nixos/personal" = {
            type = "sendreceive";
          };
          "AGS-backup-src" = {
            type = "sendreceive";
          };
          "desktop/pictures" = {
            type = "sendreceive";
          };
          "sync/password-store" = {
            type = "sendreceive";
          };
          "edf-sf/documents" = {
            type = "sendreceive";
          };
          "sync/nixos/edf-sf" = {
            type = "sendreceive";
          };
        };
      };
    };
  };

  # Utilisateurs système
  users = {
    xophe = {
      uid = 1000;
      description = "Christophe Boucharlat";
      shell = "zsh";
    };
  };
}
