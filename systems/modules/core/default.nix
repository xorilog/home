{
  imports = [
    ./config.nix
    ./home-manager.nix
    ./nix.nix
    ./nur.nix
    ./users.nix
  ];

  boot = {
    tmp = {
      cleanOnBoot = true;
    };
  };
}
