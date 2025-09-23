{ lib, hostname ? "", ... }:

{
  # Configuration globale du projet (pattern vdemeester)
  
  # Configuration SSH
  ssh = {
    xophe = [
      # TODO: ajouter clés SSH publiques
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIxxx xophe@nixophe"
    ];
  };
  
  # Dossiers Syncthing globaux (pattern vdemeester)  
  syncthingFolders = {
    sync = {
      id = "sync-folder-id";
      path = "/home/xophe/sync";
    };
    documents = {
      id = "docs-folder-id";
      path = "/home/xophe/documents";
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
        hostKey = ""; # TODO: ajouter host key
      };
      
      # Configuration Syncthing
      syncthing = {
        id = ""; # TODO: ID Syncthing réel
        folders = {
          sync = {
            type = "sendreceive";
          };
          documents = {
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
