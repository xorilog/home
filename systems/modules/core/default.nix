{
  imports = [
    ./boot.nix
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

    # Only keep the last 500MiB of systemd journal.
  services.journald.extraConfig = "SystemMaxUse=500M";
}
