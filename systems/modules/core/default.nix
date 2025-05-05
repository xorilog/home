{
  imports = [
    ./config.nix
    ./home-manager.nix
    ./nix.nix
    ./nur.nix
    ./users.nix
    ./i18n.nix
  ];

  boot = {
    tmp = {
      cleanOnBoot = true;
    };
  };
}
